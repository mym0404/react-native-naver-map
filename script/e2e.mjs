import { spawn } from 'node:child_process';
import { createWriteStream, existsSync } from 'node:fs';
import { mkdir } from 'node:fs/promises';
import { homedir } from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('../', import.meta.url));
process.chdir(root);
if (existsSync('.env')) process.loadEnvFile('.env');

const platform = process.argv[2];
const clientId = process.env.NAVER_MAP_CLIENT_ID?.trim();
const output = path.join(root, '.e2e');
const logDirectory = path.join(
  output,
  'logs',
  platform ?? 'local',
  `${Date.now()}-${process.pid}`
);
const bundleId = 'happy.mjstudio.rnnmap.example';
const pnpm = 'pnpm';
const androidSdk =
  process.env.ANDROID_HOME ??
  process.env.ANDROID_SDK_ROOT ??
  path.join(homedir(), 'Library/Android/sdk');
const adb = path.join(androidSdk, 'platform-tools/adb');
const env = {
  ...process.env,
  E2E_PLATFORM: platform,
  E2E_SESSION: `naver-map-${platform}-${process.pid}`,
  E2E_TELEMETRY_DISABLED: '1',
  AGENT_DEVICE_STATE_DIR: path.join(
    output,
    'device-state',
    `${platform}-${process.pid}`
  ),
};
let child;
let device;
let isOwnedDevice = false;
let isInterrupted = false;
let commandIndex = 0;

for (const signal of ['SIGINT', 'SIGTERM']) {
  process.on(signal, () => {
    isInterrupted = true;
    if (child?.pid) process.kill(-child.pid, 'SIGTERM');
  });
}

try {
  if (platform !== 'ios' && platform !== 'android') {
    throw new Error('Usage: pnpm e2e:ios | pnpm e2e:android');
  }
  if (!clientId || clientId === 'dummy') {
    throw new Error(
      'Set NAVER_MAP_CLIENT_ID in .env or the environment to a valid example-app client ID.'
    );
  }
  if (platform === 'ios' && process.platform !== 'darwin') {
    throw new Error(
      'iOS E2E requires macOS with Xcode and an installed iOS simulator runtime.'
    );
  }
  await mkdir(logDirectory, { recursive: true });

  if (platform === 'ios') {
    await run('xcodebuild', ['-version']);
    await run('pod', ['install'], { cwd: path.join(root, 'example/ios') });
    const build = path.join(output, 'build/ios');
    await run('xcodebuild', [
      '-workspace',
      'example/ios/example.xcworkspace',
      '-scheme',
      'example',
      '-configuration',
      'Release',
      '-sdk',
      'iphonesimulator',
      '-destination',
      'generic/platform=iOS Simulator',
      '-derivedDataPath',
      build,
      'CODE_SIGNING_ALLOWED=NO',
      'IPHONEOS_DEPLOYMENT_TARGET=15.1',
      `ARCHS=${process.arch === 'arm64' ? 'arm64' : 'x86_64'}`,
      `NAVER_MAP_CLIENT_ID=${clientId}`,
    ]);
    device = process.env.E2E_DEVICE;
    if (!device) {
      const { runtimes } = JSON.parse(
        await run('xcrun', ['simctl', 'list', 'runtimes', '--json'], {
          capture: true,
        })
      );
      const runtime =
        process.env.E2E_IOS_RUNTIME ??
        runtimes
          .filter(
            (runtime) =>
              runtime.isAvailable && runtime.identifier.includes('.iOS-')
          )
          .sort((a, b) =>
            b.version.localeCompare(a.version, undefined, { numeric: true })
          )[0]?.identifier;
      if (!runtime)
        throw new Error(
          'Install an iOS simulator runtime in Xcode Settings > Components.'
        );
      device = (
        await run(
          'xcrun',
          [
            'simctl',
            'create',
            `naver-map-e2e-${process.pid}`,
            'com.apple.CoreSimulator.SimDeviceType.iPhone-16',
            runtime,
          ],
          { capture: true }
        )
      ).trim();
      isOwnedDevice = true;
    }
    await run('xcrun', ['simctl', 'bootstatus', device, '-b']);
    await run(pnpm, [
      'exec',
      'agent-device',
      'boot',
      '--platform',
      'ios',
      '--udid',
      device,
    ]);
    await run('xcrun', [
      'simctl',
      'install',
      device,
      path.join(build, 'Build/Products/Release-iphonesimulator/example.app'),
    ]);
    await run('xcrun', [
      'simctl',
      'privacy',
      device,
      'grant',
      'location-always',
      bundleId,
    ]);
  } else {
    if (!existsSync(adb))
      throw new Error('Install the Android SDK and set ANDROID_HOME.');
    env.ANDROID_HOME = androidSdk;
    env.ANDROID_AVD_HOME = path.join(output, 'devices/android');
    await mkdir(env.ANDROID_AVD_HOME, { recursive: true });
    device = process.env.E2E_DEVICE;
    if (!device) {
      const tools = path.join(androidSdk, 'cmdline-tools/latest/bin');
      const arch = process.arch === 'arm64' ? 'arm64-v8a' : 'x86_64';
      const image = `system-images;android-36;google_apis;${arch}`;
      const avd = `naver_map_e2e_${arch.replaceAll('-', '_')}`;
      await run(path.join(tools, 'sdkmanager'), [image], { env });
      const avds = await run(
        path.join(androidSdk, 'emulator/emulator'),
        ['-list-avds'],
        { capture: true, env }
      );
      if (!avds.split('\n').includes(avd)) {
        await run(
          path.join(tools, 'avdmanager'),
          [
            'create',
            'avd',
            '--name',
            avd,
            '--package',
            image,
            '--device',
            'pixel_7',
          ],
          { input: 'no\n', env }
        );
      }
      await run(
        pnpm,
        [
          'exec',
          'agent-device',
          'boot',
          '--platform',
          'android',
          '--device',
          avd,
          '--headless',
        ],
        { env }
      );
      const devices = await run(adb, ['devices'], { capture: true });
      for (const line of devices
        .split('\n')
        .filter((line) => /^emulator-\d+\s+device$/.test(line.trim()))) {
        const serial = line.split('\t')[0];
        const name = await run(adb, ['-s', serial, 'emu', 'avd', 'name'], {
          capture: true,
        });
        if (name.split('\n')[0]?.trim() === avd) {
          device = serial;
          isOwnedDevice = true;
          break;
        }
      }
      if (!device) throw new Error(`Cannot find the booted ${avd} emulator.`);
    }
    const abi = (
      await run(adb, ['-s', device, 'shell', 'getprop', 'ro.product.cpu.abi'], {
        capture: true,
      })
    ).trim();
    await run(
      './gradlew',
      [
        ':app:assembleRelease',
        '--no-daemon',
        `-PreactNativeArchitectures=${abi}`,
        `-PnaverMapClientId=${clientId}`,
      ],
      { cwd: path.join(root, 'example/android'), env }
    );
    await run(adb, [
      '-s',
      device,
      'install',
      '-r',
      '-g',
      'example/android/app/build/outputs/apk/release/app-release.apk',
    ]);
  }

  env.E2E_DEVICE = device;
  await run(pnpm, ['exec', 'e2e', 'doctor', '--target', platform], { env });
  await run(pnpm, ['exec', 'e2e', 'run', '--target', platform], {
    env,
    stream: true,
  });
} catch (error) {
  console.error(error.message);
  process.exitCode = isInterrupted ? 130 : 1;
} finally {
  if (existsSync(env.AGENT_DEVICE_STATE_DIR)) {
    await run(pnpm, [
      'exec',
      'agent-device',
      'daemon',
      'stop',
      '--clean',
    ]).catch((error) => console.error(error.message));
  }
  if (device) {
    if (platform === 'ios') {
      await run('xcrun', [
        'simctl',
        'spawn',
        device,
        'log',
        'show',
        '--last',
        '5m',
        '--predicate',
        'process == "example"',
      ]).catch((error) => console.error(error.message));
      if (isOwnedDevice) {
        await run('xcrun', ['simctl', 'shutdown', device]).catch((error) =>
          console.error(error.message)
        );
        await run('xcrun', ['simctl', 'delete', device]).catch((error) =>
          console.error(error.message)
        );
      }
    } else {
      const pid = await run(adb, ['-s', device, 'shell', 'pidof', bundleId], {
        capture: true,
      }).catch(() => '');
      if (pid.trim())
        await run(adb, [
          '-s',
          device,
          'logcat',
          '-d',
          `--pid=${pid.trim()}`,
        ]).catch((error) => console.error(error.message));
      if (isOwnedDevice)
        await run(adb, ['-s', device, 'emu', 'kill']).catch((error) =>
          console.error(error.message)
        );
    }
  }
  if (isInterrupted) process.exitCode = 130;
}

async function run(executable, args, options = {}) {
  const label = path.basename(executable);
  const logPath = path.join(logDirectory, `${++commandIndex}-${label}.log`);
  console.log(`[e2e:${platform}] ${label} → ${path.relative(root, logPath)}`);
  const log = createWriteStream(logPath);
  let stdout = '';
  try {
    return await new Promise((resolve, reject) => {
      child = spawn(executable, args, {
        cwd: options.cwd ?? root,
        env: options.env ?? env,
        stdio: ['pipe', 'pipe', 'pipe'],
        detached: true,
      });
      child.stdout.on('data', (chunk) => {
        log.write(chunk);
        if (options.capture) stdout += chunk;
        if (options.stream) process.stdout.write(chunk);
      });
      child.stderr.pipe(log, { end: false });
      if (options.stream)
        child.stderr.on('data', (chunk) => process.stderr.write(chunk));
      child.on('error', reject);
      child.on('close', (code) => {
        child = undefined;
        if (code === 0) resolve(stdout);
        else
          reject(
            new Error(
              `${label} failed (${code}); see ${path.relative(root, logPath)}`
            )
          );
      });
      child.stdin.end(options.input);
    });
  } finally {
    await new Promise((resolve) => log.end(resolve));
  }
}

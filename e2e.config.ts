import { mobile } from '@e2e-dev/mobile';
import type { E2EConfig } from 'e2e';

const app = {
  bundleId: 'happy.mjstudio.rnnmap.example',
  permissions: { location: 'grant' },
} as const;

export default {
  tests: ['e2e/**/*.e2e.ts'],
  targets: (['ios', 'android'] as const).map((platform) => ({
    name: platform,
    engine: mobile({
      platform,
      device: process.env.E2E_DEVICE,
      session: process.env.E2E_SESSION ?? `naver-map-${platform}`,
    }),
    app: {
      ...app,
      appPath:
        platform === 'ios'
          ? '.e2e/build/ios/Build/Products/Release-iphonesimulator/example.app'
          : 'example/android/app/build/outputs/apk/release/app-release.apk',
    },
  })),
  workers: 1,
  retries: 0,
  timeout: 120_000,
  assertionTimeout: 30_000,
  output: `.e2e/results/${process.env.E2E_PLATFORM ?? 'local'}`,
  reporters: ['list', 'junit'],
  trace: 'retain-on-failure',
} satisfies E2EConfig;

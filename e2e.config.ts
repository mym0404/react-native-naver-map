import { mobile } from '@e2e-dev/mobile';
import type { E2EConfig } from 'e2e';

const isAuthFailure = process.env.E2E_SCENARIO === 'auth-failure';
const buildSuffix = isAuthFailure ? '-auth-failure' : '';
const app = {
  bundleId: `happy.mjstudio.rnnmap.example${isAuthFailure ? '.authfailure' : ''}`,
  permissions: { location: 'grant' },
} as const;

export default {
  tests: isAuthFailure
    ? ['e2e/auth/auth-failure.e2e.ts']
    : ['e2e/**/*.e2e.ts', '!e2e/auth/auth-failure.e2e.ts'],
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
          ? `.e2e/build/ios${buildSuffix}/Build/Products/Release-iphonesimulator/example.app`
          : `.e2e/build/android${buildSuffix}/app-release.apk`,
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

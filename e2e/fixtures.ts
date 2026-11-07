import { test as base, type InstalledApp } from '@e2e-dev/mobile';

export const test = base.extend<{ installedApp: InstalledApp }>({
  installedApp: async ({ device }, use) => {
    const installedApp = await device.installApp();
    const { client, platform, selection } = device.unstable_raw;
    await client.settings.update({
      ...selection,
      setting: 'permission',
      permission: platform === 'ios' ? 'location-always' : 'all',
      state: 'grant',
      app: installedApp.app,
    });
    await use(installedApp);
  },
});

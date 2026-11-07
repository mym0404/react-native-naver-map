import { expect } from 'e2e';
import { test } from '../fixtures';

const noEvents = '0';

test(
  'loads an authenticated map with a global failure listener',
  { timeout: 180_000 },
  async ({ app, screen }) => {
    await app.open();
    const menu = screen.getByTestId('example-menu-auth-failure');
    await expect(menu).toBeVisible({ timeout: 120_000 });
    await menu.tap();
    await expect(screen.getByTestId('auth-failure-map-status')).toHaveText(
      'loaded'
    );
    await expect(screen.getByTestId('auth-failure-count')).toHaveText(noEvents);
    await expect(screen.getByTestId('auth-failure-code')).toHaveText('waiting');
    await expect(screen.getByTestId('auth-failure-removed-count')).toHaveText(
      noEvents
    );
  }
);

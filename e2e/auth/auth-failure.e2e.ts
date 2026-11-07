import { expect } from 'e2e';
import { test } from '../fixtures';

test(
  'reports a real rejected authentication and keeps the remaining listener active',
  { timeout: 180_000 },
  async ({ app, screen }) => {
    await app.open();
    const menu = screen.getByTestId('example-menu-auth-failure');
    await expect(menu).toBeVisible({ timeout: 120_000 });
    await menu.tap();
    await expect(screen.getByTestId('auth-failure-code')).toHaveText('401');
    const message = await screen
      .getByTestId('auth-failure-message')
      .textContent();
    expect(message?.trim().length).toBeGreaterThan(0);
    expect(message).not.toBe('waiting');
    expect(
      Number(await screen.getByTestId('auth-failure-count').textContent())
    ).toBeGreaterThanOrEqual(1);
    await expect(screen.getByTestId('auth-failure-removed-count')).toHaveText(
      '0'
    );
  }
);

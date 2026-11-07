import { beforeEach, test } from '@e2e-dev/mobile';
import { expect } from 'e2e';

const menuTitle = 'Naver Map Examples';

beforeEach(async ({ app, screen }) => {
  await app.open();
  await expect(screen.getByText(menuTitle)).toBeVisible();
  await screen.getByTestId('example-menu-smoke').tap();
  await expect(screen.getByTestId('smoke-initialized')).toHaveText(
    'initialized'
  );
});

test('opens the map and returns to the menu', async ({ screen }) => {
  await screen.getByRole('button', 'Back').tap();
  await expect(screen.getByText(menuTitle)).toBeVisible();
});

test('moves the native camera to the requested coordinates', async ({
  screen,
}) => {
  await expect(screen.getByTestId('smoke-camera')).not.toHaveText('waiting');
  await screen.getByRole('button', 'Move to Gangnam').tap();
  const coordinates = screen.getByTestId('smoke-camera');
  await expect(coordinates).toHaveText('37.4980,127.0276');
});

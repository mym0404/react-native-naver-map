import { expect } from 'e2e';
import { test } from '../fixtures';

const menuTitle = 'Naver Map Examples';

test.beforeEach(async ({ app, screen }) => {
  await app.open();
  await expect(screen.getByText(menuTitle)).toBeVisible();
  await screen.getByTestId('example-menu-map-view-basic').tap();
  await expect(screen.getByTestId('map-view-basic-initialized')).toHaveText(
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
  await expect(screen.getByTestId('map-view-basic-camera')).not.toHaveText(
    'waiting'
  );
  await screen.getByRole('button', 'Move to Gangnam').tap();
  const coordinates = screen.getByTestId('map-view-basic-camera');
  await expect(coordinates).toHaveText('37.4980,127.0276');
});

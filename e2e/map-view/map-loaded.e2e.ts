import { expect } from 'e2e';
import { test } from '../fixtures';

const menuTitle = 'Naver Map Examples';

test('reports native map loading separately from initialization on each mount', async ({
  app,
  screen,
}) => {
  await app.open();
  await openMapAndWaitForLoad();
  await screen.getByRole('button', 'Back').tap();
  await openMapAndWaitForLoad();

  async function openMapAndWaitForLoad() {
    await expect(screen.getByText(menuTitle)).toBeVisible();
    await screen.getByTestId('example-menu-map-view-loading').tap();
    await expect(
      screen.getByTestId('map-view-loading-initialized-count')
    ).toHaveText('1');
    await expect(
      screen.getByTestId('map-view-loading-loaded-count')
    ).toHaveText('1');
  }
});

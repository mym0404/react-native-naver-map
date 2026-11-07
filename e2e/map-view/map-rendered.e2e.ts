import { expect } from 'e2e';
import { test } from '../fixtures';

const rendered = 'true,true';

test('reports SDK rendering state for the initial and moved camera', async ({
  app,
  screen,
}) => {
  await app.open();
  await expect(screen.getByText('Naver Map Examples')).toBeVisible();
  await screen.getByTestId('example-menu-map-view-rendering').tap();
  await expect(screen.getByTestId('map-view-rendering-loaded')).toHaveText(
    'loaded'
  );
  await expect(screen.getByTestId('map-view-rendering-result')).toHaveText(
    rendered
  );
  await screen.getByRole('button', 'Animate to Gangnam').tap();
  await expect(screen.getByTestId('map-view-rendering-camera')).toHaveText(
    '37.4980,127.0276'
  );
  await expect(
    screen.getByTestId('map-view-rendering-destination-result')
  ).toHaveText(rendered);
});

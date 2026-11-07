import { expect } from 'e2e';
import { test } from '../fixtures';

const coordinateTolerance = 0.0005;

test('round-trips geographic coordinates through logical screen coordinates', async ({
  app,
  screen,
}) => {
  await app.open();
  await screen.getByTestId('example-menu-map-view-basic').tap();
  await expect(screen.getByTestId('map-view-basic-initialized')).toHaveText(
    'initialized'
  );
  await expect(screen.getByTestId('map-view-basic-camera')).not.toHaveText(
    'waiting'
  );
  await screen.getByRole('button', 'Check coordinate conversion').tap();
  const projection = screen.getByTestId('map-view-basic-projection');
  await expect(projection).not.toHaveText('waiting');
  const results = (await projection.textContent())?.split(';') ?? [];
  expect(results).toHaveLength(3);
  for (const result of results) {
    const [
      latitude,
      longitude,
      screenValid,
      coordinateValid,
      actualLatitude,
      actualLongitude,
    ] = result.split(',');
    expect(screenValid).toBe('true');
    expect(coordinateValid).toBe('true');
    expect(Math.abs(Number(actualLatitude) - Number(latitude))).toBeLessThan(
      coordinateTolerance
    );
    expect(Math.abs(Number(actualLongitude) - Number(longitude))).toBeLessThan(
      coordinateTolerance
    );
  }
});

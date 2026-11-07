import { expect } from 'e2e';
import { test } from '../fixtures';

const coordinateTolerance = 0.0001;
const screenTolerance = 5;

test('reports native long-tap coordinates in logical map coordinates', async ({
  app,
  screen,
}) => {
  await app.open();
  await screen.getByTestId('example-menu-map-view-basic').tap();
  await expect(screen.getByTestId('map-view-basic-initialized')).toHaveText(
    'initialized'
  );
  await expect(screen.getByTestId('map-view-basic-camera')).toHaveText(
    '37.5665,126.9780'
  );
  await screen.getByTestId('map-view-basic-map').longPress();
  const result = screen.getByTestId('map-view-basic-long-tap');
  await expect(result).not.toHaveText('waiting');
  const fields = (await result.textContent())?.split(',') ?? [];
  expect(fields).toHaveLength(9);
  const [latitude, longitude, x, y, width, height] = fields
    .slice(0, 6)
    .map(Number);
  for (const value of [latitude, longitude, x, y, width, height]) {
    expect(Number.isFinite(value)).toBe(true);
  }
  expect(width).toBeGreaterThan(0);
  expect(height).toBeGreaterThan(0);
  expect(Math.abs(latitude - 37.5665)).toBeLessThan(coordinateTolerance);
  expect(Math.abs(longitude - 126.978)).toBeLessThan(coordinateTolerance);
  expect(Math.abs(x - width / 2)).toBeLessThan(screenTolerance);
  expect(Math.abs(y - height / 2)).toBeLessThan(screenTolerance);
  expect(fields[6]).toBe('true');
  expect(Number(fields[7])).toBeCloseTo(latitude, 5);
  expect(Number(fields[8])).toBeCloseTo(longitude, 5);
});

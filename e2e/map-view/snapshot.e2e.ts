import { readFile } from 'node:fs/promises';
import { expect } from 'e2e';
import { PNG } from 'pngjs';
import { test } from '../fixtures';

test('captures readable PNGs and includes SDK controls only when requested', async ({
  app,
  screen,
}) => {
  await app.open();
  await screen.getByTestId('example-menu-map-view-snapshot').tap();
  await expect(screen.getByTestId('map-view-snapshot-ready')).toHaveText(
    'ready'
  );
  await screen.getByRole('button', 'Capture snapshots').tap();
  await expect(screen.getByTestId('map-view-snapshot-busy')).toHaveText(
    'rejected'
  );

  const files = [0, 1].map((index) =>
    screen.getByTestId(`map-view-snapshot-file-${index}`)
  );
  for (const file of files) await expect(file).toBeVisible();
  const [withControls, withoutControls] = await Promise.all(
    files.map((file) => file.textContent())
  );
  const [withUri, size] = (withControls ?? '').split('|');
  const [withoutUri, withoutSize] = (withoutControls ?? '').split('|');
  expect(withUri).toMatch(/^file:\/\/.+\.png$/);
  expect(withoutUri).toMatch(/^file:\/\/.+\.png$/);
  expect(withUri).not.toBe(withoutUri);
  expect(withoutSize).toBe(size);
  const [width, height] = size.split(',').map(Number);
  expect(width).toBeGreaterThan(0);
  expect(height).toBeGreaterThan(0);
  const decoded = screen.getByTestId('map-view-snapshot-decoded');
  await expect(decoded).toHaveText(`0:${size}`);
  const preview = screen.getByTestId('map-view-snapshot-preview');
  const bounds = await preview.boundingBox();
  expect(bounds).not.toBeNull();
  if (!bounds) throw new Error('Snapshot preview has no bounds');
  expect(bounds.x).toBe(0);
  const withImage = PNG.sync.read(
    await readFile(await app.screenshot('snapshot-with-controls'))
  );

  await screen.getByRole('button', 'Show snapshot without controls').tap();
  await expect(decoded).toHaveText(`1:${size}`);
  expect(await preview.boundingBox()).toEqual(bounds);
  const withoutImage = PNG.sync.read(
    await readFile(await app.screenshot('snapshot-without-controls'))
  );
  expect(withoutImage.width).toBe(withImage.width);
  expect(withoutImage.height).toBe(withImage.height);
  await expect(screen.getByTestId('map-view-snapshot-error')).toHaveText('');

  const scale = withImage.width / bounds.width;
  const top = Math.ceil(bounds.y * scale);
  const bottom = Math.floor((bounds.y + bounds.height) * scale);
  const centerOffset =
    (Math.floor((top + bottom) / 2) * withImage.width +
      Math.floor(withImage.width / 2)) *
    4;
  const minimumMagentaChannel = 200;
  for (const image of [withImage, withoutImage]) {
    expect(image.data[centerOffset]).toBeGreaterThan(minimumMagentaChannel);
    expect(image.data[centerOffset + 1]).toBeLessThan(80);
    expect(image.data[centerOffset + 2]).toBeGreaterThan(minimumMagentaChannel);
  }
  let edgePixels = 0;
  let edgeChanged = 0;
  let centerPixels = 0;
  let centerChanged = 0;
  const channelTolerance = 16;
  const changeRatioTolerance = 0.005;
  for (let y = top; y < bottom; y++) {
    for (let x = 0; x < withImage.width; x++) {
      const offset = (y * withImage.width + x) * 4;
      const isChanged = [0, 1, 2].some(
        (channel) =>
          Math.abs(
            withImage.data[offset + channel] -
              withoutImage.data[offset + channel]
          ) > channelTolerance
      );
      const isCenter =
        x > withImage.width / 4 &&
        x < (withImage.width * 3) / 4 &&
        y > top + (bottom - top) / 4 &&
        y < top + ((bottom - top) * 3) / 4;
      if (isCenter) {
        centerPixels++;
        if (isChanged) centerChanged++;
      } else {
        edgePixels++;
        if (isChanged) edgeChanged++;
      }
    }
  }
  expect(centerChanged / centerPixels).toBeLessThan(changeRatioTolerance);
  expect(edgeChanged).toBeGreaterThan(100);
  expect(edgeChanged / edgePixels).toBeGreaterThan(
    centerChanged / centerPixels + changeRatioTolerance
  );
});

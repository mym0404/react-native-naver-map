import { readFile } from 'node:fs/promises';
import { expect } from 'e2e';
import { PNG } from 'pngjs';
import { test } from '../fixtures';

test('displays and updates React info-window content on a map and marker', async ({
  app,
  screen,
}) => {
  await app.open();
  await screen.getByTestId('example-menu-info-window-content').tap();
  await expect(screen.getByTestId('info-window-content-ready')).toHaveText(
    'ready'
  );
  const file = screen.getByTestId('info-window-content-file');
  const decoded = screen.getByTestId('info-window-content-decoded');
  const preview = screen.getByTestId('info-window-content-preview');

  await screen.getByRole('button', 'Open on map').tap();
  const initial = await captureColor('magenta');
  await screen.getByRole('button', 'Update custom content').tap();
  const updated = await captureColor('cyan');
  expect(updated.bounds).toEqual(initial.bounds);
  expect(updated.image.width).toBe(initial.image.width);
  expect(updated.image.height).toBe(initial.image.height);
  expect(updated.uri).not.toBe(initial.uri);

  const scale = initial.image.width / initial.bounds.width;
  const regionMargin = 0.3;
  const left = Math.ceil(initial.image.width * regionMargin);
  const right = Math.floor(initial.image.width * (1 - regionMargin));
  const top = Math.ceil(
    (initial.bounds.y + initial.bounds.height * regionMargin) * scale
  );
  const bottom = Math.floor(
    (initial.bounds.y + initial.bounds.height * (1 - regionMargin)) * scale
  );
  const whiteChannelFloor = 230;
  let changedTextPixels = 0;
  for (let y = top; y < bottom; y++) {
    for (let x = left; x < right; x++) {
      const offset = (y * initial.image.width + x) * 4;
      const isInitialWhite = [0, 1, 2].every(
        (channel) => initial.image.data[offset + channel] > whiteChannelFloor
      );
      const isUpdatedWhite = [0, 1, 2].every(
        (channel) => updated.image.data[offset + channel] > whiteChannelFloor
      );
      if (isInitialWhite !== isUpdatedWhite) changedTextPixels++;
    }
  }
  expect(changedTextPixels).toBeGreaterThan(20);

  await screen.getByRole('button', 'Reorder overlays').tap();
  await captureColor('cyan');
  await screen.getByRole('button', 'Close info window').tap();
  await captureColor('closed');
  await screen.getByRole('button', 'Open on marker').tap();
  await captureColor('cyan');
  await expect(screen.getByTestId('info-window-content-error')).toHaveText('');

  async function captureColor(expected: 'magenta' | 'cyan' | 'closed') {
    let capture:
      | {
          image: PNG;
          uri: string;
          bounds: { x: number; y: number; width: number; height: number };
        }
      | undefined;
    await expect
      .poll(
        async () => {
          const previous = await file.textContent();
          await screen.getByRole('button', 'Capture map image').tap();
          await expect(file).not.toHaveText(previous ?? 'waiting');
          const fields = (await file.textContent())?.split('|') ?? [];
          expect(fields).toHaveLength(3);
          const [sequence, uri, size] = fields;
          expect(uri).toMatch(/^file:\/\/.+\.png$/);
          const [width, height] = size.split(',').map(Number);
          expect(width).toBeGreaterThan(0);
          expect(height).toBeGreaterThan(0);
          await expect(decoded).toHaveText(`${sequence}|${size}`);
          const bounds = await preview.boundingBox();
          if (!bounds) throw new Error('Info-window preview has no bounds');
          expect(bounds.x).toBe(0);
          const image = PNG.sync.read(
            await readFile(await app.screenshot(`info-window-${expected}`))
          );
          const scale = image.width / bounds.width;
          const x = Math.floor(image.width / 2);
          const y = Math.floor((bounds.y + bounds.height / 2) * scale);
          const offset = (y * image.width + x) * 4;
          const [red, green, blue] = image.data.subarray(offset, offset + 3);
          const highChannel = 200;
          const lowChannel = 80;
          const isMagenta =
            red > highChannel && green < lowChannel && blue > highChannel;
          const isCyan =
            red < lowChannel && green > highChannel && blue > highChannel;
          capture = { image, uri, bounds };
          return expected === 'magenta'
            ? isMagenta
            : expected === 'cyan'
              ? isCyan
              : !isMagenta && !isCyan;
        },
        {
          timeout: 30_000,
          message: `Native info-window pixels must be ${expected}`,
        }
      )
      .toBe(true);
    if (!capture) throw new Error('No native info-window image was captured');
    return capture;
  }
});

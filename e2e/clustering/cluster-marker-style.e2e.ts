import { readFile } from 'node:fs/promises';
import { expect } from 'e2e';
import { PNG } from 'pngjs';
import { test } from '../fixtures';

type Color = 'magenta' | 'cyan' | 'yellow';
type Bounds = { left: number; top: number; right: number; bottom: number };

test(
  'renders cluster images, caption styles, member counts, and hidden captions',
  { timeout: 180_000 },
  async ({ app, screen }) => {
    await app.open();
    const menu = screen.getByTestId('example-menu-cluster-marker-style');
    await expect(menu).toBeVisible({ timeout: 120_000 });
    await menu.tap();
    await expect(screen.getByTestId('cluster-marker-style-ready')).toHaveText(
      'ready'
    );
    const file = screen.getByTestId('cluster-marker-style-file');
    const decoded = screen.getByTestId('cluster-marker-style-decoded');
    const preview = screen.getByTestId('cluster-marker-style-preview');
    const layout = screen.getByTestId('cluster-marker-style-layout');

    const initialUri = await captureStyle({
      iconColor: 'magenta',
      captionColor: 'yellow',
      captionPlacement: 'above',
      width: 64,
      height: 48,
      captionRuns: 4,
    });
    await screen.getByRole('button', 'Update cluster style').tap();
    const updatedStyle = {
      iconColor: 'cyan',
      captionColor: 'magenta',
      captionPlacement: 'below',
      width: 80,
      height: 56,
      captionRuns: 4,
    } as const;
    const updatedUri = await captureStyle(updatedStyle);
    expect(updatedUri).not.toBe(initialUri);

    await screen.getByRole('button', 'Use member count').tap();
    await captureStyle({ ...updatedStyle, captionRuns: 1 });
    await screen.getByRole('button', 'Hide cluster caption').tap();
    await captureStyle({ ...updatedStyle, captionRuns: 0 });
    await expect(screen.getByTestId('cluster-marker-style-error')).toHaveText(
      ''
    );

    async function captureStyle(expected: {
      iconColor: Color;
      captionColor: Color;
      captionPlacement: 'above' | 'below';
      width: number;
      height: number;
      captionRuns: number;
    }) {
      let capturedUri: string | undefined;
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
            const layoutSize = (await layout.textContent())?.split(',') ?? [];
            expect(layoutSize).toHaveLength(2);
            const layoutWidth = Number(layoutSize[0]);
            expect(layoutWidth).toBeGreaterThan(0);
            await expect(decoded).toHaveText(`${sequence}|${size}`);
            const bounds = await preview.boundingBox();
            if (!bounds) throw new Error('Cluster preview has no bounds');
            expect(bounds.x).toBe(0);
            const image = PNG.sync.read(
              await readFile(await app.screenshot('cluster-marker-style'))
            );
            const pixelRatio = image.width / layoutWidth;
            const screenScale = image.width / bounds.width;
            const centerX = image.width / 2;
            const centerY = (bounds.y + bounds.height / 2) * screenScale;
            const radius = 120 * pixelRatio;
            const region = {
              left: Math.max(0, Math.floor(centerX - radius)),
              right: Math.min(image.width - 1, Math.ceil(centerX + radius)),
              top: Math.max(
                Math.ceil(bounds.y * screenScale),
                Math.floor(centerY - radius)
              ),
              bottom: Math.min(
                Math.floor((bounds.y + bounds.height) * screenScale) - 1,
                Math.ceil(centerY + radius)
              ),
            };
            const icon = readMask({
              image,
              color: expected.iconColor,
              region,
            });
            const caption = readMask({
              image,
              color: expected.captionColor,
              region,
            });
            capturedUri = uri;
            if (!icon.bounds) return false;
            const iconWidth = icon.bounds.right - icon.bounds.left + 1;
            const iconHeight = icon.bounds.bottom - icon.bounds.top + 1;
            const tolerance = 2 * pixelRatio;
            const hasIconGeometry =
              Math.abs(iconWidth - expected.width * pixelRatio) <= tolerance &&
              Math.abs(iconHeight - expected.height * pixelRatio) <=
                tolerance &&
              Math.abs((icon.bounds.left + icon.bounds.right) / 2 - centerX) <=
                tolerance &&
              Math.abs((icon.bounds.top + icon.bounds.bottom) / 2 - centerY) <=
                tolerance &&
              icon.pixels >
                expected.width * expected.height * pixelRatio ** 2 * 0.9;
            const hasCaptionPlacement =
              expected.captionRuns === 0
                ? caption.pixels === 0
                : caption.bounds != null &&
                  caption.pixels > 20 &&
                  (expected.captionPlacement === 'above'
                    ? caption.bounds.bottom < icon.bounds.top - 4 * pixelRatio
                    : caption.bounds.top > icon.bounds.bottom + 4 * pixelRatio);
            return (
              hasIconGeometry &&
              hasCaptionPlacement &&
              caption.runs === expected.captionRuns
            );
          },
          {
            timeout: 30_000,
            message: `Native cluster pixels must match ${JSON.stringify(expected)}`,
          }
        )
        .toBe(true);
      if (!capturedUri) throw new Error('No native cluster image was captured');
      return capturedUri;
    }

    function readMask({
      image,
      color,
      region,
    }: {
      image: PNG;
      color: Color;
      region: Bounds;
    }) {
      let left = image.width;
      let right = -1;
      let top = image.height;
      let bottom = -1;
      let pixels = 0;
      const columns: boolean[] = [];
      const high = 200;
      const low = 80;
      for (let y = region.top; y <= region.bottom; y++) {
        for (let x = region.left; x <= region.right; x++) {
          const offset = (y * image.width + x) * 4;
          const red = image.data[offset];
          const green = image.data[offset + 1];
          const blue = image.data[offset + 2];
          const matches =
            color === 'magenta'
              ? red > high && green < low && blue > high
              : color === 'cyan'
                ? red < low && green > high && blue > high
                : red > high && green > high && blue < low;
          if (!matches) continue;
          pixels++;
          columns[x - region.left] = true;
          left = Math.min(left, x);
          right = Math.max(right, x);
          top = Math.min(top, y);
          bottom = Math.max(bottom, y);
        }
      }
      const runs = columns.filter(
        (value, index) => value && !columns[index - 1]
      ).length;
      return {
        bounds: pixels ? { left, right, top, bottom } : undefined,
        pixels,
        runs,
      };
    }
  }
);

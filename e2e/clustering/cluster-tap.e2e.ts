import { readFile } from 'node:fs/promises';
import { expect } from 'e2e';
import { PNG } from 'pngjs';
import { test } from '../fixtures';

const waiting = 'waiting';
const high = 200;

test(
  'reports only the tapped native cluster members and preserves default zoom',
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
    await expect
      .poll(
        async () => {
          const previous = await file.textContent();
          await screen.getByRole('button', 'Capture map image').tap();
          await expect(file).not.toHaveText(previous ?? waiting);
          const fields = (await file.textContent())?.split('|') ?? [];
          expect(fields).toHaveLength(3);
          await expect(decoded).toHaveText(`${fields[0]}|${fields[2]}`);
          const bounds = await preview.boundingBox();
          if (!bounds) throw new Error('Cluster preview has no bounds');
          const image = PNG.sync.read(
            await readFile(await app.screenshot('cluster-tap-before'))
          );
          const scale = image.width / bounds.width;
          let bands = 0;
          let wasMagenta = false;
          for (
            let y = Math.ceil(bounds.y * scale);
            y < Math.floor((bounds.y + bounds.height) * scale);
            y++
          ) {
            let magentaPixels = 0;
            for (let x = 0; x < image.width; x++) {
              const offset = (y * image.width + x) * 4;
              if (
                image.data[offset] > high &&
                image.data[offset + 1] < 80 &&
                image.data[offset + 2] > high
              )
                magentaPixels++;
            }
            const isMagenta = magentaPixels > 20 * scale;
            if (isMagenta && !wasMagenta) bands++;
            wasMagenta = isMagenta;
          }
          return bands;
        },
        {
          message: 'Two separate styled native cluster markers must be visible',
        }
      )
      .toBe(2);
    await screen.getByRole('button', 'Close map image').tap();
    await screen.getByTestId('cluster-marker-style-map').tap();
    const result = screen.getByTestId('cluster-tap-result');
    await expect(result).not.toHaveText(waiting);
    const payload = JSON.parse((await result.textContent()) ?? 'null');
    expect(payload.clusterIndex).toBe(0);
    expect(payload.markerIdentifiers.sort()).toEqual([
      'first',
      'second',
      'third',
    ]);
    await expect
      .poll(async () =>
        Number(await screen.getByTestId('cluster-tap-zoom').textContent())
      )
      .toBeGreaterThan(14);
    await expect(screen.getByTestId('cluster-marker-style-error')).toHaveText(
      ''
    );
  }
);

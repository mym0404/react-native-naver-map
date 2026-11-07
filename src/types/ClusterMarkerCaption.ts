import type { CaptionType } from '../component/NaverMapMarkerOverlay';

export type ClusterMarkerCaption = Omit<
  CaptionType,
  'text' | 'align' | 'color'
> & {
  /** Omit to display the cluster member count. An empty string hides the caption. */
  text?: string;
  /** @default Center */
  align?: CaptionType['align'];
  /** @default white */
  color?: CaptionType['color'];
};

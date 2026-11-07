export type ClusterMarkerTapParams = {
  /** Index of the group in the current `clusters` array. */
  clusterIndex: number;
  /** Identifiers of the tapped cluster's actual members, in unspecified order. */
  markerIdentifiers: string[];
};

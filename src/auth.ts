import NativeRNCNaverMapUtil from './spec/NativeRNCNaverMapUtil';

export type NaverMapAuthFailure = Readonly<{
  code: string;
  message: string;
}>;

let listenerCount = 0;

/**
 * Subscribes to SDK-wide authentication failures. Register before mounting the first map.
 * Past failures are not replayed. Remove the subscription when it is no longer needed.
 * The SDK's default authentication alert/toast is replaced while subscribed.
 */
export const addNaverMapAuthFailureListener = (
  listener: (failure: NaverMapAuthFailure) => void
) => {
  const subscription = NativeRNCNaverMapUtil.onAuthFailed(listener);
  if (listenerCount === 0) {
    try {
      NativeRNCNaverMapUtil.startObservingAuthFailures();
    } catch (error) {
      subscription.remove();
      throw error;
    }
  }
  listenerCount++;
  let isRemoved = false;

  return {
    remove: () => {
      if (isRemoved) return;
      isRemoved = true;
      subscription.remove();
      listenerCount--;
      if (listenerCount === 0)
        NativeRNCNaverMapUtil.stopObservingAuthFailures();
    },
  };
};

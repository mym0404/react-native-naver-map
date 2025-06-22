class NaverMapJSError extends Error {
  constructor(message: string) {
    super(message);

    this.name = 'NaverMapJSError';
  }
}
export function nAssert(
  condition: boolean | null | undefined,
  message: string
) {
  if (!condition) {
    throw new NaverMapJSError(message);
  }
}

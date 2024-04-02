import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypes';

export type NaverMapAuthFailedEvent = Readonly<{
  errorCode: Int32;
  description: string;
}>;

interface NativeProps extends ViewProps {
  nightMode?: boolean;
  onInitialized?: DirectEventHandler<Readonly<{}>>;
  onAuthFailed?: DirectEventHandler<NaverMapAuthFailedEvent>;
}

export default codegenNativeComponent<NativeProps>('RNCNaverMapView');

import { codegenNativeComponent, type ViewProps } from 'react-native';
import type {
  Double,
  Int32,
  WithDefault,
} from 'react-native/Libraries/Types/CodegenTypes';

/* Type should be redeclared because of codegen ts parser doesn't allow imported type
 * [comments](https://github.com/reactwg/react-native-new-architecture/discussions/91#discussioncomment-4282452)
 */

interface BaseOverlay {
  zIndexValue: Int32;
  globalZIndexValue: Int32;
  isHidden?: WithDefault<boolean, false>;
  minZoom: Double;
  maxZoom: Double;
  isMinZoomInclusive?: WithDefault<boolean, true>;
  isMaxZoomInclusive?: WithDefault<boolean, true>;
}

////////////////////

interface Props extends BaseOverlay, ViewProps {
  /**
   * InfoWindow 위치 좌표
   */
  coord: Readonly<{
    latitude: Double;
    longitude: Double;
  }>;
  /**
   * InfoWindow가 열릴 마커 ID (선택적)
   * 지정하면 마커 위에 열림, 없으면 coord 위치에 열림
   */
  markerTag?: string;
  /**
   * InfoWindow가 마커에 대해 열릴 때의 정렬 방향
   * Top = 0, TopLeft = 1, TopRight = 2, Right = 3,
   * BottomRight = 4, Bottom = 5, BottomLeft = 6, Left = 7, Center = 8
   * @default 0 (Top)
   */
  align?: WithDefault<Int32, 0>;
  /**
   * 앵커 포인트 (0~1 범위의 비율)
   * 왼쪽 위가 (0, 0), 오른쪽 아래가 (1, 1)
   * @default {x: 0.5, y: 1}
   */
  anchor?: Readonly<{ x: Double; y: Double }>;
  /**
   * X축 오프셋 (픽셀)
   * @default 0
   */
  offsetX?: WithDefault<Int32, 0>;
  /**
   * Y축 오프셋 (픽셀)
   * @default 0
   */
  offsetY?: WithDefault<Int32, 0>;
  /**
   * 불투명도 (0~1)
   * @default 1
   */
  alpha?: WithDefault<Double, 1.0>;
  /**
   * 텍스트 내용
   */
  text?: string;
  /**
   * 텍스트 크기
   * @default 14
   */
  textSize?: WithDefault<Double, 14>;
  /**
   * 텍스트 색상
   */
  textColor?: Int32;
  /**
   * 배경 색상
   */
  infoWindowBackgroundColor?: Int32;
}

export default codegenNativeComponent<Props>('RNCNaverMapInfoWindow');

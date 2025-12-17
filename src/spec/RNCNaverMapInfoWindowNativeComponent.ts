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
   * identifier가 없으면 이 좌표에 직접 표시
   * identifier가 있으면 대체 위치로 사용
   */
  coord: Readonly<{
    latitude: Double;
    longitude: Double;
  }>;
  /**
   * InfoWindow가 열릴 마커의 identifier
   * 지정하면 해당 마커 위에 열림
   */
  identifier?: string;
  /**
   * InfoWindow를 처음부터 열린 상태로 표시할지 여부
   * @default true
   */
  isOpen?: WithDefault<boolean, true>;
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
   * 폰트 굵기 (100-900, 400=normal, 700=bold)
   * @default 400
   */
  fontWeight?: WithDefault<Int32, 400>;
  /**
   * 배경 색상
   */
  infoWindowBackgroundColor?: Int32;
  /**
   * 둥근 모서리 반경 (픽셀)
   * @default 5
   */
  infoWindowBorderRadius?: WithDefault<Double, 5>;
  /**
   * 테두리 두께 (픽셀)
   * @default 1
   */
  infoWindowBorderWidth?: WithDefault<Double, 1>;
  /**
   * 테두리 색상
   */
  infoWindowBorderColor?: Int32;
  /**
   * 수평 내부 여백 (픽셀)
   * @default 10
   */
  infoWindowPaddingHorizontal?: WithDefault<Double, 10>;
  /**
   * 수직 내부 여백 (픽셀)
   * @default 10
   */
  infoWindowPaddingVertical?: WithDefault<Double, 10>;
}

export default codegenNativeComponent<Props>('RNCNaverMapInfoWindow');

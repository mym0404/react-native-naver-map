import { default as NativeNaverMapMarker } from '../spec/RNCNaverMapMarkerNativeComponent';
import React, { type PropsWithChildren, Children } from 'react';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import {
  type PointProp,
  type ColorValue,
  type ImageSourcePropType,
  Image,
  processColor,
} from 'react-native';
import { Const } from '../util/Const';
import invariant from 'invariant';
import { type MarkerImages } from '../types/MarkerImages';
import type { Double } from 'react-native/Libraries/Types/CodegenTypes';
import { type Align } from '../types/Align';
import type { Coord } from '../types/Coord';
import { getAlignIntValue, allMarkerImages } from '../internal/Util';

export interface CaptionType {
  /**
   * 캡션의 키값입니다. 캡션의 속성을 변경해도 키값이 변하지 않으면 적용되지 않습니다.
   *
   * 속성이 변할 때 키 값도 같이 변경해주어야 합니다.
   *
   * @example
   *
   * 예를 들어 텍스트와 텍스트의 크기를 동적으로 변경하고 싶다면,
   *
   * ```tsx
   * caption={{
   *   key: `${text}-${textSize}`,
   *   text,
   *   textSize,
   * }}
   * ```
   *
   * 처럼 작성할 수 있습니다.
   */
  key: string;
  /** 캡션으로 표시할 텍스트를 지정할 수 있습니다.
   * 빈 문자열이나 null을 지정하면 캡션이 나타나지 않습니다. */
  text: string;
  /**
   * 캡션 텍스트의 너비를 제한할 수 있습니다.
   * 캡션의 한 줄이 지정된 너비보다 길어지면 적당한 위치에서 자동으로 줄바꿈이 일어납니다.
   * 단, 공백 없이 모든 텍스트를 붙여쓴 경우 줄바꿈이 일어나지 않을 수도 있습니다.
   * 0을 지정하면 자동 줄바꿈이 일어나지 않습니다.
   *
   * @default 0
   */
  requestedWidth?: Double;
  /**
   * @default Bottom
   */
  align?: Align;
  /** 아이콘과 캡션 간의 거리를 지정할 수 있습니다. */
  offset?: Double;
  /**
   * 텍스트의 색상입니다.
   *
   * @default black
   */
  color?: ColorValue;
  /**
   * 외곽선 색상입니다.
   *
   * @default transparent
   */
  haloColor?: ColorValue;
  /**
   *  캡션의 텍스트 크기를 지정할 수 있습니다.
   *
   *  @default 12
   */
  textSize?: Double;
  /**
   * 특정 줌 레벨에서만 캡션이 나타나도록 지정할 수 있습니다.
   * 카메라의 줌 레벨이 minZoom과 maxZoom 범위를 벗어나면 캡션이 숨겨지고 아이콘만 나타납니다.
   */
  minZoom?: Double;
  /**
   * 특정 줌 레벨에서만 캡션이 나타나도록 지정할 수 있습니다.
   * 카메라의 줌 레벨이 minZoom과 maxZoom 범위를 벗어나면 캡션이 숨겨지고 아이콘만 나타납니다.
   */
  maxZoom?: Double;
}
export interface SubCaptionType {
  /**
   * 서브캡션의 키값입니다. 서브캡션의 속성을 변경해도 키값이 변하지 않으면 적용되지 않습니다.
   *
   * 속성이 변할 때 키 값도 같이 변경해주어야 합니다.
   *
   * @example
   *
   * 예를 들어 텍스트와 텍스트의 크기를 동적으로 변경하고 싶다면,
   *
   * ```tsx
   * caption={{
   *   key: `${text}-${textSize}`,
   *   text,
   *   textSize,
   * }}
   * ```
   *
   * 처럼 작성할 수 있습니다.
   */
  key: string;
  /** 캡션으로 표시할 텍스트를 지정할 수 있습니다.
   * 빈 문자열이나 null을 지정하면 캡션이 나타나지 않습니다. */
  text: string;
  /**
   * 텍스트의 색상입니다.
   *
   * @default black
   */
  color?: ColorValue;
  /**
   * 외곽선 색상입니다.
   *
   * @default transparent
   */
  haloColor?: ColorValue;
  /**
   *  캡션의 텍스트 크기를 지정할 수 있습니다.
   *
   *  @default 10
   */
  textSize?: Double;
  /**
   * 캡션 텍스트의 너비를 제한할 수 있습니다.
   * 캡션의 한 줄이 지정된 너비보다 길어지면 적당한 위치에서 자동으로 줄바꿈이 일어납니다.
   * 단, 공백 없이 모든 텍스트를 붙여쓴 경우 줄바꿈이 일어나지 않을 수도 있습니다.
   * 0을 지정하면 자동 줄바꿈이 일어나지 않습니다.
   *
   * @default 0
   */
  requestedWidth?: Double;
  /**
   * 특정 줌 레벨에서만 캡션이 나타나도록 지정할 수 있습니다.
   * 카메라의 줌 레벨이 minZoom과 maxZoom 범위를 벗어나면 캡션이 숨겨지고 아이콘만 나타납니다.
   */
  minZoom?: Double;
  /**
   * 특정 줌 레벨에서만 캡션이 나타나도록 지정할 수 있습니다.
   * 카메라의 줌 레벨이 minZoom과 maxZoom 범위를 벗어나면 캡션이 숨겨지고 아이콘만 나타납니다.
   */
  maxZoom?: Double;
}
const defaultCaptionProps = {
  key: 'DEFAULT',
  text: '',
  textSize: 12,
  minZoom: 0,
  maxZoom: 9999,
  color: 'black',
  haloColor: 'transparent',
  requestedWidth: 0,
} satisfies Partial<CaptionType>;
const defaultSubCaptionProps = {
  key: 'DEFAULT',
  text: '',
  textSize: 10,
  minZoom: 0,
  maxZoom: 9999,
  color: 'black',
  haloColor: 'transparent',
  requestedWidth: 0,
} satisfies Partial<SubCaptionType>;

export interface NaverMapMarkerOverlayProps
  extends BaseOverlayProps,
    Coord,
    PropsWithChildren<{}> {
  /**
   * 마커의 너비입니다.
   *
   * 지정하지 않는다면 너비 또는 높이가 이미지의 크기에 맞춰집니다.
   */
  width?: number;
  /**
   * 마커의 높이입니다.
   *
   * 지정하지 않는다면 너비 또는 높이가 이미지의 크기에 맞춰집니다.
   */
  height?: number;
  /**
   * anchor 속성을 지정하면 이미지가 가리키는 지점과 마커가 위치한 지점을 일치시킬 수 있습니다.
   * 앵커는 아이콘 이미지에서 기준이 되는 지점을 의미하는 값으로, 아이콘에서 앵커로 지정된 지점이 마커의 좌표에 위치하게 됩니다.
   * 왼쪽 위가 (0, 0), 오른쪽 아래가 (1, 1)인 비율로 표현합니다.
   *
   * 앵커 속성은 기본 마커 이미지를 사용하지 않을 때 유용합니다.
   * 예를 들어 다음 그림과 같이 오른쪽 아래에 꼬리가 달려 있는 이미지를 마커의 아이콘으로 지정하면, 이미지에서 가리키는 지점은 오른쪽 아래이지만 마커는 중앙 아래를 기준으로 지도에 붙어 있으므로 이미지와 마커의 좌표 간에 이격이 발생합니다.
   *
   * @description
   *
   * <img src="https://navermaps.github.io/android-map-sdk/assets/5-2-distance.png" alt="example1" width="500">
   *
   * 이 경우 앵커를 오른쪽 아래를 의미하는 (1, 1)로 지정하면 이미지와 마커의 좌표 간 이격을 해소할 수 있습니다.
   *
   * 다음은 마커의 앵커를 아이콘의 오른쪽 아래로 지정하는 예제입니다.
   *
   * <img src="https://navermaps.github.io/android-map-sdk/assets/5-2-anchor.png" alt="example2" width="500">
   */
  anchor?: PointProp;
  /**
   * angle 속성을 지정하면 아이콘을 회전시킬 수 있습니다. 각도는 화면의 위쪽 방향을 기준으로 시계 방향으로 커집니다. 즉, 0도일 경우 화면의 위쪽, 90도일 경우 오른쪽, 180도일 경우 아래쪽을 향하게 됩니다.
   *
   * @default 0
   */
  angle?: number;
  /**
   * 속성을 true로 지정하면 아이콘이 지도에 눕게 됩니다. 누운 아이콘은 지도가 회전하거나 기울어지면 함께 회전하고 기울어집니다.
   *
   * @default false
   */
  isFlatEnabled?: boolean;
  /**
   * 마커에는 기본적으로 원근 효과가 적용되지 않으므로, 다음 그림처럼 지도를 기울이더라도 멀리 있는 마커와 가까이 있는 마커의 크기는 동일하게 나타납니다.
   *
   * 속성을 true로 지정하면 아이콘에 원근 효과가 부여됩니다. 원근 효과가 부여된 아이콘은 화면의 아래쪽에 가까워질수록 커지고 멀어질수록 작아집니다.
   *
   * @default false
   */
  isIconPerspectiveEnabled?: boolean;
  /**
   * alpha 속성을 이용하면 마커의 불투명도를 지정할 수 있습니다.
   * 불투명도는 아이콘과 캡션 모두에 적용됩니다.
   * 값의 범위는 0~1이며, 0일 경우 완전히 투명, 1일 경우 완전히 불투명한 상태가 됩니다.
   * 불투명도가 0일 경우 visible이 false인 경우와 달리 여전히 화면에 나타나 있는 것으로 간주됩니다.
   * 따라서 겹침, 이벤트 처리의 대상이 됩니다.
   *
   * @default 1
   */
  alpha?: number;
  /**
   * 속성을 true로 지정하면 마커가 지도 심벌과 겹칠 경우 겹치는 심벌이 숨겨집니다.
   *
   * @default false
   */
  isHideCollidedSymbols?: boolean;
  /**
   * 속성을 true로 지정하면 마커가 다른 마커와 겹칠 경우 겹치는 마커가 숨겨집니다. 즉, 다른 마커와 겹치지 않는 마커만이 노출됩니다. 두 마커가 서로 겹칠 경우 Z 인덱스가 큰 마커가 우선합니다.
   *
   * @default false
   */
  isHideCollidedMarkers?: boolean;
  /**
   * 속성을 true로 지정하면 마커와 다른 마커가 겹칠 경우 겹치는 마커의 아이콘은 유지되고 캡션만이 숨겨집니다.
   * 겹치는 마커의 captionAligns에 둘 이상의 방향을 지정했다면 겹치지 않는 첫 번째 방향에 캡션이 나타나며, 어느 방향으로 위치시켜도 겹칠 경우에만 캡션이 숨겨집니다.
   * 즉, 다른 마커와 겹치지 않는 캡션만이 노출됩니다. 단, hideCollidedMarkers가 true로 지정된 경우 hideCollidedCaptions는 무시됩니다.
   *
   * @default false
   */
  isHideCollidedCaptions?: boolean;
  /**
   * isForceShowIcon 속성을 true로 지정하면 마커가 isHideCollidedMarkers가 true인 다른 마커와 겹치더라도 아이콘이 무조건 표시됩니다.
   * isForceShowIcon 속성을 활용하면 겹치는 마커를 숨기되 중요한 마커는 무조건 표시할 수 있습니다.
   * 중요한 마커는 zIndex를 높이고 isHideCollidedMarkers와 isForceShowIcon를 true로 지정하고, 덜 중요한 마커는 zIndex를 낮추고 isHideCollidedMarkers를 true로 지정하면 됩니다.
   *
   * @default false
   */
  isForceShowIcon?: boolean;
  /**
   * 아이콘 이미지에 색상을 덧입힐 수 있습니다. 색상을 덧입히면 덧입힐 색상이 아이콘 이미지의 색상과 가산 혼합됩니다. 단, 덧입힐 색상의 알파는 무시되고 아이콘 이미지의 알파만이 사용됩니다.
   */
  tintColor?: ColorValue;
  /**
   * 마커의 이미지입니다.
   *
   * @description
   *
   * 마커의 종류는 총 네가지입니다.
   *
   * 1. Default Symbol (green, red, gray, ...) (caching ✅)
   *
   * ```js
   * image={'green'}
   * ```
   *
   * 2. Local Resource (`ImageSourcePropType` of react native) (caching ✅)
   *
   * 이는 추후에 더 나은 성능을 위해 Android, iOS native resource를 사용해 screen density에 따라 최적의 마커가 선택되게 할 수 있는 로직을 구현하려
   * 합니다.
   *
   * ```js
   * image={require('./marker.png')}
   * ```
   *
   * 3. Network Image (caching ✅)
   *
   * ```js
   * image={{uri: 'https://example.com/image.png'}}
   * ```
   *
   * > 현재 header auth같은 객채 내의 다른 속성은 지원되지 않습니다.
   *
   * 4. Custom React View (caching ❌)
   *
   * iOS에선 현재 View들에 `collapsible=false`를 설정해야 동작할 것입니다.
   *
   * ```tsx
   * <NaverMapMarkerOverlay width={100} height={100} ...>
   *   <View collapsible={false} style={{width: 100, height: 100}}>
   *     ...
   *   </View>
   * </NaverMapMarkerOverlay>
   * ```
   *
   * > 이 타입은 많이 생성될 시 성능에 굉장히 영향을 미칠 수 있습니다.
   * > 아직은 단순하게만 사용하시거나 되도록이면 이미지를 사용하는 것을 추천드립니다.
   *
   * 현재 이 타입은 Android에선 `react-native-map`의 구현체를 비슷하게 가져와 React Native의 Shadow Node를 조금 커스텀해서 자식의 위치를
   * 추적한다음 실제 Android의 `View`를 삽입해줍니다.
   *
   * iOS에선 단순히 `UIView`를 `UIImage`로 캔버스에 그려 표시해줍니다.
   *
   * 두 방법 모두가 이미지 캐싱이 아직 지원되지 않고(추후에 `reuseableIdentifier`같은 속성으로 지원이 가능할 것으로 보입니다), 마커 하나당 많은 리소스를 차지하게
   * 됩니다.
   *
   * @default green
   */
  image?: ImageSourcePropType | (MarkerImages & {});
  /**
   * 마커의 캡션입니다.
   *
   * @see CaptionType
   */
  caption?: CaptionType;
  /**
   * 마커의 서브캡션입니다.
   *
   * @see SubCaptionType
   */
  subCaption?: SubCaptionType;
}

export const NaverMapMarkerOverlay = ({
  latitude,
  longitude,
  zIndex = Const.Z_MARKER,
  isHidden = false,
  minZoom = 0,
  maxZoom = 1000,
  isMinZoomInclusive = true,
  isMaxZoomInclusive = true,

  width = Const.NULL_NUMBER,
  height = Const.NULL_NUMBER,

  alpha = 1,
  anchor = { x: 0, y: 0 },
  angle = 0,
  isFlatEnabled = false,
  isForceShowIcon = false,
  isHideCollidedCaptions = false,
  isHideCollidedMarkers = false,
  isHideCollidedSymbols = false,
  isIconPerspectiveEnabled = false,

  tintColor,
  image = 'green',
  onTap,
  caption,
  subCaption,
  children,
}: NaverMapMarkerOverlayProps) => {
  invariant(
    Children.count(children) <= 1,
    '[NaverMapMarkerOverlay] children count should be equal or less than 1, is %s',
    Children.count(children)
  );

  invariant(
    Children.count(children) > 0 ? !image : true,
    '[NaverMapMarkerOverlay] passing `image` prop and `children` both for the marker image detected. only one of two should be passed.'
  );
  invariant(
    image ? getImageUri(image) : true,
    "[NaverMapMarkerOverlay] `image` uri is not found. If it is network image, then it should `{'uri': '...'}`. If it is local image, then it should be a ImageSourcePropType like `require('./myImage.png')`"
  );
  return (
    <NativeNaverMapMarker
      coord={{
        latitude,
        longitude,
      }}
      zIndexValue={zIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      isMinZoomInclusive={isMinZoomInclusive}
      isMaxZoomInclusive={isMaxZoomInclusive}
      width={width}
      height={height}
      alpha={alpha}
      anchor={anchor}
      angle={angle}
      isFlatEnabled={isFlatEnabled}
      isForceShowIcon={isForceShowIcon}
      isHideCollidedCaptions={isHideCollidedCaptions}
      isHideCollidedMarkers={isHideCollidedMarkers}
      isHideCollidedSymbols={isHideCollidedSymbols}
      isIconPerspectiveEnabled={isIconPerspectiveEnabled}
      tintColor={processColor(tintColor) as number}
      image={getImageUri(image) ?? 'default'}
      onTapOverlay={onTap}
      caption={{
        ...defaultCaptionProps,
        ...caption,
        align: getAlignIntValue(caption?.align),
        color: processColor(
          caption?.color ?? defaultCaptionProps.color
        ) as number,
        haloColor: processColor(
          caption?.haloColor ?? defaultCaptionProps.haloColor
        ) as number,
      }}
      subCaption={{
        ...defaultSubCaptionProps,
        ...subCaption,
        color: processColor(
          subCaption?.color ?? defaultSubCaptionProps.color
        ) as number,
        haloColor: processColor(
          subCaption?.haloColor ?? defaultSubCaptionProps.haloColor
        ) as number,
      }}
      children={children}
    />
  );
};

function getImageUri(src?: ImageSourcePropType | string): string | undefined {
  let imageUri;
  if (typeof src === 'string' && allMarkerImages.includes(src as any)) {
    imageUri = src;
  } else if (typeof src !== 'string' && src) {
    let image = Image.resolveAssetSource(src) || { uri: null };
    imageUri = image.uri;
  }
  return imageUri;
}

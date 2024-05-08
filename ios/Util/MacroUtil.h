//
//  MacroUtil.h
//  Pods
//
//  Created by mj on 4/7/24.
//

#ifndef MacroUtil_h
#define MacroUtil_h

#define NMAP_SETTER(upper, lower, rest, view_prop, type)                                           \
  -(void)set##upper##rest : (type)lower##rest {                                                    \
    _##lower##rest = lower##rest;                                                                  \
    self.view_prop = lower##rest;                                                                  \
  }
#define NMAP_INNER_SETTER(upper, lower, rest, type)                                                \
  NMAP_SETTER(upper, lower, rest, inner.lower##rest, type)
#define NMAP_MAP_SETTER(upper, lower, rest, type)                                                  \
  NMAP_SETTER(upper, lower, rest, mapView.lower##rest, type)

#define NMAP_REMAP_PROP(name)                                                                      \
  if (prev.name != next.name) {                                                                    \
    _view.name = next.name;                                                                        \
  }

#define NMAP_REMAP_STR_PROP(name)                                                                  \
  if (prev.name != next.name) {                                                                    \
    _view.name = [NSString stringWithUTF8String:next.name.c_str()];                                \
  }

#define NMAP_REMAP_SELF_PROP(name)                                                                 \
  if (prev.name != next.name) {                                                                    \
    self.name = next.name;                                                                         \
  }

#define NMAP_REMAP_SELF_STR_PROP(name)                                                             \
  if (prev.name != next.name) {                                                                    \
    self.name = [NSString stringWithUTF8String:next.name.c_str()];                                 \
  }

#define NMAP_REMAP_RECT_PROP(name)                                                                 \
  if (prev.name.top != next.name.top || prev.name.right != next.name.right ||                      \
      prev.name.bottom != next.name.bottom || prev.name.left != next.name.left) {                  \
    _view.name =                                                                                   \
        RNCNaverMapRectMake(next.name.top, next.name.right, next.name.bottom, next.name.left);     \
  }

#define NMAP_REMAP_IMAGE_PROP(name, setter)                                                        \
  auto p = prev.name, n = next.name;                                                               \
  if (p.reuseIdentifier != n.reuseIdentifier || p.assetName != n.assetName ||                      \
      p.httpUri != n.httpUri || p.rnAssetUri != n.rnAssetUri || p.symbol != n.symbol) {            \
    setter = @{                                                                                    \
      @"reuseIdentifier" : getNsStr(n.reuseIdentifier),                                            \
      @"assetName" : getNsStr(n.assetName),                                                        \
      @"httpUri" : getNsStr(n.httpUri),                                                            \
      @"rnAssetUri" : getNsStr(n.rnAssetUri),                                                      \
      @"symbol" : getNsStr(n.symbol),                                                              \
    };                                                                                             \
  }

#endif /* MacroUtil_h */

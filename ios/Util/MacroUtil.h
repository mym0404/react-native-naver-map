//
//  MacroUtil.h
//  Pods
//
//  Created by mj on 4/7/24.
//

#ifndef MacroUtil_h
#define MacroUtil_h

#define NMAP_QUICK_SETTER(cap, name, type)                                                         \
  -(void)set##cap : (type)name {                                                                   \
    _##name = name;                                                                                \
    self.mapView.name = name;                                                                      \
  }
#define NMAP_REMAP_QUICK_SETTER(cap, name, view_prop, type)                                        \
  -(void)set##cap : (type)name {                                                                   \
    _##name = name;                                                                                \
    self.view_prop = name;                                                                         \
  }

#define NMAP_REMAP_PROP(name)                                                                      \
  if (prev.name != next.name) {                                                                    \
    _view.name = next.name;                                                                        \
  }

#define NMAP_REMAP_SELF_PROP(name)                                                                 \
  if (prev.name != next.name) {                                                                    \
    self.name = next.name;                                                                        \
  }

#define NMAP_REMAP_STR_PROP(name)                                                                  \
  if (prev.name != next.name) {                                                                    \
    _view.name = RCTNSStringFromString(next.name);                                                 \
  }

#define NMAP_REMAP_RECT_PROP(name)                                                                 \
  if (prev.name.top != next.name.top || prev.name.right != next.name.right ||                      \
      prev.name.bottom != next.name.bottom || prev.name.left != next.name.left) {                  \
    _view.name =                                                                                   \
        RNCNaverMapRectMake(next.name.top, next.name.right, next.name.bottom, next.name.left);     \
  }

#endif /* MacroUtil_h */

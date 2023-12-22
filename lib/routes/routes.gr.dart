// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:greggs_sausage/features/cart_page/cart_page.dart' as _i1;
import 'package:greggs_sausage/features/item_page/item_page.dart' as _i2;

abstract class $RootRouter extends _i3.RootStackRouter {
  $RootRouter({super.navigatorKey});

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    CartPageRoute.name: (routeData) {
      return _i3.AutoRoutePage<String>(
        routeData: routeData,
        child: const _i1.CartPage(),
      );
    },
    ItemPageRoute.name: (routeData) {
      return _i3.AutoRoutePage<String>(
        routeData: routeData,
        child: _i2.ItemPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.CartPage]
class CartPageRoute extends _i3.PageRouteInfo<void> {
  const CartPageRoute({List<_i3.PageRouteInfo>? children})
      : super(
          CartPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartPageRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ItemPage]
class ItemPageRoute extends _i3.PageRouteInfo<void> {
  const ItemPageRoute({List<_i3.PageRouteInfo>? children})
      : super(
          ItemPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'ItemPageRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}

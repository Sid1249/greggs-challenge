import 'package:auto_route/auto_route.dart';
import 'package:greggs_sausage/routes/routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,PageRoute')
class RootRouter extends $RootRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino(

  );

  @override
  final List<AutoRoute> routes = [
    AutoRoute(
    page: ItemPageRoute.page,
    path: '/',
    ),
    AutoRoute(
      page: CartPageRoute.page,
      path: '/',
    )
  ];

}
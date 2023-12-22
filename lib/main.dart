import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:greggs_sausage/core/bloc/cart_bloc/bloc.dart';
import 'package:greggs_sausage/core/utils/scaffold_context_holder.dart';
import 'package:greggs_sausage/features/item_page/bloc/product_bloc/bloc.dart';
import 'package:greggs_sausage/routes/routes.dart';
import 'package:greggs_sausage/core/services/cart_service/cart_service.dart';
import 'package:greggs_sausage/features/item_page/repository/food_item_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
  setUpGetIt();
}

Future<void> setUpGetIt() async {
  GetIt.I.registerSingleton(await SharedPreferences.getInstance(),signalsReady: true);
  GetIt.I.registerLazySingleton<CartService>(() => CartService());
  GetIt.I.registerLazySingleton<FoodItemRepository>(() => FoodItemRepository());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<void> allServicesReady = GetIt.I.allReady();
  final appRouter = RootRouter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: allServicesReady,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp.router(
              scaffoldMessengerKey: snackbarKey,
              debugShowCheckedModeBanner: false,
              title: 'Greggs',
              routerConfig: appRouter.config(),
              themeMode: ThemeMode.dark,
              builder: (context, child) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<CartBloc>(
                      create: (context) => CartBloc(GetIt.I<CartService>()),
                    ),
                    BlocProvider<ProductBloc>(
                      create: (context) => ProductBloc(GetIt.I<FoodItemRepository>()),
                    ),
                  ],
                  child: child ?? Container(),
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }
}

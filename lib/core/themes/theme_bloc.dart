import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/scheduler.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {
  final bool isOn;

  ToggleThemeEvent(this.isOn);
}

abstract class ThemeState {
  final ThemeMode themeMode;

  ThemeState(this.themeMode);
}

class ThemeInitial extends ThemeState {
  ThemeInitial() : super(ThemeMode.system);
}

class ThemeUpdated extends ThemeState {
  ThemeUpdated(ThemeMode themeMode) : super(themeMode);
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<ToggleThemeEvent>((event, emit) {
      final themeMode = event.isOn ? ThemeMode.dark : ThemeMode.light;
      emit(ThemeUpdated(themeMode));
    });
  }

  bool get isDarkMode {
    final themeMode = state.themeMode;
    if (themeMode == ThemeMode.system) {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }
}



class AppColors {
  static const Color primaryColor = Colors.blue;
  static const Color lightPrimaryColor = Colors.lightBlue;
  static const Color blackColor = Colors.black87;
  static const Color whiteColor = Colors.white;
  static const Color greenColor = Colors.green;
  static const Color greyColor = Colors.grey;
  static const Color greyColor700 = Color(0xff616161);
  static const Color greyColor300 = Color(0xffE0E0E0);
  static const Color redColor = Colors.red;
  static const Color transparentColor = Colors.transparent;
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 16,
  );

}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.whiteColor,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        primaryContainer: AppColors.lightPrimaryColor,
        secondary: AppColors.greenColor,
        secondaryContainer: AppColors.greyColor700,
        surface: AppColors.whiteColor,
        background: AppColors.whiteColor,
        error: AppColors.redColor,
        onPrimary: AppColors.blackColor,
        onSecondary: AppColors.greyColor,
        onSurface: AppColors.greyColor300,
        onBackground: AppColors.blackColor,
        onError: AppColors.whiteColor,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading.copyWith(color: AppColors.blackColor),
        displayMedium: AppTextStyles.title.copyWith(color: AppColors.blackColor),
        displaySmall: AppTextStyles.subtitle.copyWith(color: AppColors.blackColor),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackColor),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackColor),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.blackColor),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.blackColor,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryColor,
        primaryContainer: AppColors.lightPrimaryColor,
        secondary: AppColors.greenColor,
        secondaryContainer: AppColors.greyColor700,
        surface: AppColors.blackColor,
        background: AppColors.blackColor,
        error: AppColors.redColor,
        onPrimary: AppColors.whiteColor,
        onSecondary: AppColors.greyColor,
        onSurface: AppColors.greyColor300,
        onBackground: AppColors.whiteColor,
        onError: AppColors.blackColor,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading.copyWith(color: AppColors.whiteColor),
        displayMedium: AppTextStyles.title.copyWith(color: AppColors.whiteColor),
        displaySmall: AppTextStyles.subtitle.copyWith(color: AppColors.whiteColor),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.whiteColor),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.whiteColor),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.whiteColor),
      ),
    );
  }
}



// Usage
// BlocProvider(
//   create: (context) => ThemeBloc(),
//   child: YourApp(),
// )

// Inside YourApp or anywhere in the widget tree
// BlocBuilder<ThemeBloc, ThemeState>(
//   builder: (context, state) {
//     final themeBloc = BlocProvider.of<ThemeBloc>(context);
//     return MaterialApp(
//       theme: AppTheme.getTheme(isDark: themeBloc.isDarkMode),
//       // ...
//     );
//   },
// )

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job/components/languages.dart';
import 'package:job/components/theme.dart';
import 'package:job/pages/splash_page.dart';
import 'package:job/routes/routes.dart';

void main() {
  Get.put(ThemeService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find();

    return Obx(() => GetMaterialApp(
          locale: const Locale('en'),
          fallbackLocale: const Locale('en'),
          translations: Languages(),
          debugShowCheckedModeBanner: false,
          title: 'Genuine Jobs',
          getPages: allPages,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeService.theme, // Apply theme dynamically
          home: SplashPage(),
        ));
  }
}

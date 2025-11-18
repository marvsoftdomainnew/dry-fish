import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'constants/app_strings.dart';
import 'roots/routes.dart';
import 'utils/thems/app_theme.dart';
import 'viewmodels/app_state_controller.dart';
import 'viewmodels/internet_controller.dart';
import 'services/sharedpreferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferencesService.getInstance();
  final appStateController = AppStateController(prefs);
  await appStateController.initialize();
  Get.put(appStateController);
  final internetController = Get.put(InternetController(), permanent: true);
  internetController.showPopup = false;
  runApp(const MyApp());

 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Get.find<AppStateController>();
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.lightTheme,
            themeMode: appState.themeMode.value,
            initialRoute: AppRoutes.splash,
            getPages: AppRoutes.getRoutes(),
          ),
        );
      },
    );
  }
}

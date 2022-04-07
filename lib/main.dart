import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoapp/services/notification_services.dart';
import 'package:todoapp/services/theme_services.dart';
import 'package:todoapp/services/themes.dart';
import 'package:todoapp/view/HomeScreen.dart';
import 'package:todoapp/view/splash.dart';

import 'db/db_helper.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DBHelper().database;
  NotifyHelper().initializeNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeServices _ts = ThemeServices();

    return GetMaterialApp(

      title: 'Todo',
      theme: Themes.light,
      darkTheme:Themes.dark,
      themeMode: _ts.theme,

      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_support_you/pages/splash_page.dart';
import 'package:i_support_you/pages/on_boarding_page.dart';
import 'package:i_support_you/pages/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>("TaskBox");
  return runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
        title: 'Introduction screen',
        debugShowCheckedModeBanner: false,
        home: SplashPage());
  }
}

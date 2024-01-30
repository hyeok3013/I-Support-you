import 'package:flutter/material.dart';
import 'package:i_support_you/pages/home_page.dart';
import 'package:i_support_you/pages/on_boarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
      );
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OnBoardingPage(),
        ),
      );
    }
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: Container());
  }
}

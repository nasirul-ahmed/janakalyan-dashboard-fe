import 'dart:async';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/screen/homescreen/dashboard.dart';
import 'package:janakalyan_admin/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';

class Index extends StatelessWidget {
  const Index({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Splash(),
      
      routes: {
        Splash.id : (context) => const Splash(),
      },
      initialRoute: Splash.id,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  static const id = "Splash";

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void setTimer() {
    Timer(const Duration(seconds: 1), () => {
      navigateUser()
      });
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogged = prefs.getBool('isLogged') ?? false;
    if (isLogged) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (c) => const DashBoard()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const Login()), (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    setTimer();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

import 'package:ai_resume_scanner/Screens/dashboard.dart';
import 'package:ai_resume_scanner/Screens/login_screen.dart';
import 'package:ai_resume_scanner/Screens/register_screen.dart';
import 'package:ai_resume_scanner/Screens/splash_screen.dart';
import 'package:ai_resume_scanner/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Routes{
  static MaterialPageRoute generateRoutes(RouteSettings setting){
    switch(setting.name){
      case RoutesName.splashScreen:
        return MaterialPageRoute(builder: (BuildContext context)=>SplashScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context)=>LoginScreen());
      case RoutesName.register:
        return MaterialPageRoute(builder: (BuildContext context)=>RegisterScreen());
      case RoutesName.dashboard:
        return MaterialPageRoute(builder: (BuildContext context)=>Dashboard());
      default:
        return MaterialPageRoute(builder: (BuildContext context)=>Scaffold(
          body: Container(child: Center(child: Text('No routes Define'),),),
        ));

    }
  }
}
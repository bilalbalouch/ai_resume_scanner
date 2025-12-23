import 'package:ai_resume_scanner/Component/app_bar.dart';
import 'package:ai_resume_scanner/utils/routes/routes.dart';
import 'package:ai_resume_scanner/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ai Resume Scanner',
      theme: ThemeData(
        appBarTheme: appBarTheme,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: RoutesName.splashScreen,
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}

import 'package:ai_resume_scanner/Component/app_bar.dart';
import 'package:ai_resume_scanner/utils/routes/routes.dart';
import 'package:ai_resume_scanner/utils/routes/routes_name.dart';
import 'package:ai_resume_scanner/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

// ...



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_)=>AuthViewModel())
  ],child: MyApp(),));
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

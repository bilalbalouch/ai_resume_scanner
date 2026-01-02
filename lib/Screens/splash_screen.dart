import 'dart:math';
import 'package:ai_resume_scanner/constant/my_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_resume_scanner/utils/routes/routes_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  FirebaseAuth auth=FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    Future.delayed(const Duration(seconds: 3), () {
      if(auth.currentUser!=null){
        Navigator.pushReplacementNamed(context, RoutesName.dashboard);
      }else{
        Navigator.pushReplacementNamed(context, RoutesName.login);
      }
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/app.png',
                height: 180,
                width: 180,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'AI',
              style: TextStyle(
                color: myColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Resume Scanner',
              style: TextStyle(
                color: myColor,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

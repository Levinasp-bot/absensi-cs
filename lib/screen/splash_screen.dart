import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'login_register_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _checkLoginStatus();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
  }

  void _navigateToNextScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  void _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    Timer(Duration(seconds: 3), () {
      if (user != null) {
        _navigateToNextScreen(HomeScreen());
      } else {
        _navigateToNextScreen(LoginRegisterScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(seconds: 2),
          opacity: _opacity,
          child: AnimatedContainer(
            duration: Duration(seconds: 2),
            curve: Curves.easeOutBack,
            transform: Matrix4.identity()..scale(_scale),
            child: Hero(
              tag: "logoPelindo",
              child: Image.asset('lib/assets/logo_pelindo.png', width: 200),
            ),
          ),
        ),
      ),
    );
  }
}

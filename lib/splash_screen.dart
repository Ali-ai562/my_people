import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_people/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          // spacing: 10,
          children: [
            Image.asset('assets/images/Logo 2.png'),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Text(
                'My People',
                style: GoogleFonts.bungee(
                  fontSize: 30,
                  letterSpacing: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 35),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

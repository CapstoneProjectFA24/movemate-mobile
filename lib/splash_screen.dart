import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash/splash.png', // Path to your background image
              fit: BoxFit.cover,
            ),
          ),
          // Centered orange container with logo and text
          Center(
            child: Container(
              width: 350, // Adjust width if necessary
              height: 600, // Adjust height if necessary
              decoration: BoxDecoration(
                color: const Color(0xFFFF6F00), // Orange color
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/splash/Vectortruck.png', // Path to your logo
                      width: 60, // Adjust size as needed
                      height: 60, // Adjust size as needed
                      scale: 0.7,
                    ),

                    // Text "MoveMate"
                    const Text(
                      'MoveMate',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.normal,
                        fontFamily: String.fromEnvironment('Inknut Antiqua'),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

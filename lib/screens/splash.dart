import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
      ),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}

//The idea behind this splash screen is to use it as a loading screen while firebase is figuring out whether we have token or not. 

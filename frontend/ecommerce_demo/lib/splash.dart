import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(color: Color(0x100B262C), alignment: Alignment.center,child: Text("Laza", style: TextStyle(color: Color.fromARGB(0, 2, 2, 2)),),));
  }
}

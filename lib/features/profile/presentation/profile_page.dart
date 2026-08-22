import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 70, 30, 130),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Profile',
              style: TextStyle(
                color: Color(0xFF232323),
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

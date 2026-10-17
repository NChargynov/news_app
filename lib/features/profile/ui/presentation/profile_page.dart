import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool _animated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      if (_controller.isCompleted) {
        print("shamal addListener isCompleted ${_controller.isCompleted}");
        setState(() {});
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _animated = !_animated;
                  });
                },
                child: Text("Анимация"),
              ),
              Lottie.asset(
                height: 100,
                controller: _controller,
                "assets/animation/cat_lottie.json",
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
              AnimatedAlign(
                curve: Curves.easeOutBack,
                alignment: _animated
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                duration: Duration(milliseconds: 800),
                child: Icon(Icons.open_with, size: 80),
              ),
              AnimatedContainer(
                width: _animated ? 110 : 50,
                height: _animated ? 50 : 110,
                duration: Duration(milliseconds: 800),
                decoration: BoxDecoration(
                  color: _animated
                      ? const Color(0xFF27AE60)
                      : const Color(0xFFF2994A),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 10),
              AnimatedRotation(
                curve: Curves.easeOutCubic,
                turns: _animated ? 0.25 : 0,
                duration: Duration(milliseconds: 800),
                child: Container(
                  color: Colors.red,
                  width: 50,
                  height: 40,
                  child: Icon(Icons.auto_awesome),
                ),
              ),
              SizedBox(height: 10),
              AnimatedScale(
                curve: Curves.easeOutCubic,
                scale: _animated ? 1 : 0.1,
                duration: Duration(milliseconds: 800),
                child: Container(color: Colors.green, height: 100, width: 100),
              ),
              SizedBox(height: 10),
              AnimatedCrossFade(
                firstChild: Container(
                  color: Color(0xFFEB5757),
                  child: Icon(Icons.person_outline, size: 40),
                ),
                secondChild: Container(
                  color: Color(0xFF56CCF2),
                  child: Icon(Icons.check_circle_outline, size: 40),
                ),
                crossFadeState: _animated
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 800),
              ),
              SizedBox(height: 10),
              AnimatedOpacity(
                opacity: _animated ? 1 : 0,
                duration: Duration(milliseconds: 800),
                child: Icon(Icons.visibility_outlined, size: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

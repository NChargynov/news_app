import 'dart:math' as math;

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
  late final AnimationController _transitionController;
  late final Animation<double> _progress;
  static const _duration = Duration(milliseconds: 800);
  bool _animated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _transitionController = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _progress = _transitionController.drive(
      CurveTween(curve: Curves.easeInOut),
    );

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
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _animated = !_animated);
                  if (_animated) {
                    _transitionController.forward();
                  } else {
                    _transitionController.reverse();
                  }
                },
                child: const Text('Анимация'),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: const PageStorageKey('profile-animation-examples'),
                primary: false,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _example(
                      'AnimationController + Lottie',
                      Lottie.asset(
                        'assets/animation/cat_lottie.json',
                        height: 100,
                        controller: _controller,
                        onLoaded: (composition) {
                          if (!mounted) return;
                          _controller
                            ..duration = composition.duration
                            ..forward();
                        },
                      ),
                    ),
                    _example(
                      'AnimatedAlign',
                      AnimatedAlign(
                        curve: Curves.easeOutBack,
                        alignment: _animated
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        duration: _duration,
                        child: const Icon(Icons.open_with, size: 80),
                      ),
                    ),
                    _example(
                      'AnimatedContainer',
                      AnimatedContainer(
                        width: _animated ? 110 : 50,
                        height: _animated ? 50 : 110,
                        duration: _duration,
                        decoration: BoxDecoration(
                          color: _animated
                              ? const Color(0xFF27AE60)
                              : const Color(0xFFF2994A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    _example(
                      'AnimatedRotation',
                      AnimatedRotation(
                        curve: Curves.easeOutCubic,
                        turns: _animated ? 0.25 : 0,
                        duration: _duration,
                        child: Container(
                          color: Colors.red,
                          width: 50,
                          height: 40,
                          child: const Icon(Icons.auto_awesome),
                        ),
                      ),
                    ),
                    _example(
                      'AnimatedScale',
                      AnimatedScale(
                        curve: Curves.easeOutCubic,
                        scale: _animated ? 1 : 0.1,
                        duration: _duration,
                        child: Container(
                          color: Colors.green,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    _example(
                      'AnimatedCrossFade',
                      AnimatedCrossFade(
                        firstChild: Container(
                          color: const Color(0xFFEB5757),
                          child: const Icon(Icons.person_outline, size: 40),
                        ),
                        secondChild: Container(
                          color: const Color(0xFF56CCF2),
                          child: const Icon(
                            Icons.check_circle_outline,
                            size: 40,
                          ),
                        ),
                        crossFadeState: _animated
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: _duration,
                      ),
                    ),
                    _example(
                      'AnimatedOpacity',
                      AnimatedOpacity(
                        opacity: _animated ? 1 : 0,
                        duration: _duration,
                        child: const Icon(Icons.visibility_outlined, size: 50),
                      ),
                    ),
                    _example(
                      'AnimatedDefaultTextStyle',
                      AnimatedDefaultTextStyle(
                        duration: _duration,
                        style: TextStyle(
                          fontSize: _animated ? 30 : 20,
                          fontWeight: _animated
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: _animated ? Colors.deepPurple : Colors.blue,
                        ),
                        child: const Text('Flutter'),
                      ),
                    ),
                    _example(
                      'AnimatedSize',
                      AnimatedSize(
                        duration: _duration,
                        curve: Curves.easeInOut,
                        child: Container(
                          width: 160,
                          height: _animated ? 110 : 50,
                          color: Colors.teal.shade100,
                          child: const Center(child: FlutterLogo(size: 36)),
                        ),
                      ),
                    ),
                    _example(
                      'AnimatedPositioned',
                      LayoutBuilder(
                        builder: (context, constraints) => Stack(
                          children: [
                            AnimatedPositioned(
                              duration: _duration,
                              curve: Curves.easeInOut,
                              left: _animated
                                  ? math.max(0, constraints.maxWidth - 74)
                                  : 10,
                              top: _animated ? 50 : 0,
                              child: const _DemoTile(
                                icon: Icons.directions_walk,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _example(
                      'AnimatedPhysicalModel',
                      AnimatedPhysicalModel(
                        duration: _duration,
                        shape: BoxShape.rectangle,
                        elevation: _animated ? 16 : 0,
                        color: _animated
                            ? Colors.purple.shade100
                            : Colors.blue.shade100,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(_animated ? 32 : 4),
                        child: const SizedBox.square(
                          dimension: 64,
                          child: Icon(Icons.layers_outlined, size: 32),
                        ),
                      ),
                    ),
                    _example(
                      'FadeTransition',
                      FadeTransition(
                        opacity: Tween<double>(
                          begin: 0.15,
                          end: 1,
                        ).animate(_progress),
                        child: const _DemoTile(icon: Icons.visibility_outlined),
                      ),
                    ),
                    _example(
                      'SlideTransition',
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1, 0),
                          end: const Offset(1, 0),
                        ).animate(_progress),
                        child: const _DemoTile(icon: Icons.swipe_outlined),
                      ),
                    ),
                    _example(
                      'RotationTransition',
                      RotationTransition(
                        turns: _progress,
                        child: const _DemoTile(icon: Icons.refresh),
                      ),
                    ),
                    _example(
                      'ScaleTransition',
                      ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.4,
                          end: 1,
                        ).animate(_progress),
                        child: const _DemoTile(icon: Icons.zoom_in),
                      ),
                    ),
                    _example(
                      'SizeTransition',
                      SizeTransition(
                        sizeFactor: Tween<double>(
                          begin: 0.25,
                          end: 1,
                        ).animate(_progress),
                        alignment: Alignment.topCenter,
                        child: const _DemoTile(icon: Icons.expand),
                      ),
                    ),
                    _example(
                      'AnimatedBuilder',
                      AnimatedBuilder(
                        animation: _progress,
                        child: const _DemoTile(
                          icon: Icons.rocket_launch_outlined,
                        ),
                        builder: (context, child) => Transform.translate(
                          offset: Offset(
                            0,
                            -20 * math.sin(_progress.value * math.pi),
                          ),
                          child: Transform.rotate(
                            angle: _progress.value * math.pi / 2,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _example(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 120, child: Center(child: child)),
        ],
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  const _DemoTile({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 32, color: Colors.indigo),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _animated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Account'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Animation basics',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF242424),
                      ),
                    ),
                  ),

                  Switch(
                    value: _animated,
                    activeThumbColor: Colors.black,
                    onChanged: (value) {
                      setState(() {
                        _animated = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  const SizedBox(height: 18),
                  // Lottie.asset('assets/cat_lottie.json', onLoaded: (composition) {}),
                  const SizedBox(height: 18),
                  _AnimationExampleCard(
                    title: 'AnimatedOpacity',
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _animated ? 0 : 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInCirc,
                        child: const _DemoBox(
                          color: Color(0xFF111111),
                          icon: Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),
                  _AnimationExampleCard(
                    title: 'AnimatedAlign',
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: AnimatedAlign(
                        alignment: _animated
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutBack,
                        child: const _DemoBox(
                          color: Color(0xFF2F80ED),
                          icon: Icons.open_with,
                        ),
                      ),
                    ),
                  ),
                  _AnimationExampleCard(
                    title: 'AnimatedContainer',
                    child: Center(
                      child: AnimatedContainer(
                        width: _animated ? 180 : 92,
                        height: _animated ? 92 : 180,
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.easeInOutCubic,
                        decoration: BoxDecoration(
                          color: _animated
                              ? const Color(0xFF27AE60)
                              : const Color(0xFFF2994A),
                          borderRadius: BorderRadius.circular(_animated ? 46 : 18),
                        ),
                        child: const Icon(Icons.crop_square, color: Colors.white),
                      ),
                    ),
                  ),
                  _AnimationExampleCard(
                    title: 'AnimatedScale + AnimatedRotation',
                    child: Center(
                      child: AnimatedRotation(
                        turns: _animated ? 0.95 : 0,
                        duration: const Duration(milliseconds: 550),
                        curve: Curves.easeOutCubic,
                        child: AnimatedScale(
                          scale: _animated ? 1.25 : 0.9,
                          duration: const Duration(milliseconds: 550),
                          curve: Curves.easeOutCubic,
                          child: const _DemoBox(
                            color: Color(0xFF9B51E0),
                            icon: Icons.auto_awesome,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _AnimationExampleCard(
                    title: 'AnimatedCrossFade',
                    child: Center(
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 450),
                        crossFadeState: _animated
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const _DemoBox(
                          color: Color(0xFFEB5757),
                          icon: Icons.person_outline,
                        ),
                        secondChild: const _DemoBox(
                          color: Color(0xFF56CCF2),
                          icon: Icons.check_circle_outline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          setState(() {
            _animated = !_animated;
          });
        },
        label: Text(_animated ? 'Reset' : 'Animate'),
        icon: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }
}

class _AnimationExampleCard extends StatelessWidget {
  const _AnimationExampleCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF242424),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _DemoBox extends StatelessWidget {
  const _DemoBox({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, color: Colors.white, size: 34),
    );
  }
}

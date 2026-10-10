import 'package:flutter/material.dart';
import 'package:news_app/features/navigation/ui/presentation/widgets/main_bottom_nav.dart';
import 'package:news_app/features/news/ui/presentation/everything_page.dart';
import 'package:news_app/features/news/ui/presentation/home_page.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';
import 'package:news_app/features/profile/ui/presentation/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewsHomeStyle.background,
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomePage(),
          SafeArea(top: false, child: EverythingPage()),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: MainBottomNav(
        selectedIndex: _selectedIndex,
        onSelected: (index) {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}

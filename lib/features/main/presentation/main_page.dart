import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/features/home/presentation/home_page.dart';
import 'package:news_app/features/main/presentation/bloc/main_bloc.dart';
import 'package:news_app/features/main/presentation/widgets/app_bottom_navigation.dart';
import 'package:news_app/features/news/presentation/everything_page.dart';
import 'package:news_app/features/profile/presentation/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const _pages = [HomePage(), EveryThingPage(), ProfilePage()];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => getIt<MainBloc>()..add(CheckNotificationPermissionEvent()),
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: AppBottomNavigation(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}

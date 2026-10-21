import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/features/navigation/ui/presentation/widgets/main_bottom_nav.dart';
import 'package:news_app/features/news/ui/bloc/news_bloc.dart';
import 'package:news_app/features/news/ui/bloc/news_event.dart';
import 'package:news_app/features/news/ui/presentation/everything_page.dart';
import 'package:news_app/features/news/ui/presentation/home_page.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';
import 'package:news_app/features/profile/ui/presentation/profile_page.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsBloc>(
      create: (_) => getIt<NewsBloc>()
        ..add(const GetEverythingEvent())
        ..add(RequestPermissionEvent()),
      child: Scaffold(
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/features/news/ui/bloc/news_bloc.dart';
import 'package:news_app/features/news/ui/bloc/news_event.dart';
import 'package:news_app/features/news/ui/presentation/home_page.dart';

void main() async {
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => getIt<NewsBloc>()..add(const GetEverythingEvent()),
        child: const HomePage(),
      ),
    );
  }
}

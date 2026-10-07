import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/features/auth/ui/bloc/auth_cubit.dart';
import 'package:news_app/features/auth/ui/presentation/auth_page.dart';
import 'package:news_app/features/news/ui/bloc/news_bloc.dart';
import 'package:news_app/features/news/ui/bloc/news_event.dart';
import 'package:news_app/features/news/ui/presentation/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        create: (_) => getIt<AuthCubit>(),
        child: Builder(
          builder: (context) => AuthPage(
            onAuthenticated: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => BlocProvider(
                  create: (_) =>
                      getIt<NewsBloc>()..add(const GetEverythingEvent()),
                  child: const HomePage(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

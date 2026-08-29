import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/core/router/app_router.gr.dart';
import 'package:news_app/core/service/storage_service/secure_storage_service.dart';
import 'package:news_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:news_app/features/news/presentation/news_page.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>()..checkAuth(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SuccessAuthState) {
            context.router.replaceAll([MainRoute()]);
            return;
          }
          if (state is ErrorAuthState) {
            context.router.replaceAll([AuthRoute()]);
            return;
          }
        },
        child: Scaffold(body: SizedBox()),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:news_app/features/news/presentation/news_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(30, 25, 30, 32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 57,
                  ),
                  child: IntrinsicHeight(
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacer(flex: 2),
                          const Text(
                            'Авторизация',
                            style: TextStyle(
                              color: Color(0xFF232323),
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Введите логин и пароль, чтобы продолжить',
                            style: TextStyle(
                              color: Color(0xFF777777),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 48),
                          _AuthTextField(
                            controller: _loginController,
                            hintText: 'Логин',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.username],
                          ),
                          const SizedBox(height: 16),
                          _AuthTextField(
                            controller: _passwordController,
                            hintText: 'Пароль',
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                          ),
                          const SizedBox(height: 24),
                          BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is SuccessAuthState) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const NewsPage(),
                                  ),
                                );
                              }

                              if (state is ErrorAuthState) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xFF232323),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  );
                              }
                            },
                            builder: (context, state) {
                              final bool isLoading = state is LoadingAuthState;

                              if (isLoading) {
                                return SizedBox(
                                  height: 54,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return SizedBox(
                                height: 54,
                                child: FilledButton(
                                  onPressed: () => _authorize(context),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF232323),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: const StadiumBorder(),
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  child: const Text('Авторизоваться'),
                                ),
                              );
                            },
                          ),
                          const Spacer(flex: 3),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _authorize(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    final String login = _loginController.text.trim();
    final String password = _passwordController.text.trim();

    context.read<AuthCubit>().auth(login, password);
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.hintText,
    required this.textInputAction,
    required this.autofillHints,
    this.keyboardType,
    this.obscureText = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String> autofillHints;
  final bool obscureText;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        obscureText: obscureText,
        enableSuggestions: !obscureText,
        autocorrect: false,
        onSubmitted: onSubmitted,
        cursorColor: const Color(0xFF252525),
        style: const TextStyle(
          color: Color(0xFF252525),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFB7B7B7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: const Color(0xFFF1F1F1),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(28)),
            borderSide: BorderSide(
              color: const Color(0xFF232323).withValues(alpha: 0.35),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/auth/ui/bloc/auth_cubit.dart';
import 'package:news_app/features/auth/ui/bloc/auth_state.dart';
import 'package:news_app/features/auth/ui/presentation/auth_style.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.onAuthenticated});

  final VoidCallback onAuthenticated;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final cubit = context.read<AuthCubit>();
    if (cubit.state is LoadingAuthState || !_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    cubit.auth(_loginController.text.trim(), _passwordController.text);
  }

  InputDecoration _decoration(String hint, {Widget? suffixIcon}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide.none,
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: AuthStyle.input.copyWith(color: AuthStyle.muted),
      filled: true,
      fillColor: AuthStyle.field,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: border,
      enabledBorder: border,
      disabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AuthStyle.text),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AuthStyle.error),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: AuthStyle.error),
      ),
      errorStyle: AuthStyle.input.copyWith(color: AuthStyle.error),
      errorMaxLines: 2,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SuccessAuthState) {
          TextInput.finishAutofillContext();
          widget.onAuthenticated();
        }
      },
      builder: (context, state) {
        final loading = state is LoadingAuthState;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: AutofillGroup(
                    onDisposeAction: AutofillContextAction.cancel,
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.newspaper_outlined,
                                size: 28,
                                color: AuthStyle.text,
                              ),
                              SizedBox(width: 12),
                              Text('News App', style: AuthStyle.label),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(height: 1, color: AuthStyle.divider),
                          const SizedBox(height: 48),
                          const Text('С возвращением', style: AuthStyle.title),
                          const SizedBox(height: 12),
                          const Text(
                            'Войдите, чтобы читать новости.',
                            style: AuthStyle.body,
                          ),
                          const SizedBox(height: 40),
                          const Text('Логин', style: AuthStyle.label),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _loginController,
                            enabled: !loading,
                            style: AuthStyle.input,
                            cursorColor: AuthStyle.text,
                            decoration: _decoration('Введите логин'),
                            autofillHints: const [AutofillHints.username],
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            enableSuggestions: false,
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Введите логин'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          const Text('Пароль', style: AuthStyle.label),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            enabled: !loading,
                            style: AuthStyle.input,
                            cursorColor: AuthStyle.text,
                            obscureText: _obscurePassword,
                            autocorrect: false,
                            enableSuggestions: false,
                            autofillHints: const [AutofillHints.password],
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: _decoration(
                              'Введите пароль',
                              suffixIcon: IconButton(
                                tooltip: _obscurePassword
                                    ? 'Показать пароль'
                                    : 'Скрыть пароль',
                                color: AuthStyle.muted,
                                onPressed: loading
                                    ? null
                                    : () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 22,
                                ),
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Введите пароль'
                                : null,
                          ),
                          if (state is ErrorAuthState) ...[
                            const SizedBox(height: 20),
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                state.message,
                                style: AuthStyle.input.copyWith(
                                  color: AuthStyle.error,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
                          FilledButton(
                            onPressed: loading ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AuthStyle.text,
                              disabledBackgroundColor: AuthStyle.text,
                              foregroundColor: Colors.white,
                              textStyle: AuthStyle.label,
                              minimumSize: const Size.fromHeight(54),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: const StadiumBorder(),
                            ),
                            child: loading
                                ? Semantics(
                                    label: 'Выполняется вход',
                                    child: const SizedBox.square(
                                      dimension: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : const Text('Войти'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

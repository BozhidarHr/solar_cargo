import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/common/constants.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';

import '../../../generated/l10n.dart';
import '../../../providers/auth_provider.dart';
import '../../../routes/route_list.dart';
import '../../common/auto_hide_keyboard.dart';
import '../../common/flash_helper.dart';
import '../../common/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<AuthProvider>(builder: (context, model, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (model.errorMessage != null) {
              FlashHelper.errorMessage(
                context,
                message: model.errorMessage!,
              );
            model.clearError();
          }
        });
        if (model.isLoggedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, RouteList.home);
          });
        }

        return Stack(children: [
          AutoHideKeyboard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Logo
                      Image.asset(
                        kLogoImage,
                        width: 346,
                        height: 134,
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _emailController,
                        style: Theme.of(context).textTheme.titleMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kFormFieldBackgroundColor,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: SvgPicture.asset(kUserTagSvg),
                            ),
                          ),
                          hintText: S.of(context).email,
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextField(
                        controller: _passwordController,
                        obscureText: obscurePassword,
                        style: Theme.of(context).textTheme.titleMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kFormFieldBackgroundColor,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: SvgPicture.asset(kLockSvg),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(
                                  () => obscurePassword = !obscurePassword);
                            },
                          ),
                          hintText: S.of(context).password,
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).primaryColor, // Green button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            if (_emailController.text.isEmptyOrNull ||
                                _passwordController.text.isEmptyOrNull) {
                              FlashHelper.errorMessage(
                                context,
                                message: S.of(context).fillFieldsError,
                              );
                              return;
                            }
                            await model.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          },
                          child: Text(
                            S.of(context).login,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      // Loading overlay
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (model.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: const LoadingWidget(),
              ),
            ),
        ]);
      }),
    );
  }
}

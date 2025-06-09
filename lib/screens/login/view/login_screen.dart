import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solar_cargo/screens/common/constants.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
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
                    hintText: 'Email address',
                    hintStyle: Theme.of(context).textTheme.titleMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),

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
                        setState(() => obscurePassword = !obscurePassword);
                      },
                    ),
                    hintText: 'Password',
                    hintStyle: Theme.of(context).textTheme.titleMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Handle login
                    },
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:bpibs/constants/const.dart';
import 'package:flutter/material.dart';
import '../widgets/login_widget.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor1,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 20.0,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.06),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 90,
                              ),
                              logo(size.height / 5, size.height / 3),
                              const SizedBox(
                                height: 20,
                              ),
                              textHeader(size),
                              const SizedBox(
                                height: 62,
                              ),
                              usernameTextField(size, usernameController),
                              const SizedBox(
                                height: 20,
                              ),
                              passwordTextField(size, passwordController),
                              const SizedBox(
                                height: 50,
                              ),
                              signInButton(size, context),
                              const SizedBox(
                                height: 20,
                              ),
                              footer(context),
                            ],
                          ),
                        ),

                        // Expanded(
                        //   flex: 1,
                        //   child: Column(
                        //     children: [
                        //       textHeader(size),
                        //     ],
                        //   ),
                        // ),

                        // // Email and Password
                        // Expanded(
                        //   flex: 1,
                        //   child: Column(
                        //     children: [
                        //       usernameTextField(size, usernameController),
                        //       passwordTextField(size, passwordController),
                        //       buildRemember(size),
                        //     ],
                        //   ),
                        // ),

                        // //Login Button
                        // Expanded(
                        //   flex: 1,
                        //   child: Column(
                        //     children: [
                        //       signInButton(
                        //         size,
                        //         () {
                        //           // LoginController().loginUser(context,
                        //           //     emailController, passwordController);
                        //         },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

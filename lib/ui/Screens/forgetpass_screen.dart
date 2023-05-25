import 'package:flutter/material.dart';
import '../../constants/const.dart';
import '../widgets/forgetpass_widget.dart';

class ForgetpassScreen extends StatefulWidget {
  static const id = 'ForgetpassScreen';
  const ForgetpassScreen({super.key});

  @override
  State<ForgetpassScreen> createState() => _ForgetpassScreenState();
}

class _ForgetpassScreenState extends State<ForgetpassScreen> {
  TextEditingController usernameController = TextEditingController();

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
                                height: 15,
                              ),
                              textInfo(size),
                              const SizedBox(
                                height: 50,
                              ),
                              signInButton(
                                size,
                                () {
                                  // LoginController().loginUser(context,
                                  //     emailController, passwordController);
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              footer(context)
                            ],
                          ),
                        ),
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

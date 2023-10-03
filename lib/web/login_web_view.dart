import 'package:budget_app_starting/components.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//import '../view_model.dart';

class LoginViewWeb extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
   // final viewModelProvider = ref.watch(viewModel);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/login_image.png",
              width: deviceWidth / 2.6,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: deviceHeight / 5.5),
                  Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                    width: 200.0,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  EmailAndPasswordFields(),
                  SizedBox(
                    height: 30.0,
                  ),
                  RegisterAndLogin(),
                  SizedBox(
                    height: 30,
                  ),
                  //Google signIn
                  GoogleSignInButton()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

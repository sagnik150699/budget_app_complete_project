import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components.dart';
//import '../view_model.dart';

class LoginViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
   // final viewModelProvider = ref.watch(viewModel);
    final double deviceHeight = MediaQuery.of(context).size.height;
    //  final double categoryWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: deviceHeight / 5.5),
              Image.asset(
                "assets/logo.png",
                fit: BoxFit.contain,
                width: 210.0,
              ),
              SizedBox(
                height: 30.0,
              ),
              EmailAndPasswordFields(),
              SizedBox(
                height: 30.0,
              ),
              //Register
              RegisterAndLogin(),
              SizedBox(
                height: 30,
              ),
              //Google signIn
              GoogleSignInButton()
            ],
          ),
        ),
      ),
    );
  }
}

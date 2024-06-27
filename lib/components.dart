import 'package:budget_app_starting/view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/sign_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Pacifico extends StatelessWidget {
  final text;
  final size;
  final color;
  //final fontWeight;
  const Pacifico({
    Key? key,
    required this.text,
    required this.size,
    this.color,
    //this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      style: GoogleFonts.pacifico(
        fontSize: size,
        color: color == null ? Colors.black : color,
        // fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
      ),
    );
  }
}

class OpenSans extends StatelessWidget {
  final text;
  final size;
  final color;
  final fontWeight;
  const OpenSans(
      {Key? key,
      required this.text,
      required this.size,
      this.color,
      this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      style: GoogleFonts.openSans(
        fontSize: size,
        color: color == null ? Colors.black : color,
        fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
      ),
    );
  }
}

class Poppins extends StatelessWidget {
  final text;
  final size;
  final color;
  final fontWeight;
  const Poppins(
      {Key? key,
      required this.text,
      required this.size,
      this.color,
      this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      style: GoogleFonts.poppins(
        fontSize: size,
        color: color == null ? Colors.black : color,
        fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
      ),
    );
  }
}

DialogBox(BuildContext context, String title) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: EdgeInsets.all(32.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(width: 2.0, color: Colors.black),
      ),
      title: OpenSans(
        text: title,
        size: 20.0,
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: Colors.black,
          child: OpenSans(
            text: "Okay",
            size: 20.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

class IncomeExpenseRow extends StatelessWidget {
  final text;
  final amount;

  const IncomeExpenseRow({
    Key? key,
    required this.text,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Poppins(
          text: text,
          size: 15.0,
          color: Colors.white,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Poppins(
            text: "$amount \$",
            size: 15.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class IncomeExpenseRowMobile extends StatelessWidget {
  final text;
  final amount;

  const IncomeExpenseRowMobile({
    Key? key,
    required this.text,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Poppins(
          text: text,
          size: 12.0,
          color: Colors.black,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Poppins(
            text: "$amount \$",
            size: 12.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class TextForm extends StatelessWidget {
  final text;
  final containerWidth;
  final hintText;
  final controller;
  final digitsOnly;
  final validator;

  const TextForm({
    Key? key,
    required this.text,
    required this.containerWidth,
    required this.hintText,
    required this.controller,
    this.digitsOnly,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OpenSans(
          size: 13.0,
          text: text,
        ),
        SizedBox(height: 5.0),
        SizedBox(
          width: containerWidth,
          child: TextFormField(
            validator: validator,
            inputFormatters: digitsOnly != null
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            controller: controller,
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(fontSize: 13.0),
            ),
          ),
        ),
      ],
    );
  }
}

TextEditingController _emailField = TextEditingController();

TextEditingController _passwordField = TextEditingController();

class EmailAndPasswordFields extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Column(
      children: [
        //Email
        SizedBox(
          width: 350.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            controller: _emailField,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                  size: 30.0,
                ),
                hintText: "Email",
                hintStyle: GoogleFonts.openSans()),
          ),
        ),
        SizedBox(height: 20),
        //Password
        SizedBox(
          width: 350.0,
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: _passwordField,
            obscureText: viewModelProvider.isObscure,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                prefixIcon: IconButton(
                  icon: Icon(
                    viewModelProvider.isObscure
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  onPressed: () {
                    viewModelProvider.toggleObscure();
                  },
                ),
                hintText: "Password",
                hintStyle: GoogleFonts.openSans()),
          ),
        ),
      ],
    );
  }
}

class RegisterAndLogin extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50.0,
          width: 140.0,
          child: MaterialButton(
            child: OpenSans(
              text: "Register",
              size: 24.0,
              color: Colors.white,
            ),
            onPressed: () async {
              await viewModelProvider.createUserWithEmailAndPassword(
                  context, _emailField.text, _passwordField.text);
            },
            splashColor: Colors.grey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        ),

        SizedBox(
          width: 20.0,
        ),
        Pacifico(
          text: "OR",
          size: 15.0,
        ),
        SizedBox(
          width: 20.0,
        ),
        //Login
        SizedBox(
          height: 50.0,
          width: 150.0,
          child: MaterialButton(
            child: OpenSans(
              text: "Login",
              size: 24.0,
              color: Colors.white,
            ),
            onPressed: () async {
              await viewModelProvider.signInWithEmailAndPassword(
                  context, _emailField.text, _passwordField.text);
            },
            splashColor: Colors.grey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ],
    );
  }
}

class GoogleSignInButton extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return //Google signIn
        SignInButton(
      buttonType: ButtonType.google,
      btnColor: Colors.black,
      btnTextColor: Colors.white,
      buttonSize: ButtonSize.large, // small(default), medium, large
      onPressed: () async {
        if (kIsWeb) {
          await viewModelProvider.signInWithGoogleWeb(context);
        } else {
          await viewModelProvider.signInWithGoogleMobile(context);
        }
      },
    );
  }
}

class DrawerExpense extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DrawerHeader(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.0, color: Colors.black)),
              child: CircleAvatar(
                radius: 180.0,
                backgroundColor: Colors.white,
                child: Image(
                  height: 100.0,
                  image: AssetImage(
                    'assets/logo.png',
                  ),
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          MaterialButton(
            elevation: 20.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            height: 50.0,
            minWidth: 200.0,
            color: Colors.black,
            child: OpenSans(
              text: "Logout",
              size: 20.0,
              color: Colors.white,
            ),
            onPressed: () async {
              await viewModelProvider.logout();
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () async => await launchUrl(
                    Uri.parse("https://www.instagram.com/tomcruise")),
                icon: SvgPicture.asset(
                  "assets/instagram.svg",
                  color: Colors.black,
                  width: 35.0,
                ),
              ),
              IconButton(
                onPressed: () async => await launchUrl(
                    Uri.parse("https://www.twitter.com/tomcruise")),
                icon: SvgPicture.asset(
                  "assets/twitter.svg",
                  color: Colors.black,
                  width: 35.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AddExpense extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SizedBox(
      height: 45.0,
      width: 160.0,
      child: MaterialButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            OpenSans(
              text: "Add Expense",
              size: 17.0,
              color: Colors.white,
            ),
          ],
        ),
        onPressed: () async {
          await viewModelProvider.addExpense(context);
        },
        splashColor: Colors.grey,
        color: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}

class AddIncome extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SizedBox(
      height: 45.0,
      width: 160.0,
      child: MaterialButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            OpenSans(
              text: "Add Income",
              size: 17.0,
              color: Colors.white,
            ),
          ],
        ),
        onPressed: () async {
          await viewModelProvider.addIncome(context);
        },
        splashColor: Colors.grey,
        color: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}

class TotalCalculation extends HookConsumerWidget {
  final size;
  TotalCalculation(this.size);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Poppins(
              text: "Budget left",
              size: size,
              color: Colors.white,
            ),
            Poppins(
              text: "Total Expense",
              size: size,
              color: Colors.white,
            ),
            Poppins(
              text: "Total Income",
              size: size,
              color: Colors.white,
            ),
          ],
        ),
        RotatedBox(
          quarterTurns: 1,
          child: Divider(
            indent: 40.0,
            endIndent: 40.0,
            color: Colors.grey,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Poppins(
              text: " ${viewModelProvider.budgetLeft}\$",
              size: size,
              color: Colors.white,
            ),
            Poppins(
              text: " ${viewModelProvider.totalExpense}\$",
              size: size,
              color: Colors.white,
            ),
            Poppins(
              text: " ${viewModelProvider.totalIncome}\$",
              size: size,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}

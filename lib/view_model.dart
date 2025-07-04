import 'package:budget_app_starting/components.dart';
import 'package:budget_app_starting/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(viewModel).authStateChange;
});

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  List<Models> expenses = [];
  List<Models> incomes = [];
  final GoogleSignIn _google = GoogleSignIn.instance;   // v 7+ singleton

//  bool isSignedIn = false;
  bool isObscure = true;
  int totalExpense = 0;
  int totalIncome = 0;
  int budgetLeft = 0;
  var logger = Logger();
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  Stream<User?> get authStateChange => _auth.authStateChanges();
//Check if Signed In
//   Future<void> isLoggedIn() async {
//     await _auth.authStateChanges().listen((User? user) {
//       if (user == null) {
//         isSignedIn = false;
//       } else {
//         isSignedIn = true;
//       }
//     });
//     notifyListeners();
//   }

  //Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void calculate() {
    totalExpense = 0;
    totalIncome = 0;
    for (int i = 0; i < expenses.length; i++) {
      totalExpense = totalExpense + int.parse(expenses[i].amount);
    }
    for (int i = 0; i < incomes.length; i++) {
      totalIncome = totalIncome + int.parse(incomes[i].amount);
    }
    budgetLeft = totalIncome - totalExpense;
    notifyListeners();
  }

  //Authentication
  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      logger.d("Login successful");
    }).onError((error, stackTrace) {
      logger.d(error);
      DialogBox(context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String _email, String _password) async {
    await _auth
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((value) {
      logger.d("Login successful");
    }).onError((error, stackTrace) {
      logger.d(error);
      DialogBox(context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

//--------------------------------------------------------------------
  ///  GOOGLE-SIGN-IN  – WEB
//--------------------------------------------------------------------
  Future<void> signInWithGoogleWeb(BuildContext context) async {
    final googleProvider = GoogleAuthProvider();

    await _auth
        .signInWithPopup(googleProvider)                       // Firebase Web flow
        .then((_) => logger.d(
      'Current user UID present? '
          '${_auth.currentUser?.uid.isNotEmpty ?? false}',
    ))
        .onError((error, stackTrace) => DialogBox(
      context,
      error.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
    ));
  }

//--------------------------------------------------------------------
  ///  GOOGLE-SIGN-IN  – MOBILE  (Android / iOS)  – v 7 API
//--------------------------------------------------------------------
  Future<void> signInWithGoogleMobile(BuildContext context) async {
    final GoogleSignInAccount account = await _google
        .authenticate(scopeHint: const ['email'])              // replaces signIn()
        .onError((error, stackTrace) {
      DialogBox(
        context,
        error.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
      );
      throw error!;
    });

    // authentication is now *synchronous* and returns only idToken
    final String? idToken = account.authentication.idToken;

    final credential = GoogleAuthProvider.credential(idToken: idToken);

    await _auth.signInWithCredential(credential).then(
          (value) => logger.e('Signed in successfully $value'),
    ).onError((error, stackTrace) {
      DialogBox(context, error.toString().replaceAll(RegExp(r'\[.*?\]'), ''));
      logger.d(error);
    });
  }

  //Database

  Future addExpense(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();
    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.all(32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(width: 1.0, color: Colors.black),
        ),
        title: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(
                text: "Name",
                containerWidth: 130.0,
                hintText: "Name",
                controller: controllerName,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return "Required.";
                  }
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              TextForm(
                text: "Amount",
                containerWidth: 100.0,
                hintText: "Amount",
                controller: controllerAmount,
                digitsOnly: true,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return "Required.";
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            child: OpenSans(
              text: "Save",
              size: 15.0,
              color: Colors.white,
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                userCollection
                    .doc(_auth.currentUser!.uid)
                    .collection("expenses")
                    .add({
                  "name": controllerName.text,
                  "amount": controllerAmount.text
                }).onError((error, stackTrace) {
                  logger.d("add expense error = $error");
                  return DialogBox(context, error.toString());
                });
                Navigator.pop(context);
              }
            },
            splashColor: Colors.grey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        ],
      ),
    );
  }

  Future addIncome(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();
    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.all(32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(width: 1.0, color: Colors.black),
        ),
        title: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(
                text: "Name",
                containerWidth: 130.0,
                hintText: "Name",
                controller: controllerName,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return "Required.";
                  }
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              TextForm(
                text: "Amount",
                containerWidth: 100.0,
                hintText: "Amount",
                controller: controllerAmount,
                digitsOnly: true,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return "Required.";
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            child: OpenSans(
              text: "Save",
              size: 15.0,
              color: Colors.white,
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                userCollection
                    .doc(_auth.currentUser!.uid)
                    .collection("incomes")
                    .add({
                  "name": controllerName.text,
                  "amount": controllerAmount.text
                }).then((value) {
                  logger.d("Income added");
                }).onError((error, stackTrace) {
                  logger.d("add income error = $error");
                  return DialogBox(context, error.toString());
                });
                Navigator.pop(context);
              }
            },
            splashColor: Colors.grey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        ],
      ),
    );
  }

  void expensesStream() async {
    await for (var snapshot in FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('expenses')
        .snapshots()) {
      expenses = [];
      snapshot.docs.forEach((element) {
        expenses.add(Models.fromJson(element.data()));
      });
      logger.d("Expense Models ${expenses.length}");
      notifyListeners();
      // expensesAmount = [];
      // expensesName = [];
      // for (var expenses in snapshot.docs) {
      //   expensesName.add(expenses.data()['name']);
      //   expensesAmount.add(expenses.data()['amount']);
      //   logger.d(expensesName, expensesAmount);
      //   notifyListeners();
      // }
      calculate();
    }
  }

  void incomesStream() async {
    await for (var snapshot in FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('incomes')
        .snapshots()) {
      incomes = [];
      snapshot.docs.forEach((element) {
        incomes.add(Models.fromJson(element.data()));
      });
      notifyListeners();
      // incomesAmount = [];
      // incomesName = [];
      // for (var expenses in snapshot.docs) {
      //   incomesName.add(expenses.data()['name']);
      //   incomesAmount.add(expenses.data()['amount']);
      //   logger.d(incomesName, incomesAmount);
      //   notifyListeners();
      // }
      calculate();
    }
  }

  Future<void> reset() async {
    await userCollection
        .doc(_auth.currentUser!.uid)
        .collection("expenses")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    await userCollection
        .doc(_auth.currentUser!.uid)
        .collection("incomes")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
} //class

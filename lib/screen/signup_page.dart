import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:pro/screen/login_page.dart';

import '../appLocalizations.dart';
import '../main.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final myControllerEmail = TextEditingController();
  final myControllerPass = TextEditingController();
  final myControllerConPass = TextEditingController();
  bool isLoading = false;

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('homePage')),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'Sign Out') {
                setState(() {
                  isLoading = true;
                });
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                setState(() {
                  isLoading = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Language',
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    onSelected: (value) {
                      if (value == 'English') {
                        MyApp.setLocale(context, const Locale('en', 'US'));
                      } else if (value == 'Arabic') {
                        MyApp.setLocale(context, const Locale('ar'));
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'Arabic',
                        child: Text(
                            AppLocalizations.of(context)!.translate('Arabic')),
                      ),
                      PopupMenuItem<String>(
                        value: 'English',
                        child: Text(
                            AppLocalizations.of(context)!.translate('English')),
                      ),
                    ],
                    child: Text(
                        AppLocalizations.of(context)!.translate('language')),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.flickr(
                  leftDotColor: Colors.purple.shade100,
                  rightDotColor: Colors.purple.shade300,
                  size: 60))
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  // end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.shade200,
                    Colors.purple.shade100,
                    Colors.white
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('Sign up'),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 40),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('create your account'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        FadeInUp(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 300),
                            child: SizedBox(
                              width: 70,
                              height: 70,
                              child: Image.asset('assets/images/hello.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Form(
                              key: formState,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20, right: 20),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      controller: myControllerEmail,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!
                                            .translate('Email'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20, right: 20),
                                    child: PasswordField(
                                      controller: myControllerPass,
                                      passwordConstraint: r'.*[@$#.*].*',
                                      color: Colors.purple.shade200,
                                      hintText: AppLocalizations.of(context)!
                                          .translate('password'),
                                      errorMessage:
                                          'must contain special character either . * @ # \$',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20, right: 20),
                                    child: PasswordField(
                                      controller: myControllerConPass,
                                      passwordConstraint: r'.*[@$#.*].*',
                                      color: Colors.purple.shade200,
                                      hintText: AppLocalizations.of(context)!
                                          .translate('confirm password'),
                                      errorMessage:
                                          'must contain special character either . * @ # \$',
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 70, left: 30, right: 30),
                                      child: MaterialButton(
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        onPressed: () async {
                                          if (formState.currentState!
                                              .validate()) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            try {
                                              if (myControllerPass.text ==
                                                  myControllerConPass.text) {
                                                final credential =
                                                    await FirebaseAuth.instance
                                                        .createUserWithEmailAndPassword(
                                                  email: myControllerEmail.text,
                                                  password:
                                                      myControllerPass.text,
                                                );
                                                FirebaseAuth
                                                    .instance.currentUser!
                                                    .sendEmailVerification();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginPage()),
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Error'),
                                                      content: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  'the password and confirm the password not the same')),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'OK'),
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .translate(
                                                                      'OK')),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            } on FirebaseAuthException catch (e) {
                                              if (e.code == 'weak-password') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Error'),
                                                      content: const Text(
                                                          'The password provided is too weak.'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'OK'),
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else if (e.code ==
                                                  'email-already-in-use') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Error'),
                                                      content: const Text(
                                                          'The account already exists for that email.'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'OK'),
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            } catch (e) {
                                              print(e);
                                            } finally {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          } else {
                                            print("textfiled is empty");
                                          }
                                        },
                                        color: Colors.purple.shade200,
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .translate('Sign up')),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

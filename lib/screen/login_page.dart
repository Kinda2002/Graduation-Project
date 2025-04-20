import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:pro/screen/selectPage.dart';
import 'package:pro/screen/signup_page.dart';

import '../appLocalizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final myControllerEmail = TextEditingController();
  final myControllerPass = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    setState(() {
      isLoading = true;
    });
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credentialfl
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    setState(() {
      isLoading = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: Text(
                              AppLocalizations.of(context)!.translate('login'),
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
                                .translate('welcome back'),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
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
                  // const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: ListView(
                        children: [
                          Form(
                            key: formState,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, top: 15),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .translate(
                                                'Please Enter Any Email');
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
                                      left: 30, right: 30, top: 15),
                                  child: PasswordField(
                                    controller: myControllerPass,
                                    passwordConstraint: r'.*[@$#.*].*',
                                    color: Colors.purple,
                                    hintText: AppLocalizations.of(context)!
                                        .translate('enter your password'),
                                    errorMessage: AppLocalizations.of(context)!
                                        .translate(
                                            'must contain special character either'),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 250, top: 1),
                                  child: TextButton(
                                    onPressed: () async {
                                      if (myControllerEmail.text == "") {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(AppLocalizations.of(
                                                      context)!
                                                  .translate(
                                                      'Please Enter Your Email')),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .translate('OK')),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        return;
                                      }
                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: myControllerEmail.text);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(AppLocalizations.of(
                                                      context)!
                                                  .translate(
                                                      'Please go to your email for Reset Password')),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .translate('OK')),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        if (e is FirebaseAuthException &&
                                            e.code == 'user-not-found') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: const Text(
                                                    'This Email don\'t have account'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text(
                                                    'An unknown error occurred: ${e.toString()}'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('forget password'),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, left: 12, right: 12),
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
                                          // print(isLoading);
                                          try {
                                            final credential =
                                                await FirebaseAuth.instance
                                                    .signInWithEmailAndPassword(
                                              email: myControllerEmail.text,
                                              password: myControllerPass.text,
                                            );
                                            if (credential
                                                .user!.emailVerified) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SelectPage()),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Text(AppLocalizations
                                                            .of(context)!
                                                        .translate(
                                                            'Please go to your email for verification')),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
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
                                            if (e.code == 'user-not-found') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Error'),
                                                    content: const Text(
                                                        'don\'t have account for that email'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else if (e.code ==
                                                'wrong-password') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Error'),
                                                    content: const Text(
                                                        'Wrong password'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Text(AppLocalizations
                                                            .of(context)!
                                                        .translate(
                                                            'Wrong in Email or Password')),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ); // Handle any other errors
                                            }
                                          } finally {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        }
                                      },
                                      color: Colors.purple.shade100,
                                      child: Text(AppLocalizations.of(context)!
                                          .translate('login')),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    margin: const EdgeInsets.all(14),
                                    child: MaterialButton(
                                      height: 40,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      onPressed: () {
                                        signInWithGoogle();
                                      },
                                      color: Colors.purple.shade100,
                                      child: Text(AppLocalizations.of(context)!
                                          .translate('login with google')),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      Text(AppLocalizations.of(context)!
                                          .translate('don\'t have an account')),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignupPage()),
                                          );
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .translate('register')),
                                      )
                                    ],
                                  ),
                                ),
                              ],
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

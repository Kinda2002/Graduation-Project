import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pro/screen/login_page.dart';
import 'package:pro/screen/resultPage.dart';

import '../appLocalizations.dart';
import '../main.dart';

class TextPage extends StatefulWidget {
  const TextPage({super.key});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final myControllerText = TextEditingController();
    GlobalKey<FormState> formState = GlobalKey<FormState>();
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
                PopupMenuItem(
                  value: 'Sign Out',
                  child:
                      Text(AppLocalizations.of(context)!.translate('sign out')),
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
          : Form(
              key: formState,
              child: ListView(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.purple.shade200,
                          Colors.purple.shade100,
                          Colors.white
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade100, spreadRadius: 2),
                            ],
                          ),
                          //color: Colors.white,
                          width: 300,
                          height: 550,
                          child: ListView(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: Container(
                                  width: 200,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple.shade100,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('enter your text'),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 70,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: '',
                                    labelText: AppLocalizations.of(context)!
                                        .translate(
                                            'your text want to translated'),
                                  ),
                                  controller: myControllerText,
                                ),
                              ),
                              const SizedBox(
                                height: 200,
                              ),
                              InkWell(
                                onTap: () {
                                  if (formState.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResultPage(
                                                txt: myControllerText.text,
                                              )),
                                    );
                                  }
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child:
                                          Image.asset('assets/images/play.png'),
                                    ),
                                    Text(AppLocalizations.of(context)!
                                        .translate('show')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

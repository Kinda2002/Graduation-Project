import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pro/screen/login_page.dart';
import 'package:pro/screen/text_page.dart';
import 'package:pro/screen/voicePage.dart';

import '../appLocalizations.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
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
          : Container(
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
                        BoxShadow(color: Colors.grey.shade100, spreadRadius: 2),
                      ],
                    ),
                    //color: Colors.white,
                    width: 300,
                    height: 550,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
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
                                  .translate('Select type of input'),
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TextPage()),
                            );
                          },
                          child: Container(
                            width: 150.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            child: Column(children: [
                              SizedBox(
                                width: 85,
                                height: 85,
                                child: Image.asset('assets/images/keypad.png'),
                              ),
                              Text(
                                AppLocalizations.of(context)!.translate('Text'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VoicePage()),
                            );
                          },
                          child: Container(
                            width: 150.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Image.asset('assets/images/voice.png'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('voice'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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

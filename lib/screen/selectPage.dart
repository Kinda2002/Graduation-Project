import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pro/screen/home_page.dart';
import 'package:pro/screen/languagePage.dart';

import '../appLocalizations.dart';
import '../main.dart';
import 'login_page.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
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
                          width: 250,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.purple.shade100,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('Select the type of process'),
                              style: const TextStyle(fontSize: 15),
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
                                  builder: (context) => const LanguagePage()),
                            );
                          },
                          child: Container(
                            width: 160.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Image.asset('assets/images/video.png'),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.translate(
                                      'From sign language to speech'),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
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
                                  builder: (context) => const HomePage()),
                            );
                          },
                          child: Container(
                            width: 160.0,
                            height: 150.0,
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
                                  child: Image.asset(
                                      'assets/images/translate.png'),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.translate(
                                      'from speech to sign language'),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pro/screen/login_page.dart';
import 'package:pro/screen/result_detect_ar_lett.dart';
import 'package:pro/screen/result_detect_ar_wor.dart';
import 'package:pro/screen/result_detect_en.dart';

import '../appLocalizations.dart';
import '../main.dart';

enum SingingCharacter { arabic_letters, english, arabic_word }

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  bool isLoading = false;
  SingingCharacter? _character = SingingCharacter.arabic_letters;
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
                          height: 50,
                        ),
                        Container(
                          width: 250,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.purple.shade50,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('Select Your Choice'),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: 250,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.purple.shade100,
                          ),
                          child: ListTile(
                            title: Text(AppLocalizations.of(context)!
                                .translate('Arabic letters')),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.arabic_letters,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 250,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.purple.shade100,
                          ),
                          child: ListTile(
                            title: Text(AppLocalizations.of(context)!
                                .translate('Arabic words')),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.arabic_word,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 250,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.purple.shade100,
                          ),
                          child: ListTile(
                            title: Text(AppLocalizations.of(context)!
                                .translate('English letters and number')),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.english,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            if (_character == SingingCharacter.english) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResultDetectEn()),
                              );
                            } else if (_character ==
                                SingingCharacter.arabic_letters) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResultDetectArLett()),
                              );
                            } else if (_character ==
                                SingingCharacter.arabic_word) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultDetectArWor()),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                  color: Colors.purple.shade100,
                                  width: 50,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 9.0, right: 5.0),
                                    child: Image.asset(
                                        'assets/images/play_button.png'),
                                  )),
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
    );
  }
}

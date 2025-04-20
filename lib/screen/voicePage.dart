import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pro/screen/resultPage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../appLocalizations.dart';
import '../main.dart';
import 'login_page.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  bool isLoading = false;
  //final myControllerText = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('status: $status');
          if (status == stt.SpeechToText.listeningStatus) {
            setState(() {
              _isListening = true;
            });
          }
        },
        onError: (error) {
          print('Error: $error');
          setState(() {
            _isListening = false;
          });
        },
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
          localeId: 'ar', // Arabic (Egypt) locale
          listenMode: stt.ListenMode.dictation,
        );
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
  }

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
                    width: 300,
                    height: 550,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 10),
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
                                    .translate('record your speech'),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                        Text(_text, textAlign: TextAlign.center),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: _listen,
                          child: Icon(_isListening
                              ? Icons.record_voice_over
                              : Icons.voice_over_off),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        InkWell(
                          onTap: () {
                            if (_text ==
                                'Press the button and start speaking') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Please enter the text you want to translate'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultPage(
                                          txt: _text,
                                        )),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.asset('assets/images/play.png'),
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
    );
  }
}

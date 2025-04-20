import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pro/screen/login_page.dart';
import 'package:pro/screen/selectPage.dart';

import 'appLocalizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyBRWWK4QUagamIJEzlXkSVr3IG-CgPidEc',
        appId: '1:80737705039:android:1b66ddd09a8634ca3c5e3a',
        messagingSenderId: '80737705039',
        projectId: 'firstproject-191a0'),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('=======================User is currently signed out!');
      } else {
        print('==============================User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade200),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? const SelectPage()
          : LoginPage(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("ar"),
      ],
      locale: _locale,
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../appLocalizations.dart';
import '../main.dart';
import 'login_page.dart';

class ResultDetectArWor extends StatefulWidget {
  @override
  _ResultDetectArWorState createState() => _ResultDetectArWorState();
}

class _ResultDetectArWorState extends State<ResultDetectArWor> {
  bool isLoading = false;
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isRecording = false;
  String? videoPath;
  String? predictionResult; // متغير لتخزين نتيجة الاستجابة

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      // اختيار الكاميرا الأمامية
      final frontCamera = cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);

      controller = CameraController(frontCamera, ResolutionPreset.medium);
      await controller!.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    if (controller!.value.isRecordingVideo) {
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = join(directory.path, '${DateTime.now()}.mp4');
      await controller!.startVideoRecording();
      setState(() {
        isRecording = true;
        videoPath = filePath;
      });
    } catch (e) {
      print("Error starting video recording: $e");
    }
  }

  Future<void> stopRecording() async {
    if (!controller!.value.isRecordingVideo) {
      return;
    }

    try {
      XFile videoFile = await controller!.stopVideoRecording();
      setState(() {
        isRecording = false;
        videoPath = videoFile.path;
      });

      if (videoPath != null) {
        await sendVideoToServer(videoPath!);
      }
    } catch (e) {
      print("Error stopping video recording: $e");
    }
  }

  Future<void> sendVideoToServer(String videoPath) async {
    try {
      final file = File(videoPath);
      if (!file.existsSync()) {
        throw Exception("File does not exist at path: $videoPath");
      }

      final uri = Uri.parse("http://172.20.10.2:8092/upload/");
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', videoPath));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final result = jsonDecode(responseData)['prediction'];
        setState(() {
          predictionResult = result; // تحديث متغير الحالة بالنتيجة
        });
      } else {
        setState(() {
          predictionResult =
              'Failed to upload video'; // تحديث متغير الحالة عند الفشل
        });
      }
    } catch (e) {
      print("Error sending video to server: $e");
      setState(() {
        predictionResult = 'Error sending video to server: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

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
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(controller!),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(isRecording ? Icons.stop : Icons.videocam),
                color: isRecording ? Colors.red : Colors.blue,
                onPressed: isRecording ? stopRecording : startRecording,
              ),
            ],
          ),
          if (predictionResult != null) // عرض النتيجة إذا كانت متوفرة
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Prediction: $predictionResult',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

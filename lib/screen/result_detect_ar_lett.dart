import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../appLocalizations.dart';

class ResultDetectArLett extends StatefulWidget {
  const ResultDetectArLett({super.key});

  @override
  State<ResultDetectArLett> createState() => _ResultDetectArLettState();
}

class _ResultDetectArLettState extends State<ResultDetectArLett> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool isCameraInitialized = false;
  bool isFrontCamera = false;
  bool isLoading = false;
  String? predictionResult; // To store the prediction result

  Future<void> initializeCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    controller = CameraController(
      cameras[isFrontCamera ? 1 : 0], // isFrontCamera
      ResolutionPreset.high,
    );

    await controller.initialize();

    if (!mounted) return;

    setState(() {
      isCameraInitialized = true;
    });
  }

  void toggleCamera() {
    setState(() {
      isFrontCamera = !isFrontCamera;
      initializeCamera();
    });
  }

  Future<void> captureAndSendImage() async {
    try {
      final directory = await getTemporaryDirectory();
      final imagePath = join(directory.path, '${DateTime.now()}.png');

      // Capture the image and save it to the temporary directory
      final XFile imageFile = await controller.takePicture();
      final File file = File(imageFile.path);
      final imageBytes = await file.readAsBytes();

      final response = await sendImageToServer(imageBytes);

      setState(() {
        predictionResult =
            response; // Set the prediction result to be displayed
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> sendImageToServer(List<int> imageBytes) async {
    final uri = Uri.parse('http://172.20.10.2:8001/predict/');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'image.png',
      ));

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResponse = json.decode(respStr);
      return jsonResponse['prediction'];
    } else {
      return 'Error: ${response.statusCode}';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('homePage')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: isCameraInitialized ? toggleCamera : null,
          ),
        ],
      ),
      body: isCameraInitialized
          ? Column(
              children: [
                Expanded(child: CameraPreview(controller)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: captureAndSendImage,
                    ),
                  ],
                ),
                if (predictionResult != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Result: $predictionResult',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
}

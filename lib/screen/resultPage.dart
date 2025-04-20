import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';

import '../api_service.dart';
import '../appLocalizations.dart';
import '../main.dart';
import 'login_page.dart';

class ResultPage extends StatefulWidget {
  final String txt;
  ResultPage({super.key, required this.txt});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final ApiService _apiService = ApiService();
  List<String> _videoPaths = [];
  bool _isLoading = false;
  String? _errorMessage;

  void _fetchVideoPaths() async {
    print(widget.txt);
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<String> paths = await _apiService.getVideoPaths(widget.txt);
      print(paths);
      setState(() {
        _videoPaths = paths;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchVideoPaths();
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
                  _isLoading = true;
                });
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isLoading = false;
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
      body: ListView(children: [
        Column(children: [
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
            child: Column(children: [
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
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                      child: Container(
                        width: 250,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.purple.shade100,
                        ),
                        child: Center(
                          child: Text(
                            widget.txt,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    _isLoading
                        ? Center(
                            child: LoadingAnimationWidget.flickr(
                                leftDotColor: Colors.purple.shade100,
                                rightDotColor: Colors.purple.shade300,
                                size: 60))
                        : _errorMessage != null
                            ? Text('Error: $_errorMessage')
                            : Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, left: 16.0),
                                child: Container(
                                  height: 200,
                                  child: _videoPaths.isNotEmpty
                                      ? VideoPlayerWidget(
                                          videoPaths: _videoPaths,
                                          initialIndex: 0,
                                        )
                                      : Text('No videos found'),
                                ),
                              ),
                  ],
                ),
              )
            ]),
          )
        ]),
      ]),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final List<String> videoPaths;
  final int initialIndex;

  VideoPlayerWidget({required this.videoPaths, required this.initialIndex});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late int _currentVideoIndex;

  @override
  void initState() {
    super.initState();
    _currentVideoIndex = widget.initialIndex;
    _initializeAndPlay(widget.videoPaths[_currentVideoIndex]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeAndPlay(String videoPath) {
    _controller = VideoPlayerController.asset('assets/$videoPath')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.addListener(_videoListener);
      });
  }

  void _videoListener() {
    if (_controller.value.position == _controller.value.duration) {
      _controller.removeListener(_videoListener);
      _playNextVideo();
    }
  }

  void _playNextVideo() {
    if (_currentVideoIndex < widget.videoPaths.length - 1) {
      setState(() {
        _currentVideoIndex++;
      });
      _controller.dispose();
      _initializeAndPlay(widget.videoPaths[_currentVideoIndex]);
    } else {
      print("All videos played");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

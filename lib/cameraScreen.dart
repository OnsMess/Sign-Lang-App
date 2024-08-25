import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'api_service.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  String prediction = '';
  final ApiService apiService = ApiService(); // Initialize the API service
  final FlutterTts flutterTts = FlutterTts(); // Initialize TTS
  bool isRecording = false;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
      controller = CameraController(frontCamera, ResolutionPreset.medium);
      await controller?.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    flutterTts.stop(); // Stop TTS when disposing
    super.dispose();
  }

  Future<void> captureVideo() async {
    if (controller != null && controller!.value.isInitialized) {
      try {
        setState(() {
          isRecording = true; // Start recording
        });

        await controller!.startVideoRecording();
        await Future.delayed(Duration(seconds: 3));
        final videoFile = await controller!.stopVideoRecording();

        setState(() {
          isRecording = false; // Stop recording
        });

        String result = await apiService.sendVideoFile(videoFile.path);
        setState(() {
          prediction = result;
        });
      } catch (e) {
        print('Error capturing video: $e');
        setState(() {
          isRecording = false; // Stop recording in case of error
        });
      }
    }
  }

  Future<void> _speak() async {
    if (prediction.isNotEmpty) {
      setState(() {
        isSpeaking = true;
      });

      await flutterTts.setLanguage("fr-FR");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(prediction);

      setState(() {
        isSpeaking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Capturez votre signe',
          style: TextStyle(
            color: Color.fromARGB(255, 227, 39, 220),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          if (controller != null && controller!.value.isInitialized)
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CameraPreview(controller!),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: GestureDetector(
                      onTap: isRecording
                          ? null
                          : captureVideo, // Disable button during recording
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isRecording
                                ? Color.fromARGB(255, 227, 39, 220)
                                : Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.videocam,
                            color: isRecording
                                ? Color.fromARGB(255, 227, 39,
                                    220) // Icon color when recording
                                : Colors
                                    .white, // Default icon color when not recording
                            size: 32.0, // Icon size
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 35),
          Container(
            width: MediaQuery.of(context).size.width * 0.4, // Decreased width
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey.shade200,
              border: Border.all(
                color: Color.fromARGB(255, 227, 39, 220),
                width: 2.0,
              ),
            ),
            child: Text(
              prediction.isEmpty ? 'Lire le signe' : prediction,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 35),
          GestureDetector(
            onTap: _speak,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.55,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    25.0), // Rounded corners like a voice message
                color: isSpeaking
                    ? Color.fromARGB(255, 227, 39, 220)
                    : Colors.grey.shade200,
                border: Border.all(
                  color: Color.fromARGB(255, 227, 39, 220),
                  width: 2.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.mic,
                      color: Colors.black, size: 24), // Microphone icon
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Écoutez le signe",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

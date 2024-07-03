import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:local_notification/services/local_notification_service.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  Timer? _timer;
  int _remainingSeconds = 15;
  bool _isRunning = false;

  void _startCountTime() async {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          LocalNotificationService.pomodoroNotification();
          setState(() {
            _remainingSeconds = 15;
            _isRunning = false;
          });
        }
      });
    });
  }

  void _stopCountTime() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')} : ${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Pomodoro Screen",
          style: TextStyle(
            fontFamily: 'Extrag',
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Center(
              child: Container(
                width: 150,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    _formatTime(_remainingSeconds),
                    style: const TextStyle(
                      fontFamily: "Extrag",
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(50),
          ElevatedButton(
            onPressed: () {
              if (_isRunning) {
                _stopCountTime();
              } else {
                _startCountTime();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 10,
              ),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              _isRunning ? "Stop" : "Start",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

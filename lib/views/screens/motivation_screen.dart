import 'package:flutter/material.dart';
import 'package:local_notification/controllers/motivation_controller.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final MotivationController motivationController = MotivationController();
  late Future<Map<String, String>> _quoteFuture;

  @override
  void initState() {
    super.initState();
    _quoteFuture = motivationController.getRandomMotivation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Motivation Screen",
          style: TextStyle(
            fontFamily: 'Extrag',
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<Map<String, String>>(
          future: _quoteFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              return Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      snapshot.data!['text']!,
                      style: const TextStyle(
                        fontFamily: 'Extrag',
                        fontSize: 17,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 150),
                      child: Text(
                        '- ${snapshot.data!['author']}',
                        style: const TextStyle(
                          fontFamily: 'Extrag',
                          fontSize: 16,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }
}

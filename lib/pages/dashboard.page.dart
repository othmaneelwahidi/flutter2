import 'package:flutter/material.dart';

import 'deep.page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ChatBot App",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigation vers la page DeepSeek
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeepSeekPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 66, 60), // Couleur d'arrière-plan
            foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Couleur du texte
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: const Text(
            "Ask AI",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const FitFlowApp());
}

class FitFlowApp extends StatelessWidget {
  const FitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const FitFlowHomePage(),
    );
  }
}

class FitFlowHomePage extends StatelessWidget {
  const FitFlowHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FitFlow Redesign')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Flutter starter placeholder for the FitFlow client.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

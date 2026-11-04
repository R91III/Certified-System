import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';
import 'repositories/auth_repository_impl.dart';
import 'views/auth/login_page.dart';

void main() {
  final repository = AuthRepositoryImpl();
  runApp(CertifiedSystemApp(controller: AuthController(repository)));
}

class CertifiedSystemApp extends StatelessWidget {
  const CertifiedSystemApp({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF173B3F);
    return MaterialApp(
      title: 'بوابة الطالب',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ink,
          primary: ink,
          secondary: const Color(0xFFC76845),
          surface: const Color(0xFFF9F8F3),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F8F3),
        fontFamily: 'NotoNaskhArabic',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD8DFD9)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD8DFD9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ink, width: 1.5),
          ),
        ),
      ),
      home: LoginPage(controller: controller),
    );
  }
}

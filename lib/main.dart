import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apple Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;

      if (idToken == null) {
        throw Exception("ID Token is null");
      }

      // ✅ API 요청
      final response = await http.post(
        Uri.parse('https://dev-api.cherry-pick.today/auth/social-login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'oauthProvider': 'APPLE',
          'idToken': idToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('로그인 성공: ${response.statusCode}');
      } else {
        debugPrint('로그인 실패: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      debugPrint('Apple 로그인 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apple Login"),
      ),
      body: Center(
        child: SignInWithAppleButton(
          onPressed: signInWithApple,
        ),
      ),
    );
  }
}

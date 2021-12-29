import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/constants.dart';
import 'package:warehouse/data/secure_storage.dart';
import 'package:warehouse/data/shared_preferences.dart';
import 'package:warehouse/globals.dart';
import 'package:warehouse/model/user.dart';
import 'package:warehouse/pages/auth/login_page.dart';
import 'package:http/http.dart' as http;

import 'home_page.dart';

Future<User?> _future() async {
  //await Future.delayed(const Duration(seconds: 2));

  await SharedPreferences.init();
  SecureStorage.init();
  final token = await SecureStorage.instance.prefs.read(
    key: "access_token",
    aOptions: secureStorageAndroidOptions,
  );
  if (token == null) return null;
  if (token.isEmpty) return null;

  final headers = {
    'Authorization': 'Bearer $token',
    'Cookie': 'access_token=$token'
  };

  final request = http.get(
    Uri.parse(domainUrl + "/api/auth/profile"),
    headers: headers,
  );

  Map<String, dynamic>? json;
  bool error = false;

  try {
    final response = await request;
    json = jsonDecode(response.body);
  } on Exception catch (e) {
    debugPrint(e.toString());
    error = true;
  }
  if (error || json!["data"] == null) return null;

  accessToken = token;

  return User.fromJson(json["data"]);
}

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  late Future<User?> future;

  @override
  void initState() {
    super.initState();
    future = _future();

    future.then((value) {
      Widget page;
      if (value == null) {
        page = const LoginPage();
      } else {
        page = Provider.value(
          value: value,
          child: const HomePage(),
        );
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

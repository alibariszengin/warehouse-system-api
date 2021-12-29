import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:warehouse/constants.dart';
import 'package:warehouse/data/secure_storage.dart';
import 'package:warehouse/data/shared_preferences.dart';
import 'package:warehouse/globals.dart';
import 'package:warehouse/model/user.dart';
import 'package:warehouse/pages/auth/forgot_password_page.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/pages/auth/register_page.dart';
import 'package:warehouse/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final isObscure = ValueNotifier(true);
  final formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: Column(
                  children: [
                    _buildMailField(),
                    _buildPasswordField(),
                  ],
                ),
              ),
              _buildForgotPasswordText(),
              _buildLoginButton(),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      final future = http.post(
        Uri.parse(domainUrl + "/api/auth/login"),
        body: jsonEncode({
          "email": mailController.text,
          "password": passwordController.text,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      Map<String, dynamic>? json;
      try {
        final response = await future;
        json = jsonDecode(response.body);
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
      if (json == null) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            checkConnectionSnackbar,
          );
        });
        return;
      }
      if (json["success"]!) {
        await SharedPreferences.instance.prefs.setString(
          "name",
          json["data"]["name"],
        );
        await SharedPreferences.instance.prefs.setString(
          "email",
          json["data"]["email"],
        );
        await SharedPreferences.instance.prefs.setString(
          "id",
          json["data"]["id"],
        );
        await SecureStorage.instance.prefs.write(
          key: "access_token",
          value: json["access_token"],
        );
        await goToHomePage(json["access_token"]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              json["message"],
            ),
          ),
        );
      }
    }
  }

  void register() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  Widget _buildMailField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        controller: mailController,
        validator: (value) {
          if (value == null) return null;
          if (!value.isEmail()) {
            return "Your mail is not valid!";
          }
        },
        decoration: const InputDecoration(
          labelText: "Mail",
          hintText: "Type your email",
          prefixIcon: Icon(
            Icons.account_circle_outlined,
            size: 32,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ValueListenableBuilder<bool>(
          valueListenable: isObscure,
          builder: (context, value, child) {
            return TextFormField(
              controller: passwordController,
              obscureText: isObscure.value,
              validator: (value) {
                if (value == null) return null;
                if (value.isEmpty) return "Password cannot be empty!";
              },
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Type your password",
                suffixIcon: GestureDetector(
                  onTap: () => isObscure.value = !isObscure.value,
                  child: Icon(
                    value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  size: 32,
                  color: Colors.grey,
                ),
              ),
            );
          }),
    );
  }

  Widget _buildForgotPasswordText() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ForgotPasswordPage(),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(15),
            child: Text("Forgot password?"),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.cyanAccent,
              Colors.pinkAccent,
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: login,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            minimumSize: MaterialStateProperty.all(
              const Size.fromHeight(50),
            ),
          ),
          child: const Center(
            child: Text(
              "LOGIN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ElevatedButton(
        onPressed: register,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          minimumSize: MaterialStateProperty.all(
            const Size.fromHeight(50),
          ),
        ),
        child: const Center(
          child: Text(
            "REGISTER",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future goToHomePage(String token) async {
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
    if (error) return;

    accessToken = token;

    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => Provider<User>(
          create: (context) => User.fromJson(json!["data"]),
          child: const HomePage(),
        ),
      ),
      (route) => false,
    );
  }
}

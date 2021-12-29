import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;

  const ResetPasswordPage({required this.token, Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController passController;
  late TextEditingController passController2;
  late bool formEnabled;

  late GlobalKey<FormState> formKey;
  @override
  void initState() {
    super.initState();
    passController = TextEditingController();
    passController2 = TextEditingController();
    formKey = GlobalKey<FormState>();
    formEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Type new password",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  "Dont forget this time ;)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildPasswordField(),
              _buildPasswordFieldAgain(),
              _buildOkButton()
            ],
          ),
        ),
      ),
    );
  }

  void ok() async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic>? json;
      setState(() {
        formEnabled = false;
      });
      try {
        final response = await http.put(
          Uri.parse(domainUrl +
              "/api/auth/resetpassword?resetPasswordToken=${widget.token}"),
          body: jsonEncode({
            "password": passController.text,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
        json = jsonDecode(response.body);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(checkConnectionSnackbar);
        setState(() {
          formEnabled = true;
        });
      }
      if (json == null) return;
      if (json["success"] == null) return;
      if (json["success"]) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login with new password"),
          ),
        );
      }
    }
  }

  Widget _buildOkButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: formEnabled
                ? [
                    Colors.cyanAccent,
                    Colors.pinkAccent,
                  ]
                : [
                    Colors.grey,
                    Colors.grey,
                  ],
          ),
        ),
        child: ElevatedButton(
          onPressed: ok,
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
              "OK",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordFieldAgain() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        enabled: formEnabled,
        controller: passController2,
        validator: (value) =>
            passController.text == value ? null : "Password doesnt match!",
        decoration: const InputDecoration(
          hintText: "And again",
          prefixIcon: Icon(
            Icons.lock_outline,
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
      child: TextFormField(
        enabled: formEnabled,
        controller: passController,
        validator: (value) {
          if (value == null) return null;
          if (value.isEmpty) return "Password cannot be empty!";
        },
        decoration: const InputDecoration(
          hintText: "Type your pass plz",
          prefixIcon: Icon(
            Icons.lock_outline,
            size: 32,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

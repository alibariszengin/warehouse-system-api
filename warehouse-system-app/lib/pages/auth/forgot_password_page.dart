import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController mailController;

  late bool formEnabled;

  late bool success;
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    mailController = TextEditingController();
    formEnabled = true;
    success = false;
  }

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
                  "I forgot my pass :(",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: Column(
                  children: [
                    _buildMailField(),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              success
                  ? const Text("Your mail has been sent!")
                  : const SizedBox(),
              _buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  void send() async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic>? json;
      setState(() {
        formEnabled = false;
      });
      try {
        final response = await http.post(
          Uri.parse(domainUrl + "/api/auth/forgotpassword"),
          body: jsonEncode({
            "email": mailController.text,
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
        setState(() {
          success = true;
        });
      }
    }
  }

  Widget _buildMailField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        enabled: formEnabled,
        controller: mailController,
        validator: (value) {
          if (value == null) return null;
          if (!value.isEmail()) return "Your mail is not valid!";
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

  Widget _buildSendButton() {
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
          onPressed: formEnabled ? send : null,
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
              "SEND RESET LINK",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

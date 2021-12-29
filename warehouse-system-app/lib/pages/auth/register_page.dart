import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late GlobalKey<FormState> formKey;
  late ValueNotifier<bool> isObscure;
  late TextEditingController nameController;
  late TextEditingController mailController;
  late TextEditingController passwordController;
  late bool formEnabled;
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    isObscure = ValueNotifier(false);
    nameController = TextEditingController();
    mailController = TextEditingController();
    passwordController = TextEditingController();
    formEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  _buildNameField(),
                  _buildMailField(),
                  _buildPasswordField(),
                ],
              ),
            ),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic>? json;
      setState(() {
        formEnabled = false;
      });
      try {
        final response = await http.put(
          Uri.parse(domainUrl + "/api/auth/register"),
          body: jsonEncode({
            "name": nameController.text,
            "email": mailController.text,
            "password": passwordController.text,
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
            content: Text("Successfully registered"),
          ),
        );
      }
    }
  }

  Widget _buildRegisterButton() {
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
          onPressed: formEnabled ? register : null,
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
              "REGISTER",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value == null) return null;
          if (value.isEmpty) return "Name cannot be empty!";
        },
        decoration: const InputDecoration(
          labelText: "Name",
          hintText: "Type your name",
          prefixIcon: Icon(
            Icons.account_circle_outlined,
            size: 32,
            color: Colors.grey,
          ),
        ),
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
}

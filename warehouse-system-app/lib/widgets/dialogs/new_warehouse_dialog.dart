import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/constants.dart';
import 'package:warehouse/globals.dart';

class NewWarehouseDialog extends StatefulWidget {
  const NewWarehouseDialog({Key? key}) : super(key: key);

  @override
  State<NewWarehouseDialog> createState() => _NewWarehouseDialogState();
}

class _NewWarehouseDialogState extends State<NewWarehouseDialog> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _titleController;
  late GlobalKey<FormState> _formkey;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _titleController = TextEditingController();
    _formkey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "New warehouse",
                style: TextStyle(fontSize: 24),
              ),
              _buildTextFormField("Name", _nameController),
              _buildTextFormField("Address", _addressController),
              _buildTextFormField("Title", _titleController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        final future = _future(
                          _nameController.text,
                          _addressController.text,
                          _titleController.text,
                        );
                        Navigator.pop(context, future);
                      }
                    },
                    child: const Text("Add"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: Navigator.of(context).pop,
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
        ),
        controller: controller,
        validator: (value) => value!.isEmpty ? "Cannot be empty!" : null,
      ),
    );
  }
}

Future<Map<String, dynamic>?> _future(
  String text,
  String text2,
  String text3,
) async {
  Map<String, dynamic>? json;
  try {
    final response = await http.post(Uri.parse(domainUrl + "/api/warehouses"),
        body: jsonEncode({
          "name": text,
          "address": text2,
          "title": text3,
        }),
        headers: {
          "Authorization": "Bearer $accessToken",
          'Content-Type': 'application/json',
        });
    json = jsonDecode(response.body);
  } on Exception {
    return null;
  }
  if (json == null) return null;
  if (json["success"] == null) return null;
  return json;
}

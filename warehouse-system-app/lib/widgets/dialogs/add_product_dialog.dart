import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/constants.dart';
import 'package:warehouse/globals.dart';
import 'package:warehouse/model/warehouse.dart';
import 'package:regexpattern/regexpattern.dart';

class AddProductDialog extends StatefulWidget {
  final Warehouse warehouse;
  const AddProductDialog({Key? key, required this.warehouse}) : super(key: key);

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late GlobalKey<FormState> _formkey;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
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
                "Add Product",
                style: TextStyle(fontSize: 24),
              ),
              _buildTextFormField(
                "Name",
                _nameController,
                (value) => value!.isEmpty ? "Cannot be empty!" : null,
              ),
              _buildTextFormField(
                "Address",
                _amountController,
                (value) {
                  if (value!.isEmpty) return "Cannot be empty!";
                  if (!value.isNumeric()) return "Should be numeric";
                  return null;
                },
              ),
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
                          _amountController.text,
                          widget.warehouse.id,
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

  Padding _buildTextFormField(
    String label,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
        ),
        controller: controller,
        validator: validator,
      ),
    );
  }
}

Future<Map<String, dynamic>?> _future(
  String name,
  String amount,
  String warehouseId,
) async {
  Map<String, dynamic>? json;
  try {
    final response =
        await http.post(Uri.parse(domainUrl + "/api/products/$warehouseId"),
            body: jsonEncode({
              "products": [
                {
                  "name": name,
                  "amount": int.parse(amount),
                }
              ],
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

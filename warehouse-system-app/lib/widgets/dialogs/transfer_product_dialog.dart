import 'package:flutter/material.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:warehouse/model/product.dart';

class TransferProductDialog extends StatefulWidget {
  final Product product;

  const TransferProductDialog({Key? key, required this.product})
      : super(key: key);

  @override
  State<TransferProductDialog> createState() => _TransferProductDialogState();
}

class _TransferProductDialogState extends State<TransferProductDialog> {
  late TextEditingController _amountController;
  late GlobalKey<FormState> _formkey;
  @override
  void initState() {
    super.initState();
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
                "Type amount",
                style: TextStyle(fontSize: 24),
              ),
              _buildTextFormField("Amount", _amountController),
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
                      if (!_formkey.currentState!.validate()) return;
                      Navigator.pop(context, int.parse(_amountController.text));
                    },
                    child: const Text("Transfer"),
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
        validator: (value) {
          if (value!.isEmpty) return "Cannot be empty!";

          if (!value.isNumeric()) return "Should be numeric!";

          if (int.parse(_amountController.text) > widget.product.stock) {
            return "You don't have that much!";
          }
          return null;
        },
      ),
    );
  }
}

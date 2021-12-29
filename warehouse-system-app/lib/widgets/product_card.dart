import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/logic/cubits/products_cubit.dart';
import 'package:warehouse/model/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/model/warehouse.dart';
import 'package:warehouse/pages/warehouses_page/search_for_transfer_page.dart';
import 'package:warehouse/widgets/dialogs/transfer_product_dialog.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../globals.dart';
import 'dialogs/yes_no_dialog.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => showDialog(
              context: context,
              builder: (_) {
                return YesNoDialog(
                  yes: () {
                    context.read<ProductsCubit>().deleteProduct(product);
                    Navigator.of(context).pop();
                  },
                  no: Navigator.of(context).pop,
                );
              },
            ),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (_) async {
              final amount = await showDialog<int>(
                context: context,
                builder: (_) {
                  return TransferProductDialog(product: product);
                },
              );
              if (amount == null) return;
              final warehouse = await Navigator.push<Warehouse>(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchForTrasferPage(
                    amount: amount,
                  ),
                ),
              );
              if (warehouse == null) return;
              _future(
                product.warehouse,
                warehouse.id,
                product,
                amount,
              ).then((value) {
                if (value == null) return;
                if (value["success"] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value["message"],
                      ),
                    ),
                  );
                }
              });
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.emoji_transportation,
            label: 'Transfer',
          ),
        ],
      ),
      child: Card(
        child: ListTile(
          leading: const Icon(
            Icons.shopping_cart,
            size: 48,
          ),
          title: Text(
            product.name,
          ),
          subtitle: Text(
            "Reserved: ${product.reserved}",
          ),
          trailing: Text(
            "Stock: ${product.stock}",
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> _future(
  String from,
  String to,
  Product product,
  int amount,
) async {
  Map<String, dynamic>? json;
  try {
    final response = await http.post(
      Uri.parse(domainUrl + "/api/products/$from/$to"),
      body: jsonEncode({
        "product_id": product.id,
        "amount": amount,
      }),
      headers: {
        "Authorization": "Bearer $accessToken",
        'Content-Type': 'application/json',
      },
    );
    json = jsonDecode(response.body);
  } on Exception {
    return null;
  }
  if (json == null) return null;
  if (json["success"] == null) return null;
  return json;
}

import 'package:flutter/material.dart';
import 'package:warehouse/logic/cubits/products_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/model/product.dart';
import 'package:warehouse/model/warehouse.dart';
import 'package:warehouse/widgets/dialogs/add_product_dialog.dart';
import 'package:warehouse/widgets/product_card.dart';

import '../../constants.dart';

class ProdutsPage extends StatefulWidget {
  final Warehouse warehouse;
  const ProdutsPage(this.warehouse, {Key? key}) : super(key: key);

  @override
  State<ProdutsPage> createState() => _ProdutsPageState();
}

class _ProdutsPageState extends State<ProdutsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().getProducts(widget.warehouse.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final cubit = context.watch<ProductsCubit>();
          final state = cubit.state;

          if (state is ProductsError) {
            WidgetsBinding.instance!.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                checkConnectionSnackbar,
              ),
            );
            return Center(
              child: ElevatedButton(
                onPressed: () => cubit.getProducts(widget.warehouse.id),
                child: const Text("Refresh"),
              ),
            );
          }
          if (state is ProductsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (state is ProductsLoaded) {
            return RefreshIndicator(
              onRefresh: () => cubit.getProducts(widget.warehouse.id),
              child: ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) => ProductCard(
                  product: state.products[index],
                ),
              ),
            );
          }
          if (state is ProductsNotSuccess) {
            WidgetsBinding.instance!.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                notSuccessSnackbar,
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          final cubit = context.watch<ProductsCubit>();
          if (cubit.state is ProductsLoaded) {
            return FloatingActionButton(
              onPressed: () async {
                Future<Map<String, dynamic>?>? future =
                    await showDialog<Future<Map<String, dynamic>?>>(
                  context: context,
                  builder: (_) => AddProductDialog(
                    warehouse: widget.warehouse,
                  ),
                );

                future?.then((value) {
                  try {
                    if (value!["success"]) {
                      context.read<ProductsCubit>().addProduct(
                            Product.fromJson(
                              value["data"],
                            ),
                          );
                    }
                  } on Exception {}
                });
              },
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

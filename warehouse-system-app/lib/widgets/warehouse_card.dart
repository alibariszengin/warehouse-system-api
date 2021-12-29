import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/logic/cubits/products_cubit.dart';
import 'package:warehouse/logic/cubits/warehouses_cubit.dart';
import 'package:warehouse/model/warehouse.dart';
import 'package:warehouse/pages/warehouses_page/products_page.dart';
import 'package:warehouse/widgets/dialogs/yes_no_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseCard extends StatelessWidget {
  final bool slidable;
  final Warehouse warehouse;
  const WarehouseCard(
      {required this.warehouse, Key? key, required this.slidable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      closeOnScroll: true,
      endActionPane: slidable
          ? ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => showDialog(
                    context: context,
                    builder: (_) {
                      return YesNoDialog(
                        yes: () {
                          context
                              .read<WarehousesCubit>()
                              .deleteWarehouse(warehouse);
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
              ],
            )
          : null,
      child: InkWell(
        onTap: slidable
            ? () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<ProductsCubit>(
                      create: (context) => ProductsCubit(),
                      child: ProdutsPage(warehouse),
                    ),
                  ),
                )
            : null,
        child: Card(
          child: ListTile(
            leading: const Icon(
              Icons.account_balance_outlined,
              size: 48,
            ),
            title: Text(
              warehouse.title,
            ),
            subtitle: Text(
              warehouse.address,
            ),
            trailing: Text(
              warehouse.name,
            ),
          ),
        ),
      ),
    );
  }
}

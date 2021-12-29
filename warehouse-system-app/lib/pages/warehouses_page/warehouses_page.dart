import 'package:flutter/material.dart';
import 'package:warehouse/constants.dart';

import 'package:warehouse/logic/cubits/warehouses_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/widgets/warehouse_card.dart';

class WarehousesPage extends StatefulWidget {
  const WarehousesPage({Key? key}) : super(key: key);

  @override
  State<WarehousesPage> createState() => _WarehousesPageState();
}

class _WarehousesPageState extends State<WarehousesPage> {
  @override
  void initState() {
    super.initState();
    context.read<WarehousesCubit>().getWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final cubit = context.watch<WarehousesCubit>();
        final state = cubit.state;

        if (state is WarehousesError) {
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              checkConnectionSnackbar,
            ),
          );
          return Center(
            child: ElevatedButton(
              onPressed: cubit.getWarehouses,
              child: const Text("Refresh"),
            ),
          );
        }
        if (state is WarehousesLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        if (state is WarehousesLoaded) {
          return RefreshIndicator(
            onRefresh: cubit.getWarehouses,
            child: ListView.builder(
              itemCount: state.warehouses.length,
              itemBuilder: (context, index) => WarehouseCard(
                slidable: true,
                warehouse: state.warehouses[index],
              ),
            ),
          );
        }
        if (state is WarehousesNotSuccess) {
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              notSuccessSnackbar,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:warehouse/logic/cubits/search_function_cubit.dart';
import 'package:warehouse/logic/cubits/search_warehouses_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/widgets/warehouse_card.dart';

import '../constants.dart';

class SearchPage extends StatefulWidget {
  final bool forTransfer;

  const SearchPage({required this.forTransfer, Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller;
  late GlobalKey<FormState> formKey;
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocListener<SearchFunctionCubit, bool>(
          listener: (context, state) {
            if (!state && formKey.currentState!.validate()) {
              context.read<SearchWarehousesCubit>().search(_controller.text);
            } else {
              context.read<SearchFunctionCubit>().searching(false);
            }
          },
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                validator: (value) => value?.isEmpty ?? false
                    ? "Keyword can not be empty!"
                    : null,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Search",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              final cubit = context.watch<SearchWarehousesCubit>();
              final state = cubit.state;
              if (state is SearchWarehousesError) {
                WidgetsBinding.instance!.addPostFrameCallback(
                  (_) => ScaffoldMessenger.of(context).showSnackBar(
                    checkConnectionSnackbar,
                  ),
                );
                return const SizedBox();
              }
              if (state is SearchWarehousesLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              context.read<SearchFunctionCubit>().searching(false);
              if (state is SearchWarehousesLoaded) {
                return ListView.builder(
                  itemCount: state.warehouses.length,
                  itemBuilder: (_, index) => widget.forTransfer
                      ? InkWell(
                          onTap: () => Navigator.pop(
                            Scaffold.of(context).context,
                            state.warehouses[index],
                          ),
                          child: WarehouseCard(
                            slidable: false,
                            warehouse: state.warehouses[index],
                          ),
                        )
                      : WarehouseCard(
                          slidable: false,
                          warehouse: state.warehouses[index],
                        ),
                );
              }
              if (state is SearchWarehousesNotSuccess) {
                WidgetsBinding.instance!.addPostFrameCallback(
                  (_) => ScaffoldMessenger.of(context).showSnackBar(
                    notSuccessSnackbar,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        )
      ],
    );
  }
}

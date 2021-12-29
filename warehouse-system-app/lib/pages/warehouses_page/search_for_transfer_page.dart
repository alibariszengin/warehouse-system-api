import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/logic/cubits/search_function_cubit.dart';
import 'package:warehouse/logic/cubits/search_warehouses_cubit.dart';
import 'package:warehouse/pages/search_page.dart';

class SearchForTrasferPage extends StatelessWidget {
  final int amount;
  const SearchForTrasferPage({Key? key, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchFunctionCubit>(
          create: (context) => SearchFunctionCubit(),
        ),
        BlocProvider<SearchWarehousesCubit>(
          create: (context) => SearchWarehousesCubit(),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: const SearchPage(
            forTransfer: true,
          ),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () {
                  final cubit = context.read<SearchFunctionCubit>();
                  if (!cubit.state) {
                    cubit.searching(true);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

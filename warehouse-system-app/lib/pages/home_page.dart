import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/logic/cubits/search_function_cubit.dart';
import 'package:warehouse/logic/cubits/search_warehouses_cubit.dart';
import 'package:warehouse/logic/cubits/warehouses_cubit.dart';
import 'package:warehouse/pages/search_page.dart';
import 'package:warehouse/pages/settings_page.dart';
import 'package:warehouse/widgets/dialogs/new_warehouse_dialog.dart';

import '../constants.dart';
import 'warehouses_page/warehouses_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    _controller.addListener(() => setState(() {}));
    _pages = const [
      WarehousesPage(),
      SearchPage(forTransfer: false),
      AccountPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WarehousesCubit>(
          create: (context) => WarehousesCubit(),
        ),
        BlocProvider<SearchWarehousesCubit>(
          create: (context) => SearchWarehousesCubit(),
        ),
        BlocProvider<SearchFunctionCubit>(
          create: (context) => SearchFunctionCubit(),
        ),
      ],
      child: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Warehouse System"),
            ),
            backgroundColor: Colors.blue,
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              index: _controller.index,
              onTap: _controller.animateTo,
              items: const [
                Icon(Icons.account_balance),
                Icon(Icons.search),
                Icon(Icons.account_circle),
              ],
            ),
            body: TabBarView(
              controller: _controller,
              children: _pages,
            ),
            floatingActionButton: Builder(
              builder: (context) {
                final warehousesCubit = context.read<WarehousesCubit>();
                if (_controller.index == 0 &&
                    warehousesCubit.state is WarehousesLoaded) {
                  return FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      showDialog<Future<Map<String, dynamic>?>>(
                        context: context,
                        builder: (_) => const NewWarehouseDialog(),
                      ).then((value) {
                        value?.then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            value == null
                                ? checkConnectionSnackbar
                                : SnackBar(
                                    content: Text(value["message"]),
                                  ),
                          );
                        });
                      });
                    },
                  );
                }
                if (_controller.index == 1) {
                  return FloatingActionButton(
                    child: const Icon(Icons.search),
                    onPressed: () {
                      final cubit = context.read<SearchFunctionCubit>();
                      if (!cubit.state) {
                        cubit.searching(true);
                      }
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}

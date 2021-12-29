import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/model/warehouse.dart';

import '../../constants.dart';
import '../../globals.dart';

class WarehousesCubit extends Cubit<WarehousesState> {
  List<Warehouse>? warehouses;
  WarehousesCubit() : super(WarehousesInitial());

  Future getWarehouses() async {
    Map<String, dynamic>? json;
    try {
      final response = await http.get(
        Uri.parse(domainUrl + "/api/warehouses"),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      json = jsonDecode(response.body);
    } on Exception {
      return emit(WarehousesError());
    }
    if (json == null) {
      return emit(WarehousesError());
    }
    if (json["data"] == null) {
      return emit(WarehousesError());
    }
    warehouses =
        List.from(json["data"]).map((e) => Warehouse.fromJson(e)).toList();
    return emit(WarehousesLoaded(warehouses!));
  }

  void deleteWarehouse(Warehouse warehouse) async {
    Map<String, dynamic>? json;
    emit(WarehousesLoading());
    try {
      final response = await http.delete(
        Uri.parse(
          domainUrl + "/api/warehouses/${warehouse.id}",
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      json = jsonDecode(response.body);
    } on Exception {
      return emit(WarehousesError());
    }

    if (json == null) {
      return emit(WarehousesError());
    }
    if (json["success"] == null) {
      return emit(WarehousesError());
    }

    if (json["success"]) {
      warehouses!.remove(warehouse);
      return emit(WarehousesLoaded(warehouses!));
    }
    return emit(WarehousesNotSuccess());
  }
}

abstract class WarehousesState {}

class WarehousesInitial extends WarehousesState {}

class WarehousesError extends WarehousesState {}

class WarehousesNotSuccess extends WarehousesState {}

class WarehousesLoading extends WarehousesState {}

class WarehousesLoaded extends WarehousesState {
  final List<Warehouse> warehouses;

  WarehousesLoaded(this.warehouses);
}

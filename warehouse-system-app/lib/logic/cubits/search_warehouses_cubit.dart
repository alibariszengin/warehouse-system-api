import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/constants.dart';
import 'package:warehouse/model/warehouse.dart';

class SearchWarehousesCubit extends Cubit<SearchWarehousesState> {
  SearchWarehousesCubit() : super(SearchWarehousesInitial());

  void search(String keyword) async {
    Map<String, dynamic>? json;
    try {
      emit(SearchWarehousesLoading());
      final response = await http.post(
        Uri.parse(domainUrl + "/api/warehouses/search"),
        body: jsonEncode(
          {
            "search": keyword,
          },
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      json = jsonDecode(response.body);
    } on Exception {
      return emit(SearchWarehousesError());
    }

    if (json == null) {
      return emit(SearchWarehousesError());
    }

    if (json["success"] == null) {
      return emit(SearchWarehousesError());
    }

    if (json["success"]) {
      return emit(SearchWarehousesLoaded(
          List.from(json["data"]).map((e) => Warehouse.fromJson(e)).toList()));
    }
    return emit(SearchWarehousesNotSuccess());
  }
}

abstract class SearchWarehousesState {}

class SearchWarehousesInitial extends SearchWarehousesState {}

class SearchWarehousesError extends SearchWarehousesState {}

class SearchWarehousesNotSuccess extends SearchWarehousesState {}

class SearchWarehousesLoading extends SearchWarehousesState {}

class SearchWarehousesLoaded extends SearchWarehousesState {
  final List<Warehouse> warehouses;

  SearchWarehousesLoaded(this.warehouses);
}

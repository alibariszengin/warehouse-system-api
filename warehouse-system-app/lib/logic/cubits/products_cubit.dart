import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/model/product.dart';

import '../../constants.dart';
import '../../globals.dart';

class ProductsCubit extends Cubit<ProductState> {
  List<Product>? products;
  ProductsCubit() : super(ProductsInitial());

  Future getProducts(String warehouseId) async {
    Map<String, dynamic>? json;
    try {
      final response = await http.get(
        Uri.parse(domainUrl + "/api/products/$warehouseId"),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      json = jsonDecode(response.body);
    } on Exception {
      return emit(ProductsError());
    }
    if (json == null) {
      return emit(ProductsError());
    }
    if (json["data"] == null) {
      return emit(ProductsError());
    }
    products = List.from(json["data"]).map((e) => Product.fromJson(e)).toList();
    return emit(ProductsLoaded(products!));
  }

  void deleteProduct(Product product) {}

  void addProduct(Product product) {
    final result =
        products!.where((element) => element.id == product.id).toList();
    if (result.isEmpty) {
      products!.add(product);
      return emit(ProductsLoaded(products!));
    }
    products!.remove(result.first);
    products!.add(product);
    return emit(ProductsLoaded(products!));
  }
}

abstract class ProductState {}

class ProductsInitial extends ProductState {}

class ProductsError extends ProductState {}

class ProductsNotSuccess extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  ProductsLoaded(this.products);
}

// {
//             "reserved": 0,
//             "_id": "61c9f7f4819f040004ab6372",
//             "name": "karam",
//             "stock": 24,
//             "createdAt": "2021-12-27T17:29:24.999Z",
//             "__v": 0,
//             "warehouse": "61b7cad0869cb513e89675d3"
//         }

class Product {
  final String id;
  final int reserved;
  final String name;
  final int stock;
  final String warehouse;

  Product({
    required this.id,
    required this.reserved,
    required this.name,
    required this.stock,
    required this.warehouse,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        reserved: json["reserved"],
        name: json["name"],
        stock: json["stock"],
        warehouse: json["warehouse"],
      );
}

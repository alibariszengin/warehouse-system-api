// "products": [
//                 "61c9f7f4819f040004ab6372"
//             ],
//             "_id": "61b7cad0869cb513e89675d3",
//             "name": "first",
//             "address": "davutpasa YTU",
//             "title": "sekerci fabrikasi2",
//             "createdAt": "2021-12-13T22:36:00.032Z",
//             "__v": 1,
//             "user": "61b7bc25c1ef290a2c8a3a1a"

class Warehouse {
  final List<String> products;
  final String name;
  final String address;
  final String title;
  final String id;

  const Warehouse({
    required this.products,
    required this.name,
    required this.address,
    required this.title,
    required this.id,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        products: List.from(json["products"]),
        name: json["name"],
        address: json["address"],
        title: json["title"],
        id: json["_id"],
      );
}

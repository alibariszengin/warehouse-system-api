// {
//     "from": {
//         "user": "61b7bc25c1ef290a2c8a3a1a"
//     },
//     "status": "waiting",
//     "_id": "61cb06ad59f1ad0004335054",
//     "warehouseInfo": {
//         "name": "eh",
//         "address": "ej",
//         "title": "sj"
//     },
//     "type": "create",
//     "product": [],
//     "updatedAt": "2021-12-28T12:44:29.670Z",
//     "__v": 0
// },
// {
//     "from": {
//         "warehouse": "61b7cad0869cb513e89675d3",
//         "user": "61b7bc25c1ef290a2c8a3a1a"
//     },
//     "to": {
//         "warehouse": "61b7cbd23405a5039cd25c4f",
//         "user": "61b7bc25c1ef290a2c8a3a1a"
//     },
//     "status": "waiting",
//     "_id": "61cb43ccff85e100042361dd",
//     "type": "transport",
//     "product": [],
//     "updatedAt": "2021-12-28T17:05:16.234Z",
//     "__v": 0
// },

abstract class Request {
  final Map<String, String> from;
  final String status;
  final String id;
  final DateTime date;
  const Request({
    required this.from,
    required this.status,
    required this.id,
    required this.date,
  });
  factory Request.fromJson(Map<String, dynamic> json) =>
      json["type"] == "create"
          ? CreateRequest.fromJson(json)
          : TransportRequest.fromJson(json);
}

class CreateRequest extends Request {
  final Map<String, String> warehouseInfo;
  CreateRequest({
    required this.warehouseInfo,
    required Map<String, String> from,
    required String status,
    required String id,
    required DateTime date,
  }) : super(
          date: date,
          from: from,
          id: id,
          status: status,
        );
  factory CreateRequest.fromJson(Map<String, dynamic> json) => CreateRequest(
        from: Map.from(json["from"]),
        id: json["_id"],
        status: json["status"],
        date: DateTime.parse(json["updatedAt"]),
        warehouseInfo: Map.from(json["warehouseInfo"]),
      );
}

class TransportRequest extends Request {
  final Map<String, String> to;
  final List<Map<String, dynamic>> products;
  factory TransportRequest.fromJson(Map<String, dynamic> json) =>
      TransportRequest(
        products: List.from(json["product"]),
        to: Map.from(json["to"]),
        from: Map.from(json["from"]),
        id: json["_id"],
        status: json["status"],
        date: DateTime.parse(json["updatedAt"]),
      );

  const TransportRequest({
    required this.products,
    required this.to,
    required Map<String, String> from,
    required String status,
    required String id,
    required DateTime date,
  }) : super(
          date: date,
          from: from,
          id: id,
          status: status,
        );
}

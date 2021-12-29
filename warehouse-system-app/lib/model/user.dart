// "warehouses": [],
//         "role": "user",
//         "requests": [],
//         "profile_image": "default.jpg",
//         "blocked": false,
//         "_id": "61c90e46e2d9ed0004dd0b84",
//         "name": "beynim yok",
//         "email": "beyinfakiri16@gmail.com",
//         "createdAt": "2021-12-27T00:52:22.712Z",
//         "__v": 0,
//         "resetPasswordExpire": "2021-12-27T01:53:32.351Z",
//         "resetPasswordToken": "49c2149581956af086fa93c5e44699ad76a02d1c26f1d68fcc863b93050630b1"

import 'request.dart';

class User {
  final List<String> warehouses;
  final String role;

  //final List<Request> requests;

  final String profileImage;

  final bool blocked;

  final String id;

  final String name;

  final String email;

  final String resetPasswordToken;

  User({
    required this.warehouses,
    required this.role,
    //required this.requests,
    required this.profileImage,
    required this.blocked,
    required this.id,
    required this.name,
    required this.email,
    required this.resetPasswordToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        warehouses: List.from(json["warehouses"]),
        role: json["role"],
        // TODO:
        // requests: (json["requests"] as List)
        //     .map(
        //       (e) => Request.fromJson(e),
        //     )
        //     .toList(),
        profileImage: json["profile_image"],
        blocked: json["blocked"],
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        resetPasswordToken: json["resetPasswordToken"],
      );
}

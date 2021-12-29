import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/constants.dart';
import 'package:warehouse/data/secure_storage.dart';
import 'package:warehouse/globals.dart';
import 'package:warehouse/model/request.dart';
import 'package:warehouse/pages/auth/login_page.dart';
import 'package:warehouse/widgets/request_card.dart';
import 'package:warehouse/widgets/user_profile.dart';
import 'package:http/http.dart' as http;

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UserProfile(),
        _buildCard(
          Icons.schedule_send,
          "Sended requests",
          () => _showSendedRequests(context),
        ),
        _buildCard(
          Icons.schedule,
          "Incoming requests",
          () => _showIncomingRequests(context),
        ),
        _buildCard(
          Icons.logout,
          "Logout",
          () async {
            try {
              await http.get(
                Uri.parse(domainUrl + "/api/auth/logout"),
                headers: {
                  "Authorization": "Bearer $accessToken",
                },
              );
            } catch (e) {}
            await SecureStorage.instance.prefs.write(
              key: "access_token",
              value: null,
              aOptions: secureStorageAndroidOptions,
            );
            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCard(IconData icon, String title, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: ListTile(
          title: Text(title),
          leading: Icon(
            icon,
          ),
        ),
      ),
    );
  }

  void _showSendedRequests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => FutureBuilder<http.Response>(
        future: http.get(
          Uri.parse(
            domainUrl + "/api/request/from",
          ),
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        ),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.data == null) {
            Navigator.of(context).pop();
            return const SizedBox();
          }
          Map<String, dynamic> json = jsonDecode(snapshot.data!.body);
          List<Request> requests =
              (json["data"] as List).map((e) => Request.fromJson(e)).toList()
                ..sort(
                  (req1, req2) =>
                      req1.date.toLocal().compareTo(req2.date.toLocal()),
                );
          if (json["data"] != null) {
            return ListView.builder(
              itemCount: (json["data"] as List).length,
              itemBuilder: (context, index) => RequestCard(
                request: requests[index],
              ),
            );
          }
          Navigator.of(context).pop();
          return const SizedBox();
        },
      ),
    );
  }

  void _showIncomingRequests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => FutureBuilder<http.Response>(
        future: http.get(
          Uri.parse(
            domainUrl + "/api/request/to",
          ),
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        ),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.data == null) {
            Navigator.of(context).pop();
            return const SizedBox();
          }
          Map<String, dynamic> json = jsonDecode(snapshot.data!.body);
          List<Request> requests = (json["data"] as List).map((e) {
            return Request.fromJson(e);
          }).toList()
            ..sort(
              (req1, req2) =>
                  req1.date.toLocal().compareTo(req2.date.toLocal()),
            );
          if (json["data"] != null) {
            return ListView.builder(
              itemCount: (json["data"] as List).length,
              itemBuilder: (context, index) => Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) =>
                          _respondIncomingRequest(context, 0, requests[index]),
                      autoClose: true,
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                    ),
                    SlidableAction(
                      onPressed: (context) =>
                          _respondIncomingRequest(context, 1, requests[index]),
                      autoClose: true,
                      backgroundColor: Colors.green,
                      icon: Icons.done,
                    ),
                  ],
                ),
                child: RequestCard(
                  request: requests[index],
                ),
              ),
            );
          }
          Navigator.of(context).pop();
          return const SizedBox();
        },
      ),
    );
  }

  void _respondIncomingRequest(
      BuildContext context, int i, Request request) async {
    Map<String, dynamic>? json;
    try {
      final response = await http.put(
        Uri.parse(domainUrl + "/api/requests/${request.id}"),
        body: jsonEncode({
          "status": i,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      json = jsonDecode(response.body);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(checkConnectionSnackbar);
      Navigator.pop(context);
    }
    if (json == null) return;
    if (json["success"] == null) return;
    if (json["success"]) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Request " + (i == 1 ? "accepted!" : "declined!")),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:warehouse/model/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  const RequestCard({required this.request, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData leadingIcon, trailingIcon;
    if (request is CreateRequest) {
      leadingIcon = Icons.create;
    } else {
      leadingIcon = Icons.send;
    }
    if (request.status == "accepted") {
      trailingIcon = Icons.done;
    } else {
      trailingIcon = Icons.schedule;
    }
    DateTime time = request.date.toLocal();

    return Card(
      child: ListTile(
        title: Text(time.toString()),
        leading: Icon(
          leadingIcon,
          color: Colors.black,
          size: 20,
        ),
        trailing: Icon(
          trailingIcon,
          size: 20,
        ),
      ),
    );
  }
}

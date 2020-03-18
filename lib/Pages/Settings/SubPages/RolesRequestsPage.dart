import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';

class RolesRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'طلبات المستخدمين',
      child: StreamBuilder(
        stream: Firestore.instance.collection('Users').getDocuments().asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<DocumentSnapshot> data = snapshot.data.documents;
          if (snapshot.hasData) {
            data.removeWhere(
                (DocumentSnapshot test) {
                  if(test.data['role']!=null)print(test.data['role']);
                  return false;//test.data['role'] == null || test.data['role']['pending'] == false;
                });
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                Map user = data[index].data;
                return Text(user['displayName']);
              },
            );
          }

          return SpinKitHourGlass(color: Colors.grey.withOpacity(0.4));
        },
      ),
    );
  }
}

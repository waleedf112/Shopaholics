import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Classes/UserRole.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';

class RolesRequestsPage extends StatefulWidget {
  @override
  _RolesRequestsPageState createState() => _RolesRequestsPageState();
}

class _RolesRequestsPageState extends State<RolesRequestsPage> {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'طلبات المستخدمين',
      child: StreamBuilder(
        stream:
            Firestore.instance.collection('Users').getDocuments().asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> data = snapshot.data.documents;

            data.removeWhere((DocumentSnapshot test) =>
                test.data['role'] == null ||
                test.data['role']['pending'] == false);
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                Map user = data[index].data;
                return Card(
                  elevation: 5,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(user['displayName']),
                                Text(
                                  user['email'],
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.sync,
                                      color: Colors.black54,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                        roleNames[user['role']['currentRole']]),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.new_releases,
                                      color: Colors.orange[400],
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(roleNames[user['role']
                                        ['requestedRole']]),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                OutlinedButton(
                                    text: 'قبول الطلب',
                                    function: () {
                                      loadingScreen(
                                          context: context,
                                          function: () async {
                                            if (currentUser.role ==
                                                UserRole.admin)
                                              await Firestore.instance
                                                  .collection('Users')
                                                  .document(user['uid'])
                                                  .updateData({
                                                'role': {
                                                  'requestedRole': -1,
                                                  'currentRole': user['role']
                                                      ['requestedRole'],
                                                  'pending': false,
                                                }
                                              }).whenComplete(() {
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              });
                                          });
                                    }),
                                OutlinedButton(
                                    text: 'رفض الطلب',
                                    function: () {
                                      loadingScreen(
                                          context: context,
                                          function: () async {
                                            if (currentUser.role ==
                                                UserRole.admin)
                                              await Firestore.instance
                                                  .collection('Users')
                                                  .document(user['uid'])
                                                  .updateData({
                                                'role': {
                                                  'requestedRole': -1,
                                                  'currentRole': user['role']
                                                      ['currentRole'],
                                                  'pending': false,
                                                }
                                              }).whenComplete(() {
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              });
                                          });
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return SpinKitHourGlass(color: Colors.grey.withOpacity(0.4));
        },
      ),
    );
  }
}

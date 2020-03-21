import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'SecondaryView.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String cleanUp(String s) {
      String tmp = s;
      tmp = tmp.replaceAll(',', '');
      tmp = tmp.replaceAll('.', '');
      tmp = tmp.replaceAll('!', '');
      tmp = tmp.replaceAll('?', '');
      tmp = tmp.replaceAll('"', '');
      tmp = tmp.replaceAll('-', '');
      tmp = tmp.replaceAll('_', '');
      tmp = tmp.replaceAll('/', '');
      return tmp;
    }

    return SecondaryView(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('ProductOffer')
            .where('tags', isEqualTo: null)
            .getDocuments()
            .asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: <Widget>[
                  Text(snapshot.data.documents[index].data['id'].toString()),
                  RaisedButton(onPressed: () async {
                    List<String> tags = new List();
                    String desc = snapshot
                        .data.documents[index].data['productDescription'];
                    String name =
                        snapshot.data.documents[index].data['productName'];
                    desc = cleanUp(desc);
                    name = cleanUp(name);
                    List<String> x = desc.split(' ');
                    List<String> y = name.split(' ');
                    x.removeWhere((test) => test.trim().isEmpty);
                    y.removeWhere((test) => test.trim().isEmpty);
                    x = x.toSet().toList();
                    y = y.toSet().toList();
                    await Firestore.instance
                        .collection('ProductOffer')
                        .document(snapshot.data.documents[index].data['id']
                            .toString())
                        .updateData({'tags': x + y});
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/User.dart';

class ListProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(

      stream: currentUser.getLikedOffers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Container();
        return Container(
          child: ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(snapshot.data.documents[index].data.toString().replaceAll(', ', '\n\n')),
                  ),
                  Divider(color: Colors.black.withOpacity(0.7),)
                ],
              );
            },
          ),
        );
      },
    );
  }
}

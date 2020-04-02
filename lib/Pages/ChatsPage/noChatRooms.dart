import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

import '../../Functions/Translation.dart';
import '../../Widgets/TextWidget.dart';

NoChatRooms() => Center(
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Mdi.chatAlertOutline,
                  color: Colors.grey.withOpacity(0.6),
                  size: 100,
                ),
                TextWidget(textTranslation(ar: 'لاتوجد لديك أي محادثات', en: 'You don\'t have any chats'),
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ))
              ],
            ),
          ],
        ),
      ),
    );

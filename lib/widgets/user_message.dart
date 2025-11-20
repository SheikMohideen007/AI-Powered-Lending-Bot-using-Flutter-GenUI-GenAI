import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:sample_bot/schemas/message_schema.dart';

final userMessage = CatalogItem(
  name: 'user_message_bubble',
  dataSchema: messageSchema,
  widgetBuilder: (context) {
    final json = context.data as Map<String, Object?>;
    String text = json['chat'] as String;
    return userChatMessage(text);
  },
);

Widget userChatMessage(String text) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffd7eaff),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 15)),
    ),
  );
}

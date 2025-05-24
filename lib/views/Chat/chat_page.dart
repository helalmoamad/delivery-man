import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/views/Chat/component/chat_messages.dart';
import 'package:delivery_man_app/views/Chat/component/chat_text_field.dart'
    show ChatTextField;
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ChatMessages(receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1'),
              const ChatTextField(receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1'),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        elevation: 5,
        shadowColor: AppColors.lightGray,
        // centerTitle: false,
        backgroundColor: AppColors.white,
        title: const Row(
          children: [
            CircleAvatar(
              // backgroundImage: NetworkImage(value.user!.image),
              backgroundColor: Colors.blue,
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              children: [
                Text(
                  // value.user!.name,
                  'user name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  // value.user!.isOnline ? 'Online' : 'Offline',
                  'Online',
                  style: TextStyle(
                    // color: value.user!.isOnline ? Colors.green : Colors.grey,
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

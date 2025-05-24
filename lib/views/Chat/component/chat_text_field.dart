import 'dart:typed_data';

import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/widgets/custom_text_field.dart'
    show CustomTextField;
import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.receiverId});

  final String receiverId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();

  Uint8List? file;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: controller,
                hintText: 'Add Message...',
                textInputType: TextInputType.text,
                validator: null,
                prefixIcon: null,
                suffixIcon: null,
              ),
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _sendText(context),
              ),
            ),
          ],
        ),
      );

  Future<void> _sendText(BuildContext context) async {
    // if (controller.text.isNotEmpty) {
    //   await FirebaseFirestoreService.addTextMessage(
    //     receiverId: widget.receiverId,
    //     content: controller.text,
    //   );
    //   await notificationsService.sendNotification(
    //     body: controller.text,
    //     senderId: FirebaseAuth.instance.currentUser!.uid,
    //   );
    //   controller.clear();
    //   FocusScope.of(context).unfocus();
    // }
    // FocusScope.of(context).unfocus();
  }
}

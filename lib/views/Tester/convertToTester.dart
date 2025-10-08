import 'dart:convert';

import 'package:delivery_man_app/TrydosChat/chat_utils/prefs_key.dart';
import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/message_error_log/errorLogModel.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConvertToTesterScreen extends StatefulWidget {
  const ConvertToTesterScreen({super.key});

  @override
  State<ConvertToTesterScreen> createState() => _ConvertToTesterScreen();
}

class _ConvertToTesterScreen extends State<ConvertToTesterScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, String> savedData = {};

  @override
  void initState() {
    super.initState();
  }

  void _saveNote() {
    final prefs = Get.find<SharedPreferences>();
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please input error log")),
      );
      return;
    }
    final data = jsonDecode(text);
    var model = ErrorLog.fromJson(data);

    GlobalFunctions.setLanLocal(lanLocal: model.language!);
    GlobalFunctions.setChatToken(chatToken: model.userChatToken!);
    GlobalFunctions.setUserId(id: model.userFleetId!);
    GlobalFunctions.setName(name: model.userFleetName!);
    GlobalFunctions.setToken(token: model.userFleetToken!);
    GlobalFunctions.setIsLoggedIn(isLoggedIn: model.isLoggedIn!);
    prefs.setString(PrefsKey.chatToken, model.userChatToken!);
    prefs.setString(PrefsKey.chatPhoto, model.userChatPhoto!);
    prefs.setInt(PrefsKey.userChatId, model.userChatId!);

    setState(() {
      savedData = {
        "language": model.language?.toString() ?? "",
        "chatToken": model.userChatToken?.toString() ?? "",
        "userFleetId": model.userFleetId?.toString() ?? "",
        "userFleetName": model.userFleetName?.toString() ?? "",
        "userFleetToken": model.userFleetToken?.toString() ?? "",
        "isLoggedIn": model.isLoggedIn?.toString() ?? "",
        "chatPhoto": model.userChatPhoto?.toString() ?? "",
        "userChatId": model.userChatId?.toString() ?? "",
      };
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data saved successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    PagesMonitor.addPageToList(page: "ConvertToTesterScreen");
    FlutterError.onError = (details) async {
      FlutterError.presentError(details);
      print("Before creating log************************");

      final log = await DeviceInfoHelper.createErrorLog(
          errorType: "Flutter Error",
          lastFourPageVisited: lastFourPageVisited,
          errorPath: lastFourPageVisited.last ?? "",
          lastApiRequest: '');
          print("After creating log: $log");

      print("*****${log.toJson()}");
      await errorSender.sendError(log);
      await Sentry.captureException(details.exception,
          stackTrace: details.stack);
    };
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Add Info"),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text Input
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _controller,
                maxLines: 6,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: "Input here",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveNote,
                icon: const Icon(Icons.save),
                label: const Text("Save"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Data Table
            if (savedData.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, 
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width),
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.teal.shade100),
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        dataTextStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                        border: TableBorder.symmetric(
                          inside:
                              const BorderSide(color: Colors.grey, width: 0.5),
                          outside:
                              const BorderSide(color: Colors.grey, width: 1),
                        ),
                        columns: const [
                          DataColumn(label: Text("Key")),
                          DataColumn(label: Text("Value")),
                        ],
                        rows: savedData.entries
                            .map(
                              (e) => DataRow(cells: [
                                DataCell(
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 150),
                                    child: Text(
                                      e.key,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 250),
                                    child: Text(
                                      e.value,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ]),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
// ElevatedButton(
//   onPressed: () {
//     throw Exception("⚡️Test error from ConvertToTesterScreen");
//   },
//   style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//   child: const Text("Generate Test Error"),
// ),
          ],
        ),
      ),
    );
  }
}

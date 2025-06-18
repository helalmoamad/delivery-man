import 'package:delivery_man_app/TrydosChat/api/chat_url_routes.dart';
import 'package:delivery_man_app/TrydosChat/api/cloudinary_url_routes.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:get_it/get_it.dart';

enum ServerName { chat, cloudinary }

//todo make the return value dynamic to return the cloudinary as String
Uri getBaseUriForSpecificServer(ServerName serverName) {
  switch (serverName) {
    case ServerName.chat:
      return ChatUrls.baseUri;

    case ServerName.cloudinary:
      return CloudinaryUrls.baseUri;
  }
}

String? getServerToken(ServerName serverName) {
  final PrefsRepository prefsRepository = GetIt.I<PrefsRepository>();
  return prefsRepository.chatToken;
}

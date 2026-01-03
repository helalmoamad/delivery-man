import 'dart:async';
import 'dart:io';
import 'package:delivery_man_app/TrydosChat/api/chat_url_routes.dart';
import 'package:delivery_man_app/TrydosChat/api/client_config.dart';
import 'package:delivery_man_app/TrydosChat/api/methods/detect_server.dart';
import 'package:delivery_man_app/TrydosChat/api/methods/get.dart';
import 'package:delivery_man_app/TrydosChat/api/methods/post.dart';
import 'package:delivery_man_app/TrydosChat/api/methods/put.dart';
import 'package:delivery_man_app/TrydosChat/data/models/change_chat_property_model.dart';
import 'package:delivery_man_app/TrydosChat/data/models/create_user_response_model.dart';
import 'package:delivery_man_app/TrydosChat/data/models/get_order_recipient_id_model.dart';
import 'package:delivery_man_app/TrydosChat/data/models/my_contacts_response_model.dart';
import 'package:delivery_man_app/TrydosChat/data/models/result_of_search_text_in_chat_model.dart';
import 'package:delivery_man_app/TrydosChat/data/models/shared_product_count_model.dart';
import 'package:delivery_man_app/TrydosChat/data/models/store_fcm_token_response_model.dart';
import 'package:delivery_man_app/TrydosChat/data/models/upload_file_response_model.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import '../models/ImageDetail.dart';
import '../models/media_count.dart';
import '../models/my_chats_response_model.dart';

@injectable
class ChatRemoteDataSource {
  Future<MyContactsResponseModel> getContacts() {
    PostClient<MyContactsResponseModel> getContacts =
        PostClient<MyContactsResponseModel>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<MyContactsResponseModel>(
        endpoint: ChatEndPoints.getMyContactsEP,
        response: ResponseValue<MyContactsResponseModel>(
            fromJson: (response) => MyContactsResponseModel.fromJson(response)),
      ),
    );
    return getContacts();
  }

  Future<bool> readAllMessages(Map<String, dynamic> params) {
    GetClient<bool> readAllMessages = GetClient<bool>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<bool>(
        endpoint: ChatEndPoints.readAllMessagesEP(params['id'].toString()),
        response: ResponseValue<bool>(returnValueOnSuccess: true),
      ),
    );
    return readAllMessages();
  }

  Future<StoreFcmTokenResponseModel> storeFcmToken(
      Map<String, dynamic> params) {
    PostClient<StoreFcmTokenResponseModel> storeFcmToken =
        PostClient<StoreFcmTokenResponseModel>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<StoreFcmTokenResponseModel>(
        endpoint: ChatEndPoints.storeFcmEP,
        data: params['data'],
        response: ResponseValue<StoreFcmTokenResponseModel>(
            fromJson: (response) =>
                StoreFcmTokenResponseModel.fromJson(response)),
      ),
    );
    return storeFcmToken();
  }

  Future<bool> deleteFcmTokenFromChat(Map<String, dynamic> params) {
    PostClient<bool> deleteFcmTokenFromChat = PostClient<bool>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<bool>(
        endpoint: ChatEndPoints.deleteFcmEP,
        data: params,
        response: ResponseValue<bool>(returnValueOnSuccess: true),
      ),
    );
    return deleteFcmTokenFromChat();
  }

  Future<bool> updateProfileInChat(Map<String, dynamic> params) {
    Map<String, dynamic> data = Map.of(params);
    data.removeWhere((key, value) => key == "id");
    PutClient<bool> updateProfileInChat = PutClient<bool>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<bool>(
        data: data,
        endpoint: ChatEndPoints.updateProfileInChatEP(params['id'].toString()),
        response: ResponseValue<bool>(returnValueOnSuccess: true),
      ),
    );
    return updateProfileInChat();
  }

  Future<bool> receiveMessage(Map<String, dynamic> params) {
    GetClient<bool> receiveMessage = GetClient<bool>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<bool>(
        endpoint: ChatEndPoints.receiveMessageEP(params['id'].toString()),
        response: ResponseValue<bool>(returnValueOnSuccess: true),
      ),
    );
    return receiveMessage();
  }

  Future<String> getDateTime() {
    GetClient<String> getDateTime = GetClient<String>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<String>(
        endpoint: ChatEndPoints.getDateTime,
        response:
            ResponseValue<String>(fromJson: (response) => response["data"]),
      ),
    );
    return getDateTime();
  }

  Future<MyChatsResponseModel> getChats(Map<String, dynamic> params) {
    PostClient<MyChatsResponseModel> getChats =
        PostClient<MyChatsResponseModel>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<MyChatsResponseModel>(
        endpoint: ChatEndPoints.getMyChatsEP,
        queryParameters: params,
        response: ResponseValue<MyChatsResponseModel>(fromJson: (response) {
          return MyChatsResponseModel.fromJson(response);
//return MyChatsResponseModel();
        }),
      ),
    );
    return getChats();
  }

  Future<GetOrderRecipientIdModel> getOrderRecipientId(
      Map<String, dynamic> params) {
    PostClient<GetOrderRecipientIdModel> getOrderRecipientId =
        PostClient<GetOrderRecipientIdModel>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<GetOrderRecipientIdModel>(
        endpoint: ChatEndPoints.getOrderRecipientIdEP,
        data: params,
        response: ResponseValue<GetOrderRecipientIdModel>(fromJson: (response) {
          return GetOrderRecipientIdModel.fromJson(response);
//return MyChatsResponseModel();
        }),
      ),
    );
    return getOrderRecipientId();
  }

  Future<ChangeChatPropertyModel> changeChatProperty(
      Map<String, dynamic> params) {
    PostClient<ChangeChatPropertyModel> changeChatProperty =
        PostClient<ChangeChatPropertyModel>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<ChangeChatPropertyModel>(
        endpoint: ChatEndPoints.setChatPropertyEP,
        data: params,
        response: ResponseValue<ChangeChatPropertyModel>(
            fromJson: (response) => ChangeChatPropertyModel.fromJson(response)),
      ),
    );
    return changeChatProperty();
  }

  Future<List<ChatMessage>> getMessagesForChat(Map<String, dynamic> params) {
    PostClient<List<ChatMessage>> getMessagesForChat =
        PostClient<List<ChatMessage>>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<List<ChatMessage>>(
        endpoint: ChatEndPoints.getMessagesForChatEP(params['params']),
        data: params['data'],
        response: ResponseValue<List<ChatMessage>>(
            fromJson: (response) => List<ChatMessage>.from(
                response["data"]!.map((x) => ChatMessage.fromJson(x)))),
      ),
    );
    return getMessagesForChat();
  }

  Future<List<ChatMessage>> getMessagesBetween(Map<String, dynamic> params) {
    PostClient<List<ChatMessage>> getMessagesBetween =
        PostClient<List<ChatMessage>>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<List<ChatMessage>>(
        endpoint: ChatEndPoints.getMessagesBetweenEP,
        data: params,
        receiveTimeout: const Duration(minutes: 2),
        sendTimeout: const Duration(minutes: 2),
        response: ResponseValue<List<ChatMessage>>(
            fromJson: (response) => List<ChatMessage>.from(
                response["data"]!.map((x) => ChatMessage.fromJson(x)))),
      ),
    );
    return getMessagesBetween();
  }

  Future<UploadFileResponseModel> uploadFile(Map<String, dynamic> params) {
    PostClient<UploadFileResponseModel> uploadFile =
        PostClient<UploadFileResponseModel>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<UploadFileResponseModel>(
        endpoint: ChatEndPoints.uploadFileEP,
        data: params['data'],
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
        response: ResponseValue<UploadFileResponseModel>(
            fromJson: (response) => UploadFileResponseModel.fromJson(response)),
      ),
    );
    return uploadFile();
  }

  Future<bool> saveContacts(Map<String, dynamic> params) {
    PostClient<bool> saveContacts = PostClient<bool>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<bool>(
        endpoint: ChatEndPoints.saveContactsEP,
        data: params,
        response: ResponseValue<bool>(returnValueOnSuccess: true),
      ),
    );
    return saveContacts();
  }

  Future<bool> deleteChat(Map<String, dynamic> params) {
    PostClient<bool> deleteChat = PostClient<bool>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<bool>(
        endpoint: ChatEndPoints.deleteChatEP,
        data: params,
        response: ResponseValue<bool>(returnValueOnSuccess: true),
      ),
    );
    return deleteChat();
  }

  Future<ChatMessage> sendMessage(Map<String, dynamic> params) {
    PostClient<ChatMessage> sendMessage = PostClient<ChatMessage>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<ChatMessage>(
        receiveTimeout: const Duration(minutes: 1),
        sendTimeout: const Duration(minutes: 1),
        endpoint: ChatEndPoints.sendMessageEP,
        data: params,
        response: ResponseValue<ChatMessage>(
            fromJson: (response) => ChatMessage.fromJson(response['data'])),
      ),
    );
    return sendMessage();
  }

  Future<ChatMessage> shareProductWithContactsOrChannels(
      Map<String, dynamic> params) {
    PostClient<ChatMessage> shareProductWithContactsOrChannels =
        PostClient<ChatMessage>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<ChatMessage>(
        receiveTimeout: const Duration(minutes: 1),
        sendTimeout: const Duration(minutes: 1),
        endpoint: ChatEndPoints.shareProductWithChannelsOrContacts,
        data: params,
        response: ResponseValue<ChatMessage>(
            fromJson: (response) => ChatMessage.fromJson(response['data'])),
      ),
    );
    return shareProductWithContactsOrChannels();
  }

  Future<CreateUserResponseModel> createUser(Map<String, dynamic> params) {
    PostClient<CreateUserResponseModel> createUser =
        PostClient<CreateUserResponseModel>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<CreateUserResponseModel>(
        endpoint: ChatEndPoints.createUserEP,
        data: params,
        response: ResponseValue<CreateUserResponseModel>(
            fromJson: (response) => CreateUserResponseModel.fromJson(response)),
      ),
    );
    return createUser();
  }

  Future<bool> shareProductOnApps(Map<String, dynamic> params) {
    PostClient<bool> shareProductOnApps = PostClient<bool>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<bool>(
        endpoint: ChatEndPoints.shareProductOnAppsEP,
        data: params,
        response: ResponseValue<bool>(returnValueOnSuccess: true),
      ),
    );
    return shareProductOnApps();
  }

  Future<ChatImageDetail> loadWidthAndHeightForImage(
      {required File ImageFile, Function? onError}) async {
    Completer<ChatImageDetail> completer = Completer<ChatImageDetail>();

    completer = Completer<ChatImageDetail>();
    Image image;
    image = Image.file(ImageFile);
    try {
      image.image
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener(
            (
              ImageInfo imageInfo,
              bool _,
            ) {
              final dimensions = ChatImageDetail(
                width: imageInfo.image.width,
                height: imageInfo.image.height,
              );
              if (completer.isCompleted == false) {
                completer.complete(dimensions);
              }
            },
            onError: (exception, stackTrace) {
              if (onError != null) onError();
            },
          ));
    } catch (e) {
      // GetIt.I<StoryBloc>().add(LoadFailureEvent());
    }
    return completer.future;
  }

  Future<MediaCount> getMediaCount(Map<String, dynamic> params) {
    GetClient<MediaCount> receiveMessage = GetClient<MediaCount>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<MediaCount>(
        endpoint: ChatEndPoints.getMediaCount(params["id"]),
        response: ResponseValue<MediaCount>(
            fromJson: (response) => MediaCount.fromJson(response)),
      ),
    );
    return receiveMessage();
  }

  Future<GetSharedProductCountModel> getSharedProductCount(
      Map<String, dynamic> params) {
    print("/////////////////////////////////////////////////${params["id"]}");
    GetClient<GetSharedProductCountModel> getSharedProductCount =
        GetClient<GetSharedProductCountModel>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<GetSharedProductCountModel>(
        endpoint: ChatEndPoints.getSharedProductCount(params["id"]),
        response: ResponseValue<GetSharedProductCountModel>(
            fromJson: (response) =>
                GetSharedProductCountModel.fromJson(response)),
      ),
    );
    return getSharedProductCount();
  }

  Future<bool> sendErrorChatToServer(Map<String, dynamic> params) {
    PostClient<bool> sendErrorChatToServer = PostClient<bool>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<bool>(
          endpoint: ChatEndPoints.sendErrorChatToServer,
          data: params,
          response: ResponseValue<bool>(returnValueOnSuccess: true)),
    );
    return sendErrorChatToServer();
  }

  Future<ResultOfSearchTextInChatModel> searchForMessageTextInChat(
      Map<String, dynamic> params) {
    PostClient<ResultOfSearchTextInChatModel> searchForMessageTextInChat =
        PostClient<ResultOfSearchTextInChatModel>(
      serverName: ServerName.chat,
      requestPrams: RequestConfig<ResultOfSearchTextInChatModel>(
        receiveTimeout: const Duration(minutes: 1),
        sendTimeout: const Duration(minutes: 1),
        endpoint: ChatEndPoints.searchForMessageTextInChatEP,
        data: params,
        response: ResponseValue<ResultOfSearchTextInChatModel>(
            fromJson: (response) =>
                ResultOfSearchTextInChatModel.fromJson(response)),
      ),
    );
    return searchForMessageTextInChat();
  }
}

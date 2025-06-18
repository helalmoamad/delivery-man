// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../calls/data/data_source/calls_remote_data_source_model.dart'
    as _i262;
import '../../calls/data/repositories/calls_repository_impl.dart' as _i126;
import '../../calls/domain/repositories/calls_repository.dart' as _i739;
import '../../calls/domain/useCase/answer_call_usecase.dart' as _i1043;
import '../../calls/domain/useCase/delete_Message.dart' as _i697;
import '../../calls/domain/useCase/get_agora_token_use_case.dart' as _i645;
import '../../calls/domain/useCase/get_missed_call_count.dart' as _i34;
import '../../calls/domain/useCase/get_my_calls.dart' as _i895;
import '../../calls/domain/useCase/make_call_usecase.dart' as _i894;
import '../../calls/domain/useCase/reject_call_usecase.dart' as _i645;
import '../../calls/domain/useCase/watch_missed_call.dart' as _i485;
import '../../calls/presentation/bloc/calls_bloc.dart' as _i756;
import '../data/data_sources/chat_remote_datasource.dart' as _i722;
import '../data/data_sources/common_use_repo_data_source.dart' as _i195;
import '../data/repositories/chat_repository_impl.dart' as _i919;
import '../data/repositories/common_use_repository_impl.dart' as _i635;
import '../domain/repositories/chat_repository.dart' as _i792;
import '../domain/repositories/common_use_repository.dart' as _i49;
import '../domain/repositories/prefs_repository.dart' as _i89;
import '../domain/use_cases/change_chat_property_usecase.dart' as _i193;
import '../domain/use_cases/delete_chat_usecase.dart' as _i997;
import '../domain/use_cases/get_contacts_usecase.dart' as _i1068;
import '../domain/use_cases/get_date_time.dart' as _i221;
import '../domain/use_cases/get_image_width_and_height_usecase.dart' as _i901;
import '../domain/use_cases/get_media_count_usecase.dart' as _i1022;
import '../domain/use_cases/get_messages_between_usecase.dart' as _i999;
import '../domain/use_cases/get_messages_for_chat_usecase.dart' as _i146;
import '../domain/use_cases/get_my_chats_usecase.dart' as _i838;
import '../domain/use_cases/get_order_recipient_id_usecase.dart' as _i795;
import '../domain/use_cases/get_shared_product_count_usecase.dart' as _i883;
import '../domain/use_cases/read_all_messages_usecase.dart' as _i352;
import '../domain/use_cases/receive_message_usecase.dart' as _i136;
import '../domain/use_cases/save_contacts_usecase.dart' as _i756;
import '../domain/use_cases/search_For_message_text_in_chat_usecase.dart'
    as _i1020;
import '../domain/use_cases/send_error_to_server_usecase.dart' as _i588;
import '../domain/use_cases/send_message_usecase.dart' as _i798;
import '../domain/use_cases/share_product_on_social_app_count_usecase.dart'
    as _i592;
import '../domain/use_cases/share_product_with_contacts_or_channels_usecase.dart'
    as _i726;
import '../domain/use_cases/store_fcm_usecase.dart' as _i261;
import '../domain/use_cases/update_profile_chat_usecase.dart' as _i908;
import '../domain/use_cases/upload_file_cloudinary_usecase.dart' as _i337;
import '../domain/use_cases/upload_file_usecase.dart' as _i620;
import '../presentation/manager/app_bloc/app_bloc.dart' as _i896;
import '../presentation/manager/chat_bloc.dart' as _i212;
import '../presentation/manager/preload_bloc/preloading_videos_bloc.dart'
    as _i1003;
import 'di_container.dart' as _i198;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  gh.factory<_i262.CallsRemoteDataSource>(() => _i262.CallsRemoteDataSource());
  gh.factory<_i722.ChatRemoteDataSource>(() => _i722.ChatRemoteDataSource());
  gh.factory<_i361.BaseOptions>(() => appModule.dioOption);
  gh.factory<_i1003.PreloadingVideosBloc>(() => _i1003.PreloadingVideosBloc());
  gh.factory<_i195.CommonUseRemoteDataSource>(
      () => _i195.CommonUseRemoteDataSource());
  gh.singleton<_i974.Logger>(() => appModule.logger);
  await gh.singletonAsync<_i460.SharedPreferences>(
    () => appModule.sharedPreferences,
    preResolve: true,
  );
  await gh.singletonAsync<_i89.PrefsRepository>(
    () => appModule.prefsRepository,
    preResolve: true,
  );
  gh.lazySingleton<_i896.AppBloc>(() => _i896.AppBloc());
  gh.lazySingleton<_i792.ChatRepository>(
      () => _i919.ChatRepositoryImpl(gh<_i722.ChatRemoteDataSource>()));
  gh.lazySingleton<_i739.CallsRepository>(
      () => _i126.CallsRepositoryImpl(gh<_i262.CallsRemoteDataSource>()));
  gh.lazySingleton<_i49.CommonUseRepository>(() =>
      _i635.CommonUseRepositoryImpl(gh<_i195.CommonUseRemoteDataSource>()));
  gh.factory<_i1043.AnswerCallUseCase>(
      () => _i1043.AnswerCallUseCase(gh<_i739.CallsRepository>()));
  gh.factory<_i697.DeleteMessageUseCase>(
      () => _i697.DeleteMessageUseCase(gh<_i739.CallsRepository>()));
  gh.factory<_i645.GetAgoraTokenUseCase>(
      () => _i645.GetAgoraTokenUseCase(gh<_i739.CallsRepository>()));
  gh.factory<_i34.GetMissedCalCountUseCase>(
      () => _i34.GetMissedCalCountUseCase(gh<_i739.CallsRepository>()));
  gh.factory<_i895.GetMyCallsUseCase>(
      () => _i895.GetMyCallsUseCase(gh<_i739.CallsRepository>()));
  gh.factory<_i894.MakeCallUseCase>(
      () => _i894.MakeCallUseCase(gh<_i739.CallsRepository>()));
  gh.factory<_i645.RejectCallUseCase>(
      () => _i645.RejectCallUseCase(gh<_i739.CallsRepository>()));
  gh.factory<_i485.WatchMissedCallUseCase>(
      () => _i485.WatchMissedCallUseCase(gh<_i739.CallsRepository>()));
  gh.singleton<_i361.Dio>(() => appModule.dio(
        gh<_i361.BaseOptions>(),
        gh<_i974.Logger>(),
      ));
  gh.factory<_i337.UploadFileCloudinaryUseCase>(
      () => _i337.UploadFileCloudinaryUseCase(gh<_i49.CommonUseRepository>()));
  gh.factory<_i193.ChangeChatPropertyUseCase>(
      () => _i193.ChangeChatPropertyUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i997.DeleteChatUseCase>(
      () => _i997.DeleteChatUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i1068.GetContactsUseCase>(
      () => _i1068.GetContactsUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i221.GetDateTimeUseCase>(
      () => _i221.GetDateTimeUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i901.GetWidthAndHeightUseCase>(
      () => _i901.GetWidthAndHeightUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i1022.GetMediaCountUseCase>(
      () => _i1022.GetMediaCountUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i999.GetMessagesBetweenUseCase>(
      () => _i999.GetMessagesBetweenUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i146.GetMessagesForChatUseCase>(
      () => _i146.GetMessagesForChatUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i838.GetMyChatsUseCase>(
      () => _i838.GetMyChatsUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i795.GetOrderRecipientIdUseCase>(
      () => _i795.GetOrderRecipientIdUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i883.GetSharedProductCountUseCase>(
      () => _i883.GetSharedProductCountUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i352.ReadAllMessagesUseCase>(
      () => _i352.ReadAllMessagesUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i136.ReceiveMessageUseCase>(
      () => _i136.ReceiveMessageUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i756.SaveContactsUseCase>(
      () => _i756.SaveContactsUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i1020.SearchForMessageTextInChatUseCase>(() =>
      _i1020.SearchForMessageTextInChatUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i588.SendErrorToServerUseCase>(
      () => _i588.SendErrorToServerUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i798.SendMessageUseCase>(
      () => _i798.SendMessageUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i592.ShareProductOnAppsUseCase>(
      () => _i592.ShareProductOnAppsUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i726.ShareProductWithContactsOrChannelsUsecase>(() =>
      _i726.ShareProductWithContactsOrChannelsUsecase(
          gh<_i792.ChatRepository>()));
  gh.factory<_i908.UpdateProfileInChatUseCase>(
      () => _i908.UpdateProfileInChatUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i620.UploadFileUseCase>(
      () => _i620.UploadFileUseCase(gh<_i792.ChatRepository>()));
  gh.factory<_i261.StoreFcmUseCase>(
      () => _i261.StoreFcmUseCase(gh<_i792.ChatRepository>()));
  gh.lazySingleton<_i756.CallsBloc>(() => _i756.CallsBloc(
        gh<_i645.RejectCallUseCase>(),
        gh<_i894.MakeCallUseCase>(),
        gh<_i895.GetMyCallsUseCase>(),
        gh<_i485.WatchMissedCallUseCase>(),
        gh<_i1043.AnswerCallUseCase>(),
        gh<_i34.GetMissedCalCountUseCase>(),
        gh<_i645.GetAgoraTokenUseCase>(),
        gh<_i697.DeleteMessageUseCase>(),
      ));
  gh.lazySingleton<_i212.ChatBloc>(() => _i212.ChatBloc(
        gh<_i1068.GetContactsUseCase>(),
        gh<_i838.GetMyChatsUseCase>(),
        gh<_i592.ShareProductOnAppsUseCase>(),
        gh<_i756.SaveContactsUseCase>(),
        gh<_i798.SendMessageUseCase>(),
        gh<_i883.GetSharedProductCountUseCase>(),
        gh<_i999.GetMessagesBetweenUseCase>(),
        gh<_i795.GetOrderRecipientIdUseCase>(),
        gh<_i261.StoreFcmUseCase>(),
        gh<_i337.UploadFileCloudinaryUseCase>(),
        gh<_i146.GetMessagesForChatUseCase>(),
        gh<_i997.DeleteChatUseCase>(),
        gh<_i1020.SearchForMessageTextInChatUseCase>(),
        gh<_i193.ChangeChatPropertyUseCase>(),
        gh<_i620.UploadFileUseCase>(),
        gh<_i352.ReadAllMessagesUseCase>(),
        gh<_i136.ReceiveMessageUseCase>(),
        gh<_i908.UpdateProfileInChatUseCase>(),
        gh<_i726.ShareProductWithContactsOrChannelsUsecase>(),
        gh<_i1022.GetMediaCountUseCase>(),
        gh<_i221.GetDateTimeUseCase>(),
        gh<_i588.SendErrorToServerUseCase>(),
      ));
  return getIt;
}

class _$AppModule extends _i198.AppModule {}

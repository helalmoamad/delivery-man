import 'package:delivery_man_app/TrydosChat/presentation/manager/app_bloc/app_bloc.dart'
    show AppBloc;
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_bloc.dart';
import 'package:delivery_man_app/calls/presentation/bloc/calls_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ServiceProvider extends StatelessWidget {
  final Widget child;
  const ServiceProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => GetIt.I<CallsBloc>()),
        BlocProvider(create: (BuildContext context) => GetIt.I<AppBloc>()),
        BlocProvider(create: (BuildContext context) => GetIt.I<ChatBloc>()),
      ],
      child: child,
    );
  }
}

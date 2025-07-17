import 'package:chatbot_app_bloc/bloc/deep.bot.bloc.dart';
import 'package:chatbot_app_bloc/pages/dashboard.page.dart';
import 'package:chatbot_app_bloc/pages/deep.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [BlocProvider(create: (context) => DeepBotBloc())],
        child: RootView());
  }
}

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/deepbot": (context) => DeepSeekPage(),
        "/dashboard": (context) => DashboardPage()
      },
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.teal),
      home: DashboardPage(),
    );
    ;
  }
}

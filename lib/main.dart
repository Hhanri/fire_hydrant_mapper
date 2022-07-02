import 'package:fire_hydrant_mapper/main_bloc/main_bloc.dart';
import 'package:fire_hydrant_mapper/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Hydrant Mapper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<MainBloc>(
        create: (context) => MainBloc()..add(MainInitializeEvent()),
        child: const HomePage(),
      ),
    );
  }
}



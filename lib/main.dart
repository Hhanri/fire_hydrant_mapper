import 'package:fire_hydrant_mapper/blocs/main_bloc/main_bloc.dart';
import 'package:fire_hydrant_mapper/pages/home_page.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: RepositoryProvider(
        create: (context) => FirebaseService(),
        child: BlocProvider<MainBloc>(
          create: (context) =>
          MainBloc(
            firebaseService: RepositoryProvider.of<FirebaseService>(context),
          )..add(MainInitializeEvent()),
          child: const HomePage(),
        ),
      ),
    );
  }
}



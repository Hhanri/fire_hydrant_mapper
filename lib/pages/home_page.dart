import 'package:fire_hydrandt_mapper/main_bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainInitializedState) {

          }
          return const Center(
            child: Text("Error"),
          );
        }
      ),
    );
  }
}
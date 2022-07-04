import 'package:fire_hydrant_mapper/main_bloc/main_bloc.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:fire_hydrant_mapper/widgets/center_floating_action_button_widget.dart';
import 'package:fire_hydrant_mapper/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: const AddLocationFloatingActionButtonWidget(),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {

          if (state is MainInitializedState) {

            return const MapWidget();
          }
          return const Center(
            child: Text("Error"),
          );
        }
      ),
    );
  }
}
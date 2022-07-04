import 'package:fire_hydrant_mapper/main_bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CenterFloatingActiobButtonWidget extends StatelessWidget {
  const CenterFloatingActiobButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<MainBloc>().add(CenterCameraEvent());
      },
      child: const Icon(Icons.location_searching),
    );
  }
}

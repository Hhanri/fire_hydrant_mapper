import 'package:fire_hydrant_mapper/main_bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLocationFloatingActionButtonWidget extends StatelessWidget {
  const AddLocationFloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<MainBloc>().add(AddPositionEvent(context: context));
      },
      child: const Icon(
        Icons.add_location_outlined
      ),
    );
  }
}

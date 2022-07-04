import 'package:fire_hydrant_mapper/main_bloc/main_bloc.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLocationFloatingActionButtonWidget extends StatelessWidget {
  const AddLocationFloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FireHydrantLogModel?>(
      stream: context.read<MainBloc>().tempLogStream.stream,
      builder: (context, localMarker) {
        if (localMarker.hasData) {
          return FloatingActionButton(
            onPressed: () {
              context.read<MainBloc>().add(AddPositionEvent(context: context, log: localMarker.data!));
            },
            child: const Icon(
                Icons.add_location_outlined
            ),
          );
        }
        return Container();
      }
    );
  }
}

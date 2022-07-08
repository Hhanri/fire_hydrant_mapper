import 'package:fire_hydrant_mapper/blocs/log_form_cubit/log_form_cubit.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_archive_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivesListViewWidget extends StatelessWidget {
  final String parentLogId;
  const ArchivesListViewWidget({Key? key, required this.parentLogId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FireHydrantArchiveModel>>(
      stream: context.read<LogFormCubit>().archivesStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Text(
                snapshot.data![index].waterLevel.toString()
              );
            }
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

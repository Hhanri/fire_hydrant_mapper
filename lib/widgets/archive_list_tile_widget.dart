import 'package:fire_hydrant_mapper/blocs/log_form_cubit/log_form_cubit.dart';
import 'package:fire_hydrant_mapper/models/archive_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ArchiveListTileWidget extends StatelessWidget {
  final ArchiveModel archive;
  const ArchiveListTileWidget({Key? key, required this.archive}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final String title = DateFormat('yyyy-MM-dd – kk:mm').format(archive.date);
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ViewArchiveButton(),
          const EditArchiveButton(),
          DeleteArchiveButton(archiveId: archive.archiveId)
        ],
      )
    );
  }
}

class ViewArchiveButton extends StatelessWidget {
  const ViewArchiveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {

      },
      icon: const Icon(Icons.remove_red_eye),
    );
  }
}

class EditArchiveButton extends StatelessWidget {
  const EditArchiveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {

      },
      icon: const Icon(Icons.edit),
    );
  }
}

class DeleteArchiveButton extends StatelessWidget {
  final String archiveId;
  const DeleteArchiveButton({Key? key, required this.archiveId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await context.read<LogFormCubit>().deleteArchive(archiveId);
      },
      icon: const Icon(Icons.delete),
    );
  }
}


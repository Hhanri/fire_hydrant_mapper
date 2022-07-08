import 'package:fire_hydrant_mapper/models/archive_model.dart';
import 'package:flutter/material.dart';
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
        children: const [
          ViewArchiveButton(),
          EditArchiveButton(),
          DeleteArchiveButton()
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
  const DeleteArchiveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {

      },
      icon: const Icon(Icons.delete),
    );
  }
}


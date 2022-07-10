import 'package:fire_hydrant_mapper/blocs/archive_form_cubit/archive_form_cubit.dart';
import 'package:fire_hydrant_mapper/dialogs/error_dialog.dart';
import 'package:fire_hydrant_mapper/models/archive_model.dart';
import 'package:fire_hydrant_mapper/screens/loading/loading_screen.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:fire_hydrant_mapper/widgets/form_app_bar.dart';
import 'package:fire_hydrant_mapper/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchiveFormPage extends StatelessWidget {
  final ArchiveModel initialArchive;
  const ArchiveFormPage({Key? key, required this.initialArchive}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocProvider<ArchiveFormCubit>(
      create: (context) => ArchiveFormCubit(
        context: context,
        initialArchive: initialArchive,
        firebaseService: RepositoryProvider.of<FirebaseService>(context)
      )..init(),
      child: BlocConsumer<ArchiveFormCubit, ArchiveFormState>(
        listener: (context, state) {
          if (state.isLoading) {
            LoadingScreen.instance().show(context: context, text: 'loading...');
          } else {
            LoadingScreen.instance().hide();
          }
          if (state.errorMessage != null) {
            showErrorMessage(errorMessage: state.errorMessage!, context: context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: FormAppBarWidget(
              onDelete: () async {
                await context.read<ArchiveFormCubit>().deleteArchive();
                await Future.microtask(() => Navigator.of(context).pop());
              },
              onValidate: () async {
                if (formKey.currentState!.validate()) {
                  await context.read<ArchiveFormCubit>().editArchive();
                  await Future.microtask(() => Navigator.of(context).pop());
                }
              },
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    DatePickerTextFieldWidget(
                      controller: context.read<ArchiveFormCubit>().dateController,
                      onTap: () async {
                        await context.read<ArchiveFormCubit>().pickDateTime();
                      }
                    ),
                    TextFormFieldWidget(
                      parameters: WaterLevelParameters(controller: context.read<ArchiveFormCubit>().waterLevelController)
                    ),
                    TextFormFieldWidget(
                      parameters: NoteParameters(controller: context.read<ArchiveFormCubit>().noteController)
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

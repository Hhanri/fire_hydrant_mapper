import 'package:fire_hydrant_mapper/blocs/log_form_cubit/log_form_cubit.dart';
import 'package:fire_hydrant_mapper/dialogs/error_dialog.dart';
import 'package:fire_hydrant_mapper/models/log_model.dart';
import 'package:fire_hydrant_mapper/screens/loading/loading_screen.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:fire_hydrant_mapper/widgets/archives_list_view_widget.dart';
import 'package:fire_hydrant_mapper/widgets/form_app_bar.dart';
import 'package:fire_hydrant_mapper/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogFormPage extends StatelessWidget {
  final LogModel initialLog;
  const LogFormPage({Key? key, required this.initialLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocProvider<LogFormCubit>(
      create: (context) => LogFormCubit(
        initialLog: initialLog, firebaseService: RepositoryProvider.of<FirebaseService>(context)
      )..init(),
      child: BlocConsumer<LogFormCubit, LogFormState>(
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
                await context.read<LogFormCubit>().deleteLog();
                Future.microtask(() => Navigator.of(context).pop());
              },
              onValidate: () async {
                if (formKey.currentState!.validate()) {
                  await context.read<LogFormCubit>().editLog();
                  Future.microtask(() => Navigator.of(context).pop());
                }
              },
            ),
            body: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormFieldWidget(
                    parameters: StreetNameParameters(controller: context.read<LogFormCubit>().streetNameController),
                  ),
                  TextFormFieldWidget(
                    parameters: LatitudeParameters(controller: context.read<LogFormCubit>().latitudeController),
                  ),
                  TextFormFieldWidget(
                    parameters: LongitudeParameters(controller: context.read<LogFormCubit>().longitudeController),
                  ),
                  const Expanded(child: ArchivesListViewWidget()),
                  TextButton(
                    onPressed: () async {
                      await context.read<LogFormCubit>().addArchive();
                    },
                    child: const Text('add')
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

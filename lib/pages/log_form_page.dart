import 'package:fire_hydrant_mapper/blocs/log_form_cubit/log_form_cubit.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:fire_hydrant_mapper/widgets/archives_list_view_widget.dart';
import 'package:fire_hydrant_mapper/widgets/form_app_bar.dart';
import 'package:fire_hydrant_mapper/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogFormPage extends StatelessWidget {
  final FireHydrantLogModel initialLog;
  const LogFormPage({Key? key, required this.initialLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocProvider<LogFormCubit>(
      create: (context) => LogFormCubit(
        initialLog: initialLog, firebaseService: RepositoryProvider.of<FirebaseService>(context)
      )..init(),
      child: BlocBuilder<LogFormCubit, LogFormState>(
        builder: (context, state) {
          return Scaffold(
            appBar: FormAppBarWidget(
              onDelete: () {
                context.read<LogFormCubit>().deleteLog();
                Navigator.of(context).pop();
              },
              onValidate: () {
                if (formKey.currentState!.validate()) {
                  context.read<LogFormCubit>().editLog();
                  Navigator.of(context).pop();
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
                  Expanded(child: ArchivesListViewWidget(parentLogId: initialLog.logId))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

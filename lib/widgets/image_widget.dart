import 'package:cached_network_image/cached_network_image.dart';
import 'package:fire_hydrant_mapper/blocs/archive_form_cubit/archive_form_cubit.dart';
import 'package:fire_hydrant_mapper/models/image_model.dart';
import 'package:fire_hydrant_mapper/widgets/squared_icon_button_widget.dart';
import 'package:fire_hydrant_mapper/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageWidget extends StatelessWidget {
  final ImageModel image;
  const ImageWidget({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          height: 150,
          width: 100,
          child: FutureBuilder<String>(
            future: context.read<ArchiveFormCubit>().getImageUrl(image),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: snapshot.data!,
                  placeholder: (context, error) => const LoadingWidget(),
                );
              }
              return const LoadingWidget();
            }
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SquaredIconButtonWidget(
            onTap: () {
              context.read<ArchiveFormCubit>().deleteImage(image);
            },
            icon: Icons.delete)
        )
      ],
    );
  }
}

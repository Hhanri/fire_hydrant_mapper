import 'package:fire_hydrant_mapper/main_bloc/main_bloc.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const CameraPosition initialCamera = CameraPosition(
      target: LatLng(48.88888737849572, 2.34311714079882),
      zoom: 12
    );

    //local temporary marker stream
    return StreamBuilder<FireHydrantLogModel?>(
      stream: context.read<MainBloc>().tempLogStream.stream,
      builder: (context, tempLog) {

        //server markers stream
        return StreamBuilder<List<FireHydrantLogModel>>(
          stream: context.read<MainBloc>().logsController.stream,
          builder: (context, serverLogs) {
            if (serverLogs.hasData) {
              return GoogleMap(
                markers: FireHydrantLogModel.getMarkers(
                  context: context, logs: [...serverLogs.data!, if (tempLog.hasData) tempLog.data!]
                ),
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  context.read<MainBloc>().add(LoadMapControllerEvent(controller: controller));
                },
                initialCameraPosition: initialCamera,
                onTap: (LatLng point) {
                  context.read<MainBloc>().add(AddTemporaryMarker(point: point));
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        );


      },
    );
  }
}

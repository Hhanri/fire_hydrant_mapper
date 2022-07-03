import 'package:fire_hydrant_mapper/main_bloc/main_bloc.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {

          if (state is MainInitializedState) {

            const CameraPosition initialCamera = CameraPosition(
                target: LatLng(48.88888737849572, 2.34311714079882),
                zoom: 12
            );

            return Stack(
              children: [
                StreamBuilder<List<FireHydrantLogModel>>(
                  stream: context.read<MainBloc>().logsController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("SNAPSHOT =  ${snapshot.data}");
                      return GoogleMap(
                        markers: FireHydrantLogModel.getMarkers(context: context, logs: snapshot.data!),
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          context.read<MainBloc>().add(LoadMapControllerEvent(controller: controller));
                        },
                        initialCameraPosition: initialCamera
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                ),
                Positioned(
                  bottom: 50,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<MainBloc>().add(AddPositionEvent(context: context));
                    },
                    child: const Text("add marker")
                  ),
                )
              ],
            );
          }
          return const Center(
            child: Text("Error"),
          );
        }
      ),
    );
  }
}
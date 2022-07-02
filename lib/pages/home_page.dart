import 'package:fire_hydrant_mapper/main_bloc/main_bloc.dart';
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

            final Set<Marker> markers = state.logs.map((log) {
              return Marker(
                markerId: MarkerId(LatLng(log.latitude, log.longitude).toString()),
                position: LatLng(log.latitude, log.longitude),
                infoWindow: InfoWindow(title: log.streetName)
              );
            }).toSet();

            return GoogleMap(
              markers: markers,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                context.read<MainBloc>().add(LoadMapControllerEvent(controller: controller));
              },
              initialCameraPosition: initialCamera
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
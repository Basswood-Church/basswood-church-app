import 'package:flutter/material.dart';
import '../../../utils/color_scheme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class LatLngMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  LatLngMap({
    Key key,
    this.latitude,
    this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN1,
      child: Card(
        color: MAIN1,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 400.0,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(latitude, longitude),
                zoom: 15,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    // Marker(
                    //   width: 80.0,
                    //   height: 80.0,
                    //   point: LatLng(36.0263899, -84.1492908),
                    //   builder: (ctx) => Container(
                    //     child: FlutterLogo(),
                    //   ),
                    // ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

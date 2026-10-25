
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const JalmitraApp());
}

class JalmitraApp extends StatelessWidget {
  const JalmitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jalmitra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const JalmitraHome(),
    );
  }
}

class JalmitraHome extends StatefulWidget {
  const JalmitraHome({super.key});

  @override
  State<JalmitraHome> createState() => _JalmitraHomeState();
}

class _JalmitraHomeState extends State<JalmitraHome> {
  static const LatLng waghala =
      LatLng(19.130057, 76.469843);

  final MapController mapController = MapController();

  int mapKey = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jalmitra - भूजल माहिती'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Column(
        children: [
          const ListTile(
            leading: Icon(
              Icons.water_drop,
              color: Colors.blue,
              size: 32,
            ),
            title: Text(
              'वाघाळा, तालुका पाथरी',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('जिल्हा परभणी, महाराष्ट्र'),
          ),

          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  key: ValueKey(mapKey),
                  mapController: mapController,
                  options: const MapOptions(
                    initialCenter: waghala,
                    initialZoom: 13,
                    minZoom: 3,
                    maxZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.example.jalmitra',
                      maxNativeZoom: 19,
                      errorTileCallback: (tile, error, stackTrace) {
                        debugPrint(
                          'नकाशा टाइल त्रुटी: $error',
                        );
                      },
                    ),

                    MarkerLayer(
                      markers: [
                        Marker(
                          point: waghala,
                          width: 130,
                          height: 75,
                          child: const Column(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    'वाघाळा',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),

                Positioned(
                  right: 12,
                  top: 12,
                  child: FloatingActionButton.small(
                    heroTag: 'myLocation',
                    tooltip: 'वाघाळा येथे जा',
                    onPressed: () {
                      mapController.move(waghala, 13);
                    },
                    child: const Icon(Icons.location_searching),
                  ),
                ),

                Positioned(
                  right: 12,
                  top: 62,
                  child: FloatingActionButton.small(
                    heroTag: 'refreshMap',
                    tooltip: 'नकाशा पुन्हा लोड करा',
                    onPressed: () {
                      setState(() {
                        mapKey++;
                      });
                    },
                    child: const Icon(Icons.refresh),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'हा सामान्य भौगोलिक नकाशा आहे. '
              'यावरून जमिनीखालील पाण्याची अचूक जागा '
              'किंवा विहिरीतील पाण्याची खात्री समजत नाही.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

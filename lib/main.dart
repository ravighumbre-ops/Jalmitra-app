
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

class JalmitraHome extends StatelessWidget {
  const JalmitraHome({super.key});

  static const LatLng waghala = LatLng(19.130057, 76.469843);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jalmitra - भूजल माहिती'),
      ),
      body: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.water_drop, color: Colors.blue),
            title: Text('वाघाळा, तालुका पाथरी'),
            subtitle: Text('जिल्हा परभणी, महाराष्ट्र'),
          ),
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: waghala,
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.jalmitra',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: waghala,
                      width: 120,
                      height: 80,
                      child: const Column(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                          Text(
                            'वाघाळा',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'सूचना: हा सामान्य भौगोलिक नकाशा आहे. '
              'यातून जमिनीखालील पाण्याची जागा किंवा '
              'विहिरीतील पाण्याची खात्री कळत नाही.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

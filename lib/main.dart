import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const JalmitraApp());
}

class JalmitraApp extends StatelessWidget {
  const JalmitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'जलमित्र',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
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

  LatLng? currentPosition;
  double? accuracy;
  bool loading = false;
  String message = 'आपले GPS स्थान पाहण्यासाठी बटण दाबा';

  Future<void> findMyLocation() async {
    if (loading) return;

    setState(() {
      loading = true;
      message = 'GPS स्थान शोधत आहे...';
    });

    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          message = 'मोबाईलचे Location चालू करा.';
        });
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          message = 'GPS वापरण्यासाठी Location परवानगी द्या.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 25),
        ),
      );

      if (!mounted) return;

      final point = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        currentPosition = point;
        accuracy = position.accuracy;
        message = 'GPS स्थान मिळाले.';
      });

      mapController.move(point, 16);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        message =
            'स्थान मिळाले नाही. GPS, परवानगी आणि सिग्नल तपासा.';
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void goToWaghala() {
    mapController.move(waghala, 13);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('जलमित्र - भूजल माहिती'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Column(
        children: [
          const ListTile(
            leading: Icon(
              Icons.water_drop,
              color: Colors.blue,
              size: 34,
            ),
            title: Text(
              'वाघाळा, तालुका पाथरी',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('जिल्हा परभणी, महाराष्ट्र'),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: loading ? null : findMyLocation,
                icon: const Icon(Icons.my_location),
                label: Text(
                  loading
                      ? 'स्थान शोधत आहे...'
                      : 'माझे GPS स्थान शोधा',
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),

          if (accuracy != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'GPS अचूकता: सुमारे ${accuracy!.round()} मीटर',
                style: const TextStyle(fontSize: 12),
              ),
            ),

          Expanded(
            child: FlutterMap(
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
                  userAgentPackageName: 'com.example.jalmitra',
                  maxNativeZoom: 19,
                ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: waghala,
                      width: 110,
                      height: 65,
                      child: const Column(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 36,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: Text(
                                'वाघाळा',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (currentPosition != null)
                      Marker(
                        point: currentPosition!,
                        width: 55,
                        height: 55,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 36,
                        ),
                      ),
                  ],
                ),

                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, color: Colors.red, size: 13),
                    SizedBox(width: 4),
                    Text('वाघाळा'),
                    SizedBox(width: 14),
                    Icon(Icons.circle, color: Colors.blue, size: 13),
                    SizedBox(width: 4),
                    Text('आपले GPS स्थान'),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: goToWaghala,
                  icon: const Icon(Icons.location_searching),
                  label: const Text('वाघाळा नकाशावर दाखवा'),
                ),
                const Text(
                  'भूजल संभाव्यता डेटा अजून जोडलेला नाही. '
                  'GPS किंवा सामान्य नकाशा जमिनीखालील पाण्याची '
                  'खात्री देत नाही.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


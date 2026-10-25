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
      title: 'जलमित्र',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const JalmitraHomePage(),
    );
  }
}

class JalmitraHomePage extends StatefulWidget {
  const JalmitraHomePage({super.key});

  @override
  State<JalmitraHomePage> createState() =>
      _JalmitraHomePageState();
}

class _JalmitraHomePageState extends State<JalmitraHomePage> {
  final MapController mapController = MapController();

  // वाघाळा, तालुका पाथरी, जिल्हा परभणी
  final LatLng villageLocation =
      LatLng(19.130057, 76.469843);

  int selectedIndex = 0;

  Widget buildHomePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'नमस्कार! जलमित्रमध्ये आपले स्वागत आहे',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'भूजल, विहीर आणि बोअरवेल यांची माहिती एका ठिकाणी.',
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.water_drop,
              color: Colors.blue,
              size: 36,
            ),
            title: const Text('भूजल माहिती'),
            subtitle: const Text(
              'भूजल पातळी व उपलब्ध अधिकृत माहिती तपासा.',
            ),
            onTap: () {
              setState(() => selectedIndex = 1);
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.water,
              color: Colors.teal,
              size: 36,
            ),
            title: const Text('विहीर आणि बोअरवेल मार्गदर्शन'),
            subtitle: const Text(
              'विहीर, बोअरवेल आणि पाणी व्यवस्थापनाची माहिती.',
            ),
            onTap: () {
              setState(() => selectedIndex = 2);
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.map,
              color: Colors.green,
              size: 36,
            ),
            title: const Text('भूजल नकाशा'),
            subtitle: const Text(
              'वाघाळा परिसराचा नकाशा उघडा.',
            ),
            onTap: () {
              setState(() => selectedIndex = 3);
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'महत्त्वाची सूचना: नकाशा हा परिसर दाखवतो. '
          'तो प्रत्यक्ष भूजल पातळी किंवा बोअरवेलमध्ये '
          'पाणी लागण्याची खात्री देत नाही.',
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget buildGroundwaterPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'भूजल माहिती',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: ListTile(
            leading: Icon(
              Icons.water_drop,
              color: Colors.blue,
            ),
            title: Text('भूजल पातळी'),
            subtitle: Text(
              'या ठिकाणाची मोजलेली अधिकृत पातळी '
              'अद्याप जोडलेली नाही.',
            ),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.public, color: Colors.green),
            title: Text('अधिकृत भूजल माहिती'),
            subtitle: Text(
              'CGWB आणि महाराष्ट्र भूजल सर्वेक्षण '
              'विकास यंत्रणेच्या उपलब्ध नोंदी तपासा.',
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'टीप: प्रत्यक्ष सरकारी डेटा/API जोडल्याशिवाय '
          'या अ‍ॅपमध्ये सध्याची भूजल पातळी किंवा '
          'भूजल संभाव्यता उपलब्ध होणार नाही.',
        ),
      ],
    );
  }

  Widget buildWellPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'विहीर आणि बोअरवेल मार्गदर्शन',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: ListTile(
            leading: Icon(Icons.water, color: Colors.blue),
            title: Text('विहीर'),
            subtitle: Text(
              'विहिरीची खोली, पाण्याची पातळी आणि '
              'हंगामानुसार होणारे बदल नोंदवा.',
            ),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.vertical_align_bottom),
            title: Text('बोअरवेल'),
            subtitle: Text(
              'बोअरवेल करण्यापूर्वी भूवैज्ञानिक '
              'सर्वेक्षण आणि तज्ज्ञांचा सल्ला घ्या.',
            ),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.eco, color: Colors.green),
            title: Text('पाणी पुनर्भरण'),
            subtitle: Text(
              'पावसाचे पाणी साठवणे आणि '
              'பூजल पुनर्भरणासाठी योग्य उपाय करा.',
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMapPage() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'वाघाळा परिसराचा नकाशा',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: villageLocation,
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
                    point: villageLocation,
                    width: 150,
                    height: 70,
                    child: const Column(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 38,
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomePage(),
      buildGroundwaterPage(),
      buildWellPage(),
      buildMapPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('जलमित्र'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'होम',
          ),
          NavigationDestination(
            icon: Icon(Icons.water_drop),
            label: 'भूजल',
          ),
          NavigationDestination(
            icon: Icon(Icons.water),
            label: 'विहीर',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'नकाशा',
          ),
        ],
      ),
    );
  }
}

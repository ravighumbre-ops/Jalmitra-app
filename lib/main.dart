import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

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

class _JalmitraHomePageState
    extends State<JalmitraHomePage> {
  int selectedIndex = 0;
  bool loading = false;
  String status = 'अधिकृत डेटासेट अजून तपासलेला नाही.';
  List<String> records = [];

  final LatLng villageLocation =
      const LatLng(19.130057, 76.469843);

  // राष्ट्रीय जल डेटा पोर्टलवरील महाराष्ट्राचा CSV डेटासेट.
  // हा ऐतिहासिक डेटासेट आहे; आजची पातळी समजू नये.
  static const String csvUrl =
      'https://nwdp.nwic.gov.in/dataset/'
      '85bb464f-bcd5-440b-be2c-fadb2725df4c/resource/'
      '817c6429-5853-4198-99e1-20ddf3d9f3bc/download/'
      'gwl_tel_6_hourly_maharashtra-gw_mh_1991_2020.csv';

  Future<void> loadGroundwaterData() async {
    setState(() {
      loading = true;
      status = 'अधिकृत CSV डेटा डाउनलोड होत आहे...';
      records = [];
    });

    try {
      final response = await http
          .get(Uri.parse(csvUrl))
          .timeout(const Duration(seconds: 45));

      if (response.statusCode != 200) {
        throw Exception(
          'सरकारी सर्व्हर प्रतिसाद: ${response.statusCode}',
        );
      }

      // CSV मध्ये शोधण्यासाठी गाव/तालुका/जिल्ह्याचे नाव.
      final lines = response.body
          .replaceFirst('\uFEFF', '')
          .split(RegExp(r'\r?\n'))
          .where((line) => line.trim().isNotEmpty)
          .toList();

      if (lines.isEmpty) {
        throw Exception('CSV फाइल रिकामी आहे.');
      }

      final keywords = [
        'waghala',
        'pathri',
        'parbhani',
        'वाघाळा',
        'पाथरी',
        'परभणी',
      ];

      final matches = <String>[];

      // पहिली ओळ बहुधा CSV शीर्षके असतात.
      // त्या ओळीला नोंद म्हणून दाखवू नये.
      for (final line in lines.skip(1)) {
        final lower = line.toLowerCase();

        if (keywords.any((word) => lower.contains(word))) {
          matches.add(line);
          if (matches.length >= 30) break;
        }
      }

      if (!mounted) return;

      setState(() {
        records = matches;
        status = matches.isEmpty
            ? 'CSV डाउनलोड झाला; पण वाघाळा, पाथरी किंवा '
                'परभणी नावाची नोंद या शोधात सापडली नाही. '
                'याचा अर्थ त्या भागात भूजल नाही असा होत नाही.'
            : 'संबंधित मजकूर असलेल्या ${matches.length} '
                'नोंदी सापडल्या. खाली मूळ CSV नोंदी पहा.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        status = 'डेटा मिळवता आला नाही: $e\n\n'
            'इंटरनेट, सरकारी सर्व्हर किंवा डेटासेटचा '
            'दुवा तपासा.';
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Widget buildHomePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'जलमित्रमध्ये आपले स्वागत आहे',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'वाघाळा, तालुका पाथरी, जिल्हा परभणी',
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.water_drop,
              color: Colors.blue,
              size: 36,
            ),
            title: const Text('अधिकृत भूजल माहिती'),
            subtitle: const Text(
              'सरकारी CSV डेटासेटमधील नोंदी शोधा.',
            ),
            onTap: () {
              setState(() => selectedIndex = 1);
              loadGroundwaterData();
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
            title: const Text('विहीर आणि बोअरवेल'),
            subtitle: const Text(
              'पाणी शोधण्यापूर्वी सर्वेक्षणाचे मार्गदर्शन.',
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
            subtitle: const Text('वाघाळा परिसर पाहा.'),
            onTap: () {
              setState(() => selectedIndex = 3);
            },
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'सूचना: नकाशा किंवा ऐतिहासिक नोंदी '
          'बोअरवेलमध्ये पाणी लागण्याची खात्री देत नाहीत.',
        ),
      ],
    );
  }

  Widget buildGroundwaterPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'अधिकृत भूजल डेटा',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'स्रोत: National Water Data Portal / '
          'महाराष्ट्र भूजल विभाग',
        ),
        const SizedBox(height: 8),
        const Text(
          'डेटासेट कालावधी: 1991–2020. '
          'हा वर्तमान भूजल अहवाल नाही.',
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: loading ? null : loadGroundwaterData,
          icon: const Icon(Icons.download),
          label: Text(
            loading ? 'डेटा डाउनलोड होत आहे...' : 'सरकारी डेटा तपासा',
          ),
        ),
        const SizedBox(height: 16),
        if (loading)
          const Center(child: CircularProgressIndicator()),
        SelectableText(status),
        const SizedBox(height: 16),
        if (records.isNotEmpty)
          const Text(
            'मूळ CSV नोंदी',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        for (int i = 0; i < records.length; i++)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SelectableText(records[i]),
            ),
          ),
        const SizedBox(height: 12),
        const Text(
          'नोंदींमध्ये गावाचे नाव नसल्यास जवळच्या '
          'निरीक्षण केंद्राचा डेटा आपोआप तुमच्या '
          'गावाचा डेटा मानला जाणार नाही.',
        ),
      ],
    );
  }

  Widget buildWellPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text(
          'विहीर आणि बोअरवेल मार्गदर्शन',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: Icon(Icons.water, color: Colors.blue),
            title: Text('विहीर'),
            subtitle: Text(
              'வिहिरीची खोली, पाण्याची पातळी आणि '
              'हंगामानुसार बदल नोंदवा.',
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.vertical_align_bottom),
            title: Text('बोअरवेल'),
            subtitle: Text(
              'बोअरवेलपूर्वी भूवैज्ञानिक सर्वेक्षण '
              'आणि तज्ज्ञांचा सल्ला घ्या.',
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.eco, color: Colors.green),
            title: Text('पाणी पुनर्भरण'),
            subtitle: Text(
              'पावसाचे पाणी साठवणे आणि भूजल पुनर्भरण '
              'यासाठी योग्य उपाय करा.',
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
                    width: 120,
                    height: 65,
                    child: const Column(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 36,
                        ),
                        Text(
                          'वाघाळा',
                          style: TextStyle(
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
          if (index == 1 && records.isEmpty && !loading) {
            loadGroundwaterData();
          }
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

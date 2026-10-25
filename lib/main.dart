import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int page = 0;

  static const LatLng village =
      LatLng(19.130057, 76.469843);

  // अधिकृत स्रोत
  static final Uri gsdaUrl = Uri.parse(
    'https://gsda.maharashtra.gov.in/en-dashboard/',
  );

  static final Uri nwdpUrl = Uri.parse(
    'https://nwdp.nwic.gov.in/en/dataset/'
    'ground-water-level-manual-monthly-'
    'maharashtra-ground-water-department',
  );

  static final Uri aquiferReportUrl = Uri.parse(
    'https://cgwb.gov.in/cgwbpnm/publication-detail/1601',
  );

  Future<void> openOfficialSource(Uri url) async {
    try {
      final opened = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('दुवा उघडता आला नाही. पुन्हा प्रयत्न करा.'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('इंटरनेट कनेक्शन तपासा.'),
        ),
      );
    }
  }

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'जलमित्र',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'वाघाळा, तालुका पाथरी, जिल्हा परभणी',
        ),
        const SizedBox(height: 16),
        featureCard(
          Icons.water_drop,
          'सरकारी निरीक्षण केंद्रे',
          'उपलब्ध सरकारी भूजल नोंदी तपासा.',
          () => setState(() => page = 1),
        ),
        featureCard(
          Icons.layers,
          'भूजल संभाव्यता',
          'भूजल अहवाल आणि संभाव्य क्षेत्रांची माहिती.',
          () => setState(() => page = 2),
        ),
        featureCard(
          Icons.map,
          'परिसराचा नकाशा',
          'वाघाळ्याचे स्थान आणि नकाशा पाहा.',
          () => setState(() => page = 3),
        ),
        const SizedBox(height: 12),
        const Text(
          'सूचना: नकाशा किंवा जवळच्या विहिरीची पातळी '
          'वाघाळ्यातील भूजल पातळी समजू नये.',
        ),
      ],
    );
  }

  Widget featureCard(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback action,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 34, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: action,
      ),
    );
  }

  Widget monitoringPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'सरकारी भूजल निरीक्षण केंद्रे',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              'वाघाळ्यातील स्वतंत्र निरीक्षण केंद्राची '
              'नोंद सध्या या अ‍ॅपमध्ये जोडलेली नाही. '
              'म्हणून कोणतीही बनावट भूजल पातळी दाखवली '
              'जात नाही.',
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => openOfficialSource(nwdpUrl),
          icon: const Icon(Icons.open_in_browser),
          label: const Text('सरकारी मासिक भूजल नोंदी'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => openOfficialSource(gsdaUrl),
          icon: const Icon(Icons.public),
          label: const Text('महाराष्ट्र GSDA डॅशबोर्ड'),
        ),
        const SizedBox(height: 16),
        const Text(
          'डेटा मिळाल्यावर नोंदवायची माहिती:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const ListTile(
          leading: Icon(Icons.location_on),
          title: Text('निरीक्षण केंद्राचे नाव आणि स्थान'),
        ),
        const ListTile(
          leading: Icon(Icons.calendar_month),
          title: Text('मोजमापाची तारीख'),
        ),
        const ListTile(
          leading: Icon(Icons.water_drop),
          title: Text('जमिनीखालील पाण्याची खोली (मीटर)'),
        ),
        const Text(
          'ही माहिती प्रत्यक्ष सरकारी डेटासेटमधून '
          'पडताळल्यानंतरच अ‍ॅपमध्ये दाखवावी.',
        ),
      ],
    );
  }

  Widget potentialPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'भूजल संभाव्यता नकाशा',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              'वाघाळ्यासाठी सत्यापित GIS संभाव्यता स्तर '
              'अद्याप या अ‍ॅपमध्ये जोडलेला नाही. '
              'खालील अधिकृत जिल्हा अहवालातून '
              'भूगर्भरचना आणि भूजल व्यवस्थापनाची '
              'माहिती तपासता येईल.',
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: () => openOfficialSource(aquiferReportUrl),
          icon: const Icon(Icons.description),
          label: const Text('परभणी जिल्हा भूजल अहवाल'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => openOfficialSource(gsdaUrl),
          icon: const Icon(Icons.map),
          label: const Text('GSDA भूजल नकाशे'),
        ),
        const SizedBox(height: 16),
        const Text(
          'संभाव्यता ठरवताना खडकांचा प्रकार, भेगा, '
          'भूगर्भरचना, उतार आणि पाणी पुनर्भरण '
          'यांचा अभ्यास आवश्यक आहे.',
        ),
        const SizedBox(height: 12),
        const Text(
          'எச்சரிக்கை: हा विभाग अद्याप உண்மையான '
          'GIS தரவை காட்டவில்லை.',
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  Widget mapPage() {
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
            options: const MapOptions(
              initialCenter: village,
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
                    point: village,
                    width: 110,
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
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'हा भौगोलिक नकाशा आहे; भूजल संभाव्यता स्तर नाही.',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      monitoringPage(),
      potentialPage(),
      mapPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('जलमित्र'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: IndexedStack(
        index: page,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (index) {
          setState(() => page = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'होम',
          ),
          NavigationDestination(
            icon: Icon(Icons.water_drop),
            label: 'निरीक्षण',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers),
            label: 'संभाव्यता',
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

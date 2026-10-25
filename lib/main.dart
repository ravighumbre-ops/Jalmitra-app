
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const JalmitraHome(),
    );
  }
}

class JalmitraHome extends StatelessWidget {
  const JalmitraHome({super.key});

  static const LatLng waghala = LatLng(19.130057, 76.469843);

  Future<void> openWebsite(String url) async {
    final uri = Uri.parse(url);
    final success = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!success) {
      debugPrint('वेबसाइट उघडता आली नाही: $url');
    }
  }

  Widget sourceButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => openWebsite(url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('जलमित्र - भूजल मार्गदर्शन'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'नमस्कार! जलमित्रमध्ये स्वागत आहे',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'विहीर, बोअरवेल, सरकारी भूजल माहिती '
                    'आणि भूजल नकाशांसाठी मार्गदर्शन.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'तुमचे गाव: वाघाळा, तालुका पाथरी, जिल्हा परभणी',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
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
                        width: 150,
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
          ),

          const SizedBox(height: 16),
          const Text(
            'सरकारी भूजल माहिती',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          sourceButton(
            context: context,
            icon: Icons.water_drop,
            title: 'GSDA - भूजल पाणीपातळी',
            subtitle: 'महाराष्ट्र शासनाची भूजल निरीक्षण माहिती',
            url:
                'https://gsda.maharashtra.gov.in/भूजल-पाणी-पातळी/',
          ),

          sourceButton(
            context: context,
            icon: Icons.location_searching,
            title: 'GSDA - भूजल सर्वेक्षण',
            subtitle: 'गावनिहाय भूजल व भूशास्त्रीय नकाशांची माहिती',
            url:
                'https://gsda.maharashtra.gov.in/विस्तृत-भूजल-सर्वेक्षण/',
          ),

          sourceButton(
            context: context,
            icon: Icons.map,
            title: 'MRSAC - भूजल GIS नकाशे',
            subtitle: 'महाराष्ट्राचे भूस्थानिक नकाशे व GIS सेवा',
            url:
                'https://portal.mrsac.org.in/gp/rest/services/mahagsda',
          ),

          sourceButton(
            context: context,
            icon: Icons.public,
            title: 'CGWB - परभणी जिल्हा भूजल अहवाल',
            subtitle: 'Aquifer Maps and Ground Water Management Plan',
            url:
                'https://cgwb.gov.in/cgwbpnm/publication-detail/1601',
          ),

          sourceButton(
            context: context,
            icon: Icons.analytics,
            title: 'GSDA - भूजल संसाधन अंदाज',
            subtitle: 'तालुकानिहाय व राज्यस्तरीय भूजल मूल्यांकन',
            url:
                'https://gsda.maharashtra.gov.in/en-groundwater-resource-estimation/',
          ),

          const SizedBox(height: 12),
          Card(
            color: Colors.orange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'महत्त्वाची सूचना:\n'
                'नकाशावरील लाल खूण ही वाघाळा गावाचे स्थान आहे; '
                'ती सरकारी निरीक्षण विहीर नाही. '
                'सरकारी वेबसाइट उघडल्यावर उपलब्ध माहिती तपासा. '
                'या आवृत्तीत प्रत्यक्ष केंद्रांची पाणीपातळी '
                'आपोआप डाउनलोड होत नाही आणि भूजल संभाव्यता '
                'GIS थर मुख्य नकाशावर अद्याप दाखवलेला नाही. '
                'विहीर किंवा बोअरवेलसाठी जागा ठरवण्यापूर्वी '
                'स्थानिक भूजल तज्ज्ञांचा सल्ला घ्या.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

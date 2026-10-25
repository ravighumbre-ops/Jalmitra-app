
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
      Card(
        child: ListTile(
          leading: const Icon(
            Icons.water,
            color: Colors.blue,
            size: 36,
          ),
          title: const Text('खुली विहीर'),
          subtitle: const Text(
            'भूगर्भीय रचना, पाण्याची पातळी आणि जवळच्या विहिरी तपासा.',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            setState(() => page = 0);
          },
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(
            Icons.vertical_align_bottom,
            color: Colors.teal,
            size: 36,
          ),
          title: const Text('बोअरवेल / कूपनलिका'),
          subtitle: const Text(
            'खडकातील भेगा, भूवैज्ञानिक सर्वेक्षण आणि जवळच्या बोअरवेलची माहिती तपासा.',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            setState(() => page = 0);
            locationMessage =
                'बोअरवेलसाठी नकाशावर योग्य ठिकाण निवडा.';
          },
        ),
      ),
      const SizedBox(height: 12),
      const Card(
        child: ListTile(
          leading: Icon(Icons.fact_check),
          title: Text('बोअरवेलपूर्वी तपासणी'),
          subtitle: Text(
            '१. जवळच्या बोअरवेलची खोली आणि पाण्याची स्थिती नोंदवा.\n'
            '२. खडकाचा प्रकार आणि भेगा तज्ज्ञांकडून तपासून घ्या.\n'
            '३. स्थानिक नियम आणि आवश्यक परवानग्या तपासा.',
          ),
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'सूचना: हा मार्गदर्शक आहे. पाणी लागण्याची खोली किंवा '
        'पाण्याचे प्रमाण मोजले जात नाही.',
        style: TextStyle(color: Colors.red),
      ),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: () {
          setState(() => page = 0);
        },
        icon: const Icon(Icons.map),
        label: const Text('नकाशावर बोअरवेलची जागा निवडा'),
      ),
    ],
  );
}

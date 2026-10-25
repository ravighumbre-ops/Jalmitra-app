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

      const SizedBox(height: 8),

      const Text(
        'जवळच्या भूजल माहितीच्या आधारे योग्य ठिकाणाची प्राथमिक तपासणी करा.',
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
            'जवळच्या विहिरींची खोली, पाण्याची पातळी, '
            'खडकाचा प्रकार आणि भूजल माहिती तपासा.',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            setState(() {
              page = 0;
              locationMessage =
                  'खुल्या विहिरीसाठी नकाशावर जागा निवडा.';
            });
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
            'खडकातील भेगा, भूवैज्ञानिक सर्वेक्षण, '
            'जवळच्या बोअरवेलची खोली आणि पाण्याची स्थिती तपासा.',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            setState(() {
              page = 0;
              locationMessage =
                  'बोअरवेलसाठी नकाशावर जागा निवडा. '
                  'पाणी लागण्याची हमी उपलब्ध नाही.';
            });
          },
        ),
      ),

      const SizedBox(height: 12),

      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.fact_check, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'बोअरवेलपूर्वी तपासणी',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ...[
                'जवळच्या विहिरी व बोअरवेलची खोली नोंदवा.',
                'उन्हाळ्यातील पाण्याची स्थिती तपासा.',
                'खडकाचा प्रकार आणि भेगा तज्ज्ञांकडून तपासून घ्या.',
                'अधिकृत भूजल नकाशा व उपलब्ध सर्वेक्षण तपासा.',
                'स्थानिक नियम आणि आवश्यक परवानग्या तपासा.',
              ].map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 12),

      Card(
        color: Colors.orange.withAlpha(25),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.deepOrange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'महत्त्वाची सूचना: नकाशा किंवा भूजल संभाव्यता '
                  'माहितीवरून पाणी लागण्याची अचूक खोली किंवा '
                  'प्रमाण निश्चित होत नाही. प्रत्यक्ष जागेची '
                  'तपासणी तज्ज्ञांकडून करून घ्या.',
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 16),

      FilledButton.icon(
        onPressed: () {
          setState(() {
            page = 0;
            locationMessage =
                'नकाशावर विहीर किंवा बोअरवेलसाठी '
                'तपासायची जागा निवडा.';
          });
        },
        icon: const Icon(Icons.map),
        label: const Text('नकाशावर जागा निवडा'),
      ),
    ],
  );
}

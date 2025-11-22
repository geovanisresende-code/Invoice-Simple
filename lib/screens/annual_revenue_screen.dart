import 'package:flutter/material.dart';
import 'upload_logo_screen.dart';

class AnnualRevenueScreen extends StatefulWidget {
  const AnnualRevenueScreen({Key? key}) : super(key: key);

  @override
  State<AnnualRevenueScreen> createState() => _AnnualRevenueScreenState();
}

class _AnnualRevenueScreenState extends State<AnnualRevenueScreen> {
  String? selectedRevenue;
  String selectedCurrency = 'Other (USD Equivalent)';

  final List<String> currencies = [
    'United States Dollars (USD)',
    'British Pounds (GBP)',
    'Australian Dollars (AUD)',
    'Canadian Dollars (CAD)',
    'Euros (EUR)'
  ];

  final List<String> revenues = [
    '< \$5,000',
    '\$5,000 - \$10,000',
    '\$10,000 - \$50,000',
    '\$50,000 - \$100,000',
    '\$100,000 - \$250,000',
    '\$250,000+',
    'Prefer not to answer'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'What is the annual revenue of your business?',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Revenue Currency',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () async {
                String? currency = await showModalBottomSheet<String>(
                  context: context,
                  builder: (context) {
                    return ListView(
                      children: currencies.map((c) {
                        return ListTile(
                          title: Text(c),
                          onTap: () => Navigator.pop(context, c),
                        );
                      }).toList(),
                    );
                  },
                );
                if (currency != null) {
                  setState(() {
                    selectedCurrency = currency;
                  });
                }
              },
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedCurrency,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: revenues.map((rev) {
                bool isSelected = selectedRevenue == rev;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRevenue = rev;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEFEAE7) : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFA5424) : Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFFA5424),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 15),
                        Text(rev, style: const TextStyle(fontSize: 16, color: Colors.black)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF94a3b9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadLogoScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

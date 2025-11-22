import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'business_size_screen.dart';

class BusinessDetailScreen extends StatefulWidget {
  const BusinessDetailScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String city = '';
  bool isLoading = false;

  Map<String, String> selectedCountry = {
    'abbr': 'BR',
    'name': 'Brazil',
    'ddi': '+55',
    'example': '(11) 96123-4567'
  };

  final List<Map<String, String>> countries = [
    {'abbr': 'BR', 'name': 'Brazil', 'ddi': '+55', 'example': '(11) 96123-4567'},
    {'abbr': 'US', 'name': 'United States', 'ddi': '+1', 'example': '(213) 555-1234'},
    {'abbr': 'UK', 'name': 'United Kingdom', 'ddi': '+44', 'example': '07123 456789'},
    {'abbr': 'PT', 'name': 'Portugal', 'ddi': '+351', 'example': '912 345 678'},
  ];

  final List<Map<String, String>> addressData = [
    {'address': 'Av. Paulista 1000', 'city': 'São Paulo', 'country': 'Brazil'},
    {'address': 'Rua XV de Novembro 350', 'city': 'Curitiba', 'country': 'Brazil'},
    {'address': 'Praça da Sé 50', 'city': 'São Paulo', 'country': 'Brazil'},
    {'address': 'Rua das Flores 200', 'city': 'Curitiba', 'country': 'Brazil'},
  ];

  final List<String> industrySuggestions = [
    'Architecture',
    'Technology',
    'Retail',
    'Consulting',
    'Healthcare',
    'Finance',
  ];

  List<Map<String, String>> filteredAddresses = [];
  List<String> filteredIndustries = [];

  void _filterAddress(String query) {
    setState(() {
      filteredAddresses = addressData
          .where((a) => a['address']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _filterIndustry(String query) {
    setState(() {
      filteredIndustries = industrySuggestions
          .where((i) => i.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    });
  }

  void _selectCountry() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: countries.map((c) {
            return ListTile(
              title: Text('${c['abbr']} - ${c['name']}'),
              onTap: () {
                setState(() {
                  selectedCountry = c;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _saveBusinessDetails() async {
    final String name = businessNameController.text.trim();
    final String address = addressController.text.trim();
    final String phone = phoneController.text.trim();
    final String industry = industryController.text.trim();

    if (name.isEmpty || address.isEmpty || phone.isEmpty || industry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'businessName': name,
        'address': address,
        'city': city,
        'country': selectedCountry['name'],
        'phone': phone,
        'industry': industry,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BusinessSizeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving business info: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Business Detail', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Information collected will be used for your invoices, and can be edited later.',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Business name
            const Text('Business Name*', style: TextStyle(fontSize: 14)),
            TextField(
              controller: businessNameController,
              decoration: InputDecoration(
                hintText: 'Enter your business name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            // Address
            const Text('Address*', style: TextStyle(fontSize: 14)),
            TextField(
              controller: addressController,
              onChanged: _filterAddress,
              decoration: InputDecoration(
                hintText: 'Type street name...',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            if (filteredAddresses.isNotEmpty)
              ...filteredAddresses.map((a) => ListTile(
                    title: Text(a['address']!),
                    subtitle: Text('${a['city']!}, ${a['country']!}'),
                    onTap: () {
                      setState(() {
                        addressController.text = a['address']!;
                        city = a['city']!;
                        filteredAddresses.clear();
                      });
                    },
                  )),
            if (city.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 5),
                child: Text(
                  '📍 $city, ${selectedCountry['name']}',
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ),
            const SizedBox(height: 15),

            // Phone number
            const Text('Phone Number*', style: TextStyle(fontSize: 14)),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: selectedCountry['example'],
                prefixIcon: InkWell(
                  onTap: _selectCountry,
                  child: Container(
                    width: 85,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(selectedCountry['abbr']!, style: const TextStyle(fontSize: 16)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            // Industry
            const Text('Industry*', style: TextStyle(fontSize: 14)),
            TextField(
              controller: industryController,
              onChanged: _filterIndustry,
              decoration: InputDecoration(
                hintText: 'Type industry name...',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            if (filteredIndustries.isNotEmpty)
              ...filteredIndustries.map((i) => ListTile(
                    title: Text(i),
                    onTap: () {
                      setState(() {
                        industryController.text = i;
                        filteredIndustries.clear();
                      });
                    },
                  )),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF94a3b9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: isLoading ? null : _saveBusinessDetails,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }
}

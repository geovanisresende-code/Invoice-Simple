import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool receiveEmails = false;
  String selectedCountry = 'Brazil';
  bool isLoading = false;
  bool emailError = false;
  bool passwordError = false;

  final List<String> countries = [
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola',
    'Argentina', 'Australia', 'Austria', 'Brazil', 'Canada',
    'Chile', 'China', 'Colombia', 'Costa Rica', 'Croatia',
    'Cuba', 'Denmark', 'Dominican Republic', 'Ecuador', 'Egypt',
    'Finland', 'France', 'Germany', 'Greece', 'Hungary',
    'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland',
    'Israel', 'Italy', 'Japan', 'Kenya', 'Luxembourg',
    'Mexico', 'Netherlands', 'New Zealand', 'Norway', 'Pakistan',
    'Panama', 'Paraguay', 'Peru', 'Poland', 'Portugal',
    'Qatar', 'Romania', 'Russia', 'Saudi Arabia', 'South Africa',
    'South Korea', 'Spain', 'Sweden', 'Switzerland', 'Thailand',
    'Turkey', 'United Kingdom', 'United States', 'Uruguay', 'Venezuela'
  ];

  Future<void> _createAccount() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      emailError = email.isEmpty;
      passwordError = password.isEmpty;
    });

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'country': selectedCountry,
        'receiveEmails': receiveEmails,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/business_detail');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color focusColor = Color(0xFFF65522);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create an Account", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Location",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
              ),

              const SizedBox(height: 5),

             
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  value: selectedCountry,
                  items: countries
                      .map((e) =>
                          DropdownMenuItem<String>(value: e, child: Text(e)))
                      .toList(),

                  onChanged: (value) {
                    setState(() => selectedCountry = value!);
                  },

                  buttonStyleData: ButtonStyleData(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black26),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 250, 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),

                  menuItemStyleData: const MenuItemStyleData(
                    height: 42,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF94a3b9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading ? null : _createAccount,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Continue",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

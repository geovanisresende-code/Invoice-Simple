import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'all_set_screen.dart'; // ⬅️ importe a tela final
import 'select_template_screen.dart'; // ⬅️ importe a tela correta

class UploadLogoScreen extends StatefulWidget {
  const UploadLogoScreen({Key? key}) : super(key: key);

  @override
  State<UploadLogoScreen> createState() => _UploadLogoScreenState();
}

class _UploadLogoScreenState extends State<UploadLogoScreen> {
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _chooseImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
      await _uploadToFirebase(_selectedImage!);
    }
  }

  Future<void> _uploadToFirebase(File image) async {
    try {
      setState(() => _isUploading = true);

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref =
          FirebaseStorage.instance.ref().child('business_logos/$fileName.jpg');

      await ref.putFile(image);
      final downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('business_logos').add({
        'logoUrl': downloadUrl,
        'uploadedAt': Timestamp.now(),
      });

      setState(() => _isUploading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logo uploaded successfully!')),
      );
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Upload your business logo',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Make your invoice look professional and branded',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Retângulo da imagem
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_selectedImage!, fit: BoxFit.contain),
                    )
                  : const Center(
                      child: Icon(Icons.image_outlined,
                          color: Colors.grey, size: 60),
                    ),
            ),

            const Spacer(),

            // Botão Choose Image
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: _isUploading ? null : _chooseImage,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Choose Image',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),

            // Botão Continue
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF65522),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectTemplateScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

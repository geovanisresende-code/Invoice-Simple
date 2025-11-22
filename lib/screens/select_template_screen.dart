import 'package:flutter/material.dart';
import 'template_detail_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'all_set_screen.dart';

class SelectTemplateScreen extends StatefulWidget {
  const SelectTemplateScreen({Key? key}) : super(key: key);

  @override
  State<SelectTemplateScreen> createState() => _SelectTemplateScreenState();
}

class _SelectTemplateScreenState extends State<SelectTemplateScreen> {
  String selectedTemplate = "classic.pdf";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Select a template',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const Text(
              "Choose a template for your invoice",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // PDF preview box menor
            Container(
              width: 200, // largura menor
              height: 250, // altura menor
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SfPdfViewer.asset(
                  'assets/templates/$selectedTemplate',
                  pageSpacing: 0,
                  scrollDirection: PdfScrollDirection.vertical,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botão Change Template
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: () async {
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TemplateDetailScreen(
                        initialPdf: selectedTemplate,
                      ),
                    ),
                  );
                  if (result != null && result.isNotEmpty) {
                    setState(() {
                      selectedTemplate = result;
                    });
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                child: const Text(
                  "Change Template",
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AllSetScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF65522),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue",
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

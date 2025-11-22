import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TemplateDetailScreen extends StatefulWidget {
  final String initialPdf;
  const TemplateDetailScreen({Key? key, required this.initialPdf})
      : super(key: key);

  @override
  State<TemplateDetailScreen> createState() => _TemplateDetailScreenState();
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
  String selected = "";

  final List<Map<String, String>> templates = [
    {'name': 'Classic', 'file': 'classic.pdf'},
    {'name': 'Compact', 'file': 'compact.pdf'},
    {'name': 'Clean', 'file': 'clean.pdf'},
    {'name': 'Sharp', 'file': 'sharp.pdf'},
  ];

  @override
  void initState() {
    super.initState();
    selected = widget.initialPdf.isNotEmpty
        ? widget.initialPdf
        : templates[0]['file']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Choose Template",
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
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
                children: templates.map((t) {
                  final isSelected = selected == t['file'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = t['file']!;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isSelected ? Colors.orange : Colors.black,
                            width: isSelected ? 3 : 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: SfPdfViewer.asset(
                                'assets/templates/${t['file']}',
                                pageLayoutMode: PdfPageLayoutMode.single,
                                canShowScrollHead: false,
                                canShowScrollStatus: false,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            t['name']!,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selected);
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

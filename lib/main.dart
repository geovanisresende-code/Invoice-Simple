import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart'; 
import 'screens/welcome_screen.dart'; 
import 'screens/create_account_screen.dart';
import 'screens/business_detail_screen.dart';
import 'screens/business_size_screen.dart';
import 'screens/annual_revenue_screen.dart';
import 'screens/select_template_screen.dart';
import 'screens/upload_logo_screen.dart';
import 'screens/all_set_screen.dart';
import 'screens/template_detail_screen.dart'; // corrigido

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Invoice App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/create_account': (context) => CreateAccountScreen(),
        '/business_detail': (context) => BusinessDetailScreen(),
        '/business_size': (context) => BusinessSizeScreen(),
        '/annual_revenue': (context) => AnnualRevenueScreen(),
        '/select_template': (context) => SelectTemplateScreen(), 
        '/upload_logo': (context) => UploadLogoScreen(),
        '/all_set': (context) => AllSetScreen(),
        '/template_detail': (context) => TemplateDetailScreen(initialPdf: 'assets/templates/classic.pdf'),

      },
    );
  }
}

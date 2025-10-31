import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper_Widgets/cart_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_app/firebase_options.dart';
import 'package:shop_app/screens/homepage.dart';
import 'package:shop_app/screens/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'outfit',
          textTheme: TextTheme(
            titleLarge: TextStyle(
              color: Colors.grey,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(color: Colors.grey, fontSize: 30),
            titleSmall: TextStyle(color: Colors.grey, fontSize: 20),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.data != null) {
              return Homepage();
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}

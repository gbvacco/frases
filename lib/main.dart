import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // print(query);
    return FutureBuilder(
      // Initialize FlutterFire:
      future: getData(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // return SomethingWentWrong();
          return MaterialApp(
            title: 'Frases',
            home: Container(
              child: Text('Erro ao carregar o app!'),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Frases',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(
              frase: snapshot.data,
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        // return Loading();
        return MaterialApp(
          title: 'Frases',
          home: Container(
            child: Text('Carregando...'),
          ),
        );
      },
    );
  }

  Future<DocumentSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection('frases')
        .doc('UOJoWSeLfmEnOkCe4trB')
        .get();
  }
}

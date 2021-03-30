import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  DateTime date = DateTime.now();
  // String today = '${date.day}${date.month}${date.year}';
  String today = '2732021';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: getData(today),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'Frases',
            home: Scaffold(
              body: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/BG.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Parece que algo deu errado :(',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Se esse problema persitir entre em contato conosco através do e-mail: atendimento@realzero.com.br',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
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
              today: today,
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        // return Loading();
        return MaterialApp(
          title: 'Frases',
          home: Scaffold(
            body: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/BG.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Que bom te ver novamente ;)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<DocumentSnapshot> getData(String messageDate) async {
    await Firebase.initializeApp();

    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    _messaging.subscribeToTopic('all');
    _messaging.getToken().then((token) => print(token));

    return await FirebaseFirestore.instance
        .collection('frases')
        .doc(messageDate)
        .get();
  }
}

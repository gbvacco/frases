import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_cap_text/drop_cap_text.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.frase}) : super(key: key);

  final frase;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int qtdLike = 0;
  void initState() {
    qtdLike = widget.frase['likes'];
    super.initState();
  }

  void updateLikes(likes) {
    Map<String, dynamic> qtdLikes = {'likes': likes};
    FirebaseFirestore.instance
        .collection('frases')
        .doc('23032021')
        .update(qtdLikes);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dica'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Caso você queira ler o livro indicado, basta clicar sobre o ícone do livro ou sobre o texto e você será redirecionado para a página aonde você podera baixar ou comprar o livro.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Entendi'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bom dia!';
    }
    if (hour < 18) {
      return 'Boa tarde!';
    }
    return 'Boa noite!';
  }

  IconData icon() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return Icons.wb_sunny;
    }
    if (hour < 18) {
      return Icons.wb_twighlight;
    }
    return Icons.bedtime;
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/BG.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: [
                    Icon(
                      icon(),
                      color: Colors.greenAccent,
                      size: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        greeting(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 12.0),
              child: Column(
                children: [
                  Text(
                    widget.frase['frase'],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        Text(
                          'By ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white60,
                          ),
                        ),
                        Text(
                          widget.frase['autor'],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.greenAccent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 3.0, right: 1.0),
                          child: InkWell(
                            onTap: () => _launchInBrowser(
                                widget.frase['link_usuario_rede_social']),
                            child: Text(
                              widget.frase['usuario_rede_social'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.exit_to_app),
                          color: Colors.greenAccent,
                          onPressed: () {
                            _launchInBrowser(widget.frase['autor_url']);
                          },
                        ),
                        GestureDetector(
                          child: Badge(
                            badgeContent: Text(qtdLike.toString()),
                            badgeColor: Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.thumb_up_alt_rounded),
                              color: Colors.greenAccent,
                              onPressed: () {
                                setState(() {
                                  qtdLike++;
                                  updateLikes(qtdLike);
                                });
                              },
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              qtdLike++;
                              updateLikes(qtdLike);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(2.0),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  border: Border.all(
                    color: Colors.greenAccent,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () {
                      // _launchInBrowser(widget.frase['livro_url']);
                      _showMyDialog();
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            widget.frase['nome_livro'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Autor: ' + widget.frase['autor_livro'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropCapText(
                            widget.frase['resumo_livro'],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                            dropCap: DropCap(
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.book_outlined,
                                size: 100.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

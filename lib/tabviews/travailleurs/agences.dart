import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:kakwetu/page3.dart';
import 'package:kakwetu/servicepayement.dart';
import 'package:kakwetu/tabviews/travailleurs/ajouter.dart';
import 'package:http/http.dart' as http;
import '../../page4.dart';
import 'changer.dart';

class Agences extends StatefulWidget {
  final Langue l;
  final String numero;
  final int duree;
  Agences({Key key, this.l, this.numero, this.duree}) : super(key: key);

  @override
  _AgencesState createState() => _AgencesState();
}

class _AgencesState extends State<Agences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Kakwetu",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.yellow),
          ),
        ),
        body: Builder(builder: (context) {
          return OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                final bool connected = connectivity != ConnectivityResult.none;
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    child,
                    connected
                        ? Myform(
                            l: widget.l,
                            numero: widget.numero,
                            duree: widget.duree,
                          )
                        : Center(
                            child: widget.l.eng == 1
                                ? Text(
                                    "You are Offline",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 40),
                                    textAlign: TextAlign.center,
                                  )
                                : widget.l.fra == 1
                                    ? Text(
                                        "Connectez-Vous",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 40),
                                        textAlign: TextAlign.center,
                                      )
                                    : widget.l.swa == 1
                                        ? Text(
                                            "Fungua Internet",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 40),
                                            textAlign: TextAlign.center,
                                          )
                                        : Text(
                                            "Ugurura Enterineti",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 40),
                                            textAlign: TextAlign.center,
                                          ),
                          )
                  ],
                );
              },
              child: Text(""));
        }));
  }
}

//dedinition du formulaireq

class Myform extends StatefulWidget {
  final Langue l;
  final String numero;
  final int duree;
  Myform({Key key, this.l, this.numero, this.duree}) : super(key: key);

  @override
  _MyformState createState() => _MyformState();
}

class _MyformState extends State<Myform> {
  String numero = "";
  Timer _timer;
  StreamController<List> _streamcontroller = StreamController<List>();
  ScrollController _scrollcontroller = new ScrollController();
  @override
  void initState() {
    selectworkers();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      selectworkers();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    _streamcontroller.close();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  static _isolate(String body) {
    return jsonDecode(body);
  }

  selectworkers() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/gw/selectworkers.php",
          body: {"nro": widget.numero});
      var resultat = await compute(_isolate, response.body);
      setState(() {
        _streamcontroller.add(resultat);
      });
    } catch (e) {}
  }

  void deleteData(String name) {
    AlertDialog alerte = new AlertDialog(
      title: widget.l.fra == 1
          ? Text("Plus d'info...",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.underline),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("More About him...",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Maelezo Yake...",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                      textAlign: TextAlign.center)
                  : Text("Vyishi Kuriwe...",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                      textAlign: TextAlign.center),
      content: widget.l.fra == 1
          ? Text("Son Numero est: $name ",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("His Number Is: $name",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Nambari Yake Ni: $name ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      textAlign: TextAlign.center)
                  : Text(
                      "Inomero Yiwe Ni: $name ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            splashColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Page4(
                            l: widget.l,
                            isboss: 1,
                            controled: 1,
                            numero: numero,
                          )));
            },
            child: widget.l.fra == 1
                ? Text(
                    "Voir Cequ'il fait",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                    textAlign: TextAlign.center,
                  )
                : widget.l.eng == 1
                    ? Text("See What He Is doing",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                        textAlign: TextAlign.center)
                    : widget.l.swa == 1
                        ? Text("Kuona Vyenye Anafanya",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                            textAlign: TextAlign.center)
                        : Text("Kuraba ivyo Akora",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                            textAlign: TextAlign.center),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            splashColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Changer(
                            l: widget.l,
                            nro: widget.numero,
                            nrow: numero,
                          )));
            },
            child: widget.l.fra == 1
                ? Text("Le Changer",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                    textAlign: TextAlign.center)
                : widget.l.eng == 1
                    ? Text("Change him",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        textAlign: TextAlign.center)
                    : widget.l.swa == 1
                        ? Text("Kumubadilisha",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                            textAlign: TextAlign.center)
                        : Text("Kumuhindura",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                            textAlign: TextAlign.center),
          ),
        ),
        MaterialButton(
          splashColor: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          child: widget.l.fra == 1
              ? Text("Rien",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Nothing",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Hakuna Kitu",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                      : Text("Ntanakimwe",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alerte;
        });
    //return;
  }

  paspayemessage() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Votre paquet a expiré Vous Voulez payer encore",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Your Packet has Finished Do you want to pay once again ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Mfuko wako Umeisha unataka kulipa tena ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center)
                  : Text(
                      "Umutekero wanyu Waheze Mushaka kuriha kandi ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          splashColor: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          child: widget.l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Hapana",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                      : Text("Oya",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
        ),
        MaterialButton(
          splashColor: Colors.white,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Service(
                          l: widget.l,
                          numero: widget.numero,
                        )));
          },
          child: widget.l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alerte;
        });
    //return;
  }

  decrypterchaine(String value) {
    String chaine = "abcdefghi0123456789jklmnopkrstuvwxyz.";
    List<String> c = value.split(".");
    String d;
    int x;
    String n = "";
    for (int i = 0; i < c.length; i++) {
      try {
        x = (sqrt(sqrt(int.parse(c[i]) - (731)))).round();
        d = chaine[x];
      } catch (e) {
        if (chaine.contains(c[i])) {
          d = chaine.indexOf(c[i]).toString();
        } else {
          d = c[i];
        }
      }
      n += d;
    }
    return n;
  }

  changernumero(String value) {
    String chaine = "kdfabvxous";
    String numero = "";
    for (int i = 0; i < value.length; i++) {
      try {
        if (value[i] != ".") {
          numero = numero + chaine[int.parse(value[i])];
        } else {
          numero = numero + "@";
        }
      } catch (e) {}
    }
    return numero;
  }

  paspayemessageechec() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Desolé Il y a un probleme,Réessayez plus tard",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Sorry We have a problem,Retry Later",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Samahani Kuko Tatizo,utajaribu Tena",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center)
                  : Text(
                      "Muradutunga Hari ikibazo,Muragerageza hanyuma",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          splashColor: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          child: widget.l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alerte;
        });
    //return;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        StreamBuilder<List>(
            stream: _streamcontroller.stream,
            builder: (context, snap) {
              if (snap.hasError) {
              } else if (snap.hasData) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 160,
                      child: Column(
                        children: [
                          Expanded(
                              child: Scrollbar(
                            child: ListView.builder(
                                controller: _scrollcontroller,
                                physics: BouncingScrollPhysics(),
                                itemCount: snap.data.length,
                                itemBuilder: (context, i) {
                                  return InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      if (widget.duree >= 0) {
                                        deleteData(changernumero(
                                            decrypterchaine(
                                                snap.data[i]['nro_w'])));
                                        setState(() {
                                          numero = snap.data[i]['nro_w'];
                                        });
                                      } else {
                                        if (widget.duree != -1002) {
                                          paspayemessage();
                                        } else {
                                          paspayemessageechec();
                                        }
                                      }
                                    },
                                    child: Card(
                                      color: Colors.black45,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.lightBlue,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snap.data[i]['nom_w'],
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snap.data[i]['prenom_w'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 30,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: widget.l.fra == 1
                                                ? Text(
                                                    "Taper Pour Plus...",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : widget.l.eng == 1
                                                    ? Text(
                                                        "Tap To See More...",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    : widget.l.swa == 1
                                                        ? Text(
                                                            "Click Uone Mengi...",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        : Text(
                                                            "Vyonda Ubone Vyishi...",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                );
              }
              return null;
            }),
        Expanded(
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Ajouter(
                                      l: widget.l,
                                      numero: widget.numero,
                                    )));
                      },
                      child: Container(
                        width: 250,
                        height: 60,
                        color: Colors.lightBlueAccent,
                        alignment: Alignment.center,
                        child: widget.l.eng == 1
                            ? Text(
                                'New Worker',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            : widget.l.swa == 1
                                ? Text(
                                    'Mtumishi Wampya',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                : widget.l.fra == 1
                                    ? Text(
                                        'Nouveau travailleur',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        'Umukozi Mushasha',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(3),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black26, width: 5),
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            widget.l.fra == 1
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Si Vous Cliquez sur Un travaileur Soit Vous pouvez Voir Ceque il Fait Ou le Changer",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : widget.l.eng == 1
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "If You Click On A Worker You Can See What He's Doing Or Change him ",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : widget.l.swa == 1
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Ukibonyeza Kwenye jina La Mtumishi Unaweza kuona Vyenye Anafanya na unaweza Mufukuza Kazini",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Muhisemwo umukozi Murutonde,Mushobora Kubona Ivyo akora Canke Mukamuhindura",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                Icons.warning,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

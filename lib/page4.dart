import 'dart:convert';
import 'dart:async';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import 'package:kakwetu/servicepayement.dart';
import 'package:kakwetu/tabviews/argent.dart';
import 'package:kakwetu/tabviews/compte.dart';
import 'package:kakwetu/tabviews/depense.dart';
import 'package:kakwetu/tabviews/dette.dart';
import 'package:kakwetu/tabviews/probleme.dart';
import 'package:kakwetu/tabviews/rapport.dart';
import 'package:kakwetu/tabviews/stock.dart';
import 'package:kakwetu/tabviews/vendre.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'tabviews/travailleurs/agences.dart';
import 'tabviews/travailleurs/nostock.dart';
import 'tabviews/travailleurs/securite.dart';
import 'package:flutter/foundation.dart';

class Page4 extends StatefulWidget {
  final Langue l;
  final int isboss;
  final String numero;
  final String password;
  final int controled;
  Page4(
      {Key key,
      this.l,
      this.isboss,
      this.controled,
      this.numero,
      this.password})
      : super(key: key);

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
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
                        isboss: widget.isboss,
                        controled: widget.controled,
                        numero: widget.numero,
                        password: widget.password,
                      )
                    : Center(
                        child: widget.l.eng == 1
                            ? Text(
                                "You are Offline",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 40,
                                ),
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

class Myform extends StatefulWidget {
  final Langue l;
  final int isboss;
  final int controled;
  final String numero;
  final String password;
  Myform(
      {Key key,
      this.l,
      this.isboss,
      this.controled,
      this.numero,
      this.password})
      : super(key: key);

  @override
  _MyformState createState() => _MyformState();
}

class _MyformState extends State<Myform> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String w = "";
  int jours = 0;
  Timer _timer;
  @override
  void initState() {
    _tabController = new TabController(length: 7, vsync: this);
    payeoupaspaye();
    loginworker();
    etatjournal();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      payeoupaspaye();
      loginworker();
      etatjournal();
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  loginworker() async {
    try {
      final response = await http
          .post("https://kakwetuburundifafanini.com/lw/loginworker.php", body: {
        "nro_w": widget.numero,
        "pd": widget.password,
      });
      var resultat = jsonDecode(response.body);
      if (resultat.length == 0) {
        setState(() {
          w = "n";
        });
      } else {
        setState(() {
          w = "y";
        });
      }
    } catch (e) {
      setState(() {
        w = "";
      });
    }
  }

  payeoupaspaye() async {
    var url = "https://kakwetuburundifafanini.com/paye/payeoupaspaye.php";
    try {
      final response = await http.post(url, body: {
        "nro": widget.numero,
      });
      var resultat = jsonDecode(response.body);
      setState(() {
        jours = int.parse(resultat[0]['reste'].toString());
      });
    } catch (e) {
      setState(() {
        jours = -1002;
      });
      return;
    }
  }

  String journal = "0";
  etatjournal() async {
    var url = "https://kakwetuburundifafanini.com/paye/selectjournletat.php";
    try {
      final response =
          await http.post(url, body: {"nro": widget.numero, "etat": "1"});
      var resultat = jsonDecode(response.body);
      setState(() {
        journal = (resultat[0]['nombre']).toString();
      });
    } catch (e) {
      setState(() {
        journal = "0";
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 35.0,
        items: <Widget>[
          widget.l.eng == 1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Office",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : widget.l.fra == 1
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Office",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : widget.l.swa == 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Ofisi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Mubiro",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
          widget.controled == 0
              ? (widget.l.eng == 1
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : widget.l.fra == 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Compte",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : widget.l.swa == 1
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Akaunti",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Konte",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ))
              : null,
          widget.l.eng == 1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "pay",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : widget.l.fra == 1
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "payer",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : widget.l.swa == 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "lipa",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "riha",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
          widget.l.eng == 1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: journal == "0"
                      ? Text(
                          "security",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          "security" + journal,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                )
              : widget.l.fra == 1
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: journal == "0"
                          ? Text(
                              "sécurité",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "sécurité" + journal,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    )
                  : widget.l.swa == 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: journal == "0"
                              ? Text(
                                  "Usalama",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Usalama" + journal,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8),
                          child: journal == "0"
                              ? Text(
                                  "kwirinda",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "kwirinda" + journal,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
          widget.isboss == 1
              ? widget.controled == 0
                  ? (widget.l.eng == 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Workers",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : widget.l.fra == 1
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Travaleurs",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : widget.l.swa == 1
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Wafanyakazi",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "Abakozi",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ))
                  : null
              : null,
        ],
        color: Colors.black,
        buttonBackgroundColor: Colors.black,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        onTap: (index) {
          if (index == 1 && widget.controled == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Compte(
                          l: widget.l,
                          isboss: widget.isboss,
                          numero: widget.numero,
                          duree: jours,
                        )));
          } else if (index == 2) {
            if ((jours < 0) && (jours != -1002)) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Service(
                            l: widget.l,
                            numero: widget.numero,
                          )));
            } else {
              Fluttertoast.showToast(
                  msg: widget.l.fra == 1
                      ? "On va vous dire le jour de payement"
                      : widget.l.eng == 1
                          ? "We will inform you The day of paying"
                          : widget.l.swa == 1
                              ? "Siku yakulipa Tutakujulisha"
                              : "Nihagera kuriha tuzobibamenyesha",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG);
            }
          } else if (index == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Security(
                          l: widget.l,
                          numero: widget.numero,
                          isboss: widget.isboss,
                          controled: widget.controled,
                        )));
          } else if (index == 4 &&
              widget.isboss == 1 &&
              widget.controled == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Agences(
                          l: widget.l,
                          numero: widget.numero,
                          duree: jours,
                        )));
          }
        },
      ),
      appBar: new AppBar(
        actions: [
          //je veux mettre un variable qui provient dans la base de donnee
          widget.l.fra == 1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: jours >= 0
                      ? Text(
                          jours.toString() + " Jour(s)",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        )
                      : jours == -1002
                          ? Text("")
                          : Text(
                              "Aucun Jour",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                )
              : widget.l.eng == 1
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: jours >= 0
                          ? Text(
                              jours.toString() + " Day(s)",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )
                          : jours == -1002
                              ? Text("")
                              : Text(
                                  "No Day",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                    )
                  : widget.l.swa == 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: jours >= 0
                              ? Text(
                                  "Siku " + jours.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                )
                              : jours == -1002
                                  ? Text("")
                                  : Text(
                                      "Siku Zimeisha",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: jours >= 0
                              ? Text(
                                  "(U)Imisi " + jours.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                )
                              : jours == -1002
                                  ? Text("")
                                  : Text(
                                      "Imisi Yaheze",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                        ),
        ],
        title: new Text(
          "Kakwetu",
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.yellow),
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.redAccent,
          labelPadding: EdgeInsets.only(left: 8, right: 8),
          labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1,
              fontStyle: FontStyle.italic),
          tabs: [
            Tab(
              child: widget.l.fra == 1
                  ? Text("Vendre")
                  : widget.l.eng == 1
                      ? Text("Sale")
                      : widget.l.swa == 1
                          ? Text("Kuuza")
                          : Text("Gucuruza"),
            ),
            new Tab(
              child: widget.l.fra == 1
                  ? Text("Dettes")
                  : widget.l.eng == 1
                      ? Text("Debt")
                      : widget.l.swa == 1
                          ? Text("Deni")
                          : Text("Amadeni"),
            ),
            new Tab(
              child: widget.l.fra == 1
                  ? Text("Depenses")
                  : widget.l.eng == 1
                      ? Text("Spent")
                      : widget.l.swa == 1
                          ? Text("matumizi")
                          : Text("Nakoresheje"),
            ),
            new Tab(
              child: widget.l.fra == 1
                  ? Text("Rapport")
                  : widget.l.eng == 1
                      ? Text("Report")
                      : widget.l.swa == 1
                          ? Text("Ripoti")
                          : Text(
                              "Icegeranyo",
                            ),
            ),
            new Tab(
              child: widget.l.fra == 1
                  ? Text("Argent")
                  : widget.l.eng == 1
                      ? Text("Money")
                      : widget.l.swa == 1
                          ? Text("Pesa")
                          : Text("Amafaranga"),
            ),
            new Tab(
              child: widget.l.fra == 1
                  ? Text("Stock")
                  : widget.l.eng == 1
                      ? Text("Stock")
                      : widget.l.swa == 1
                          ? Text("Hisa")
                          : Text("Sitoke"),
            ),
            new Tab(
              child: widget.l.fra == 1
                  ? Text("Problemes")
                  : widget.l.eng == 1
                      ? Text("Problems")
                      : widget.l.swa == 1
                          ? Text("Matatizo")
                          : Text("Ibibazo"),
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.redAccent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 6,
        ),
        bottomOpacity: 1,
        backgroundColor: Colors.black,
      ),
      body: TabBarView(
        children: [
          widget.controled == 0
              ? new Vendre(
                  l: widget.l,
                  numero: widget.numero,
                  password: widget.password,
                  isboss: widget.isboss,
                  duree: jours,
                  worker: w,
                  controled: widget.controled,
                )
              : Center(
                  child: Column(
                    children: [
                      widget.l.eng == 1
                          ? Center(
                              child: Text(
                              "Welcome My Boss",
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              textAlign: TextAlign.center,
                            ))
                          : widget.l.fra == 1
                              ? Center(
                                  child: Text(
                                  "Bienvenue Mon Boss",
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ))
                              : widget.l.swa == 1
                                  ? Center(
                                      child: Text(
                                      "Karibu Boss Wangu",
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ))
                                  : Center(
                                      child: Text(
                                      "Murakaza Neza Boss Wanje",
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    )),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Nostock(
                                        l: widget.l,
                                        numero: widget.numero,
                                        duree: jours,
                                        isboss: widget.isboss,
                                        worker: w,
                                        controled: widget.controled,
                                      )));
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 5),
                            child: Container(
                                color: Colors.lightBlueAccent,
                                alignment: Alignment.center,
                                child: widget.l.eng == 1
                                    ? Text(
                                        'No stock',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : widget.l.swa == 1
                                        ? Text(
                                            'Hakuna hisa',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : widget.l.fra == 1
                                            ? Text(
                                                'Pas de stock',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                'Nta sitoke',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                      ),
                    ],
                  ),
                ),
          new Dette(
            l: widget.l,
            isboss: widget.isboss,
            controled: widget.controled,
            numero: widget.numero,
            password: widget.password,
            duree: jours,
            worker: w,
          ),
          new Depense(
            l: widget.l,
            isboss: widget.isboss,
            controled: widget.controled,
            numero: widget.numero,
            password: widget.password,
            duree: jours,
            worker: w,
          ),
          new Rapport(
            l: widget.l,
            isboss: widget.isboss,
            controled: widget.controled,
            numero: widget.numero,
            password: widget.password,
            duree: jours,
          ),
          new Argent(
            l: widget.l,
            isboss: widget.isboss,
            controled: widget.controled,
            numero: widget.numero,
            password: widget.password,
            duree: jours,
          ),
          new Stock(
            l: widget.l,
            isboss: widget.isboss,
            controled: widget.controled,
            numero: widget.numero,
            password: widget.password,
            duree: jours,
            worker: w,
          ),
          new Probleme(
            l: widget.l,
            isboss: widget.isboss,
            controled: widget.controled,
            numero: widget.numero,
            password: widget.password,
            duree: jours,
            worker: w,
          )
        ],
        controller: _tabController,
      ),
    );
  }
}

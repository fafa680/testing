import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import 'package:kakwetu/sqldb.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';

class Page2 extends StatefulWidget {
  final Langue l;
  Page2({Key key, this.l}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
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
  Myform({Key key, this.l}) : super(key: key);

  @override
  _MyformState createState() => _MyformState();
}

class _MyformState extends State<Myform> {
  TextEditingController pass = new TextEditingController();
  TextEditingController nom = new TextEditingController();
  TextEditingController confirmpass = new TextEditingController();
  TextEditingController prenom = new TextEditingController();
  TextEditingController drop = new TextEditingController();
  List<String> pays = [];
  String etat = "";
  String nro = "";
  String pay1 = "";
  String pass1 = "";
  String nom1 = "";
  String prenom1 = "";
  var dbHelper;
  bool isobscure = true;
  String mynumber = "";
  FocusNode focusnode;
  FocusNode focusnode1;
  FocusNode focusnode2;
  FocusNode focusnode3;
  StreamController<List> _streamcontroller = StreamController<List>();
  @override
  void initState() {
    selectpays();
    dbHelper = new DBHelper();
    refreshList();
    getId();
    focusnode = FocusNode();
    focusnode1 = FocusNode();
    focusnode2 = FocusNode();
    focusnode3 = FocusNode();
    focusnode.addListener(() {});
    focusnode1.addListener(() {});
    focusnode2.addListener(() {});
    focusnode3.addListener(() {});
    super.initState();
  }

  dismisskeyboard() {
    focusnode.unfocus();
    focusnode1.unfocus();
    focusnode2.unfocus();
    focusnode3.unfocus();
  }

  @override
  void dispose() {
    _streamcontroller.close();
    pass.dispose();
    nom.dispose();
    focusnode1.dispose();
    focusnode.dispose();
    focusnode2.dispose();
    focusnode3.dispose();
    prenom.dispose();
    confirmpass.dispose();
    drop.dispose();
    pays.clear();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  refreshList() {
    setState(() {
      dbHelper.getnumeros();
      if (DBHelper.nume1 != null) {
        setState(() {
          mynumber = DBHelper.nume1;
        });
      } else {
        setState(() {
          mynumber = "";
        });
      }
    });
  }

  String idphone = "";
  getId() async {
    var deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        var iosDeviceInfo = await deviceInfo.iosInfo;
        setState(() {
          idphone = iosDeviceInfo.identifierForVendor;
        });
      } else {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        setState(() {
          idphone = androidDeviceInfo.androidId;
        });
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  testPass() {
    //on test si le password contient le chiffres et les lettres
    String al = "abcdefghijklmnopkrstuvwyxz";
    String nu = "1234567890";
    int i = 0;
    int j = 0;
    int t = 0;
    int t1 = 0;

    while (i < pass.text.length && t == 0) {
      if (al.contains(pass.text[i])) {
        t += 1;
      }

      i++;
    }
    while (j < pass.text.length && t1 == 0) {
      if (nu.contains(pass.text[j])) {
        t1 += 1;
      }

      j++;
    }

    if (t > 0 && t1 > 0) {
      return (t + t1);
    } else {
      return 0;
    }
  }

  snackabardropimpty() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: widget.l.fra == 1
                ? Text(
                    'Pays',
                    style: TextStyle(fontSize: 50, color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : widget.l.eng == 1
                    ? Text(
                        'Country',
                        style: TextStyle(fontSize: 50, color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    : widget.l.swa == 1
                        ? Text(
                            'Nchi',
                            style: TextStyle(fontSize: 40, color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Igihugu',
                            style: TextStyle(fontSize: 40, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              Icons.warning,
              color: Colors.red,
              size: 50,
            ),
          )
        ],
      ),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {

      //   },
      // ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  bool visible1 = false;
  crypterchaine(String pass) {
    String chaine = "abcdefghi0123456789jklmnopkrstuvwxyz.";
    String c;
    String t = "";
    String b = pass;
    for (int i = 0; i < b.length; i++) {
      if (chaine.contains(b[i])) {
        c = (pow(chaine.indexOf(b[i]), 4) + (731)).toString();
      } else {
        try {
          c = chaine[int.parse(b[i])];
        } catch (e) {
          c = b[i];
        }
      }
      if (t == "") {
        t = c;
      } else {
        t += "." + c;
      }
    }
    return t;
  }

  insertbc() {
    setState(() {
      visible1 = true;
    });
    var url = "https://kakwetuburundifafanini.com/insert/insertb_c.php";
    try {
      if (nom.text.isNotEmpty &&
          prenom.text.isNotEmpty &&
          (testPass() > 0) &&
          (pass.text.length >= 6) &&
          pay1 != "") {
        http.post(url, body: {
          "etat": etat,
          "nom_b": crypterchaine(nom.text.trim().replaceAll(' ', '')),
          "nro": nro,
          "pd": crypterchaine(pass.text.trim().replaceAll(' ', '')),
          "prenom_b": crypterchaine(prenom.text.trim().replaceAll(' ', '')),
          "tid": idphone
        }).then((value) {
          if (value.statusCode == 200) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Page3(
                        l: widget.l,
                        nom: nom1,
                        prenom: prenom1,
                        pass: pass1,
                        pays: pay1,
                        idphone: idphone)));
            setState(() {
              visible1 = false;
            });
          } else {
            Fluttertoast.showToast(
                msg: widget.l.fra == 1
                    ? "Operation Echouée"
                    : widget.l.eng == 1
                        ? "Failed"
                        : widget.l.swa == 1
                            ? "Bimekatala"
                            : "Ntivyakunze",
                backgroundColor: Colors.red,
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_LONG);
            setState(() {
              visible1 = false;
            });
          }
        });
        setState(() {
          nom1 = crypterchaine(nom.text.trim().replaceAll(' ', ''));
          prenom1 = crypterchaine(prenom.text.trim().replaceAll(' ', ''));
          pass1 = crypterchaine(pass.text.trim().replaceAll(' ', ''));
          nom.text = "";
          pass.text = "";
          confirmpass.text = "";
          prenom.text = "";
          drop.text = "";
        });
      } else {
        setState(() {
          Fluttertoast.showToast(
              msg: widget.l.fra == 1
                  ? "Operation Echouée"
                  : widget.l.eng == 1
                      ? "Failed"
                      : widget.l.swa == 1
                          ? "Bimekatala"
                          : "Ntivyakunze",
              backgroundColor: Colors.red,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
          visible1 = false;
        });
      }
    } catch (e) {
      setState(() {
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Operation Echouée"
                : widget.l.eng == 1
                    ? "Failed"
                    : widget.l.swa == 1
                        ? "Bimekatala"
                        : "Ntivyakunze",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        visible1 = false;
      });
      return;
    }
  }

  static _isolate(String body) {
    return jsonDecode(body);
  }

  selectpays() async {
    try {
      final response = await http
          .get("https://kakwetuburundifafanini.com/pays/selectpays.php");
      var resultat = await compute(_isolate, response.body);
      setState(() {
        for (int i = 0; i < resultat.length; i++) {
          setState(() {
            pays.add(resultat[i]['nom']);
          });
        }
        _streamcontroller.add(pays);
      });
    } catch (e) {
      setState(() {
        pays = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: 400,
              child: Card(
                elevation: 0,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.lightBlue, width: 5),
                    borderRadius: BorderRadius.circular(30)),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15),
                          child: TextFormField(
                            autofocus: false,
                            focusNode: focusnode,
                            inputFormatters: [
                              new FilteringTextInputFormatter.allow(
                                  RegExp("[0-9a-zA-Z.-/]"))
                            ],
                            controller: nom,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLength: 30,
                            decoration: InputDecoration(
                                labelText: widget.l.fra == 1
                                    ? "Nom"
                                    : widget.l.eng == 1
                                        ? "First Name"
                                        : widget.l.swa == 1
                                            ? "Jina la Kwanza"
                                            : "Izina ry'Ikirundi",
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.l.fra == 1
                                    ? 'Entrez Votre Nom'
                                    : widget.l.eng == 1
                                        ? 'Enter Your First Name'
                                        : widget.l.swa == 1
                                            ? 'Ingiza Jina La Kwanza Lako'
                                            : "Shiramwo Izina ry'Ikirundi";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15),
                          child: TextFormField(
                            autofocus: false,
                            focusNode: focusnode1,
                            inputFormatters: [
                              new FilteringTextInputFormatter.allow(
                                  RegExp("[0-9a-zA-Z.-/]"))
                            ],
                            controller: prenom,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLength: 30,
                            decoration: InputDecoration(
                                labelText: widget.l.fra == 1
                                    ? "Prenom"
                                    : widget.l.eng == 1
                                        ? "Last Name"
                                        : widget.l.swa == 1
                                            ? "Jina la Mwisho"
                                            : "Iritazirano",
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.l.fra == 1
                                    ? 'Entrez Votre Prenom'
                                    : widget.l.eng == 1
                                        ? 'Enter Your Last Name'
                                        : widget.l.swa == 1
                                            ? 'Ingiza Jina Lako La Misho'
                                            : "Shiramwo Izina ryawe ry'Iritazirano";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: TextFormField(
                            autofocus: false,
                            enableInteractiveSelection: false,
                            focusNode: focusnode2,
                            inputFormatters: [
                              new FilteringTextInputFormatter.deny(
                                  RegExp("[#*'\"/&();=|@]"))
                            ],
                            controller: pass,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            obscureText: isobscure,
                            textAlign: TextAlign.center,
                            maxLength: 15,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    if (isobscure) {
                                      setState(() {
                                        isobscure = false;
                                      });
                                    } else {
                                      setState(() {
                                        isobscure = true;
                                      });
                                    }
                                  },
                                  child: Icon(
                                      isobscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white),
                                ),
                                labelText: widget.l.fra == 1
                                    ? "Mot de Passe"
                                    : widget.l.eng == 1
                                        ? "PassWord"
                                        : widget.l.swa == 1
                                            ? "nenosiri"
                                            : "Kabanga",
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.l.fra == 1
                                    ? 'Entrez Le Mot de Passe'
                                    : widget.l.eng == 1
                                        ? 'Enter Your PassWord'
                                        : widget.l.swa == 1
                                            ? 'Ingiza nenosiri'
                                            : 'Shiramwo Ijambo Kabanga';
                              } else if (testPass() == 0) {
                                return widget.l.fra == 1
                                    ? 'Melangez les chiffres et les Lettres'
                                    : widget.l.eng == 1
                                        ? 'Mix digit and letters'
                                        : widget.l.swa == 1
                                            ? 'changanya takwimu na herufi'
                                            : "Teranya Ibiharuro N'idome";
                              } else if (pass.text
                                      .trim()
                                      .replaceAll(' ', '')
                                      .length <
                                  6) {
                                return widget.l.fra == 1
                                    ? 'aumoins 6 caracteres'
                                    : widget.l.eng == 1
                                        ? 'at least 6 characters'
                                        : widget.l.swa == 1
                                            ? 'Siyo chini ya 6'
                                            : 'Ako nigato,vyopfuma 6';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: TextFormField(
                            autofocus: false,
                            enableInteractiveSelection: false,
                            focusNode: focusnode3,
                            inputFormatters: [
                              new FilteringTextInputFormatter.deny(
                                  RegExp("[#*'\"/&();=|@]"))
                            ],
                            controller: confirmpass,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            obscureText: true,
                            textAlign: TextAlign.center,
                            maxLength: 15,
                            decoration: InputDecoration(
                                labelText: widget.l.fra == 1
                                    ? "Confirmer"
                                    : widget.l.eng == 1
                                        ? "Confirm"
                                        : widget.l.swa == 1
                                            ? "Thibitisha"
                                            : "Risubiremwo",
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.l.fra == 1
                                    ? 'Confirmez Votre Mot de passe'
                                    : widget.l.eng == 1
                                        ? 'Confirm your Password'
                                        : widget.l.swa == 1
                                            ? 'Thibitisha nenosiri Lako'
                                            : 'Subiramwo ijambo Kabanga';
                              } else if (pass.text.trim().replaceAll(' ', '') !=
                                  confirmpass.text) {
                                return widget.l.fra == 1
                                    ? 'Mot de passe de confirmation Icorrect'
                                    : widget.l.eng == 1
                                        ? 'Wrong Confirm Password'
                                        : widget.l.swa == 1
                                            ? 'Thibitisha Vizuri'
                                            : 'Mwihenze Gusubiramwo Ijambo Kabanga';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        StreamBuilder<List>(
                            stream: _streamcontroller.stream,
                            builder: (context, snap) {
                              if (snap.hasError) {
                                return null;
                              } else if (snap.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Card(
                                    color: Colors.green,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.red, width: 3),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: DropdownButtonFormField(
                                      autofocus: false,
                                      autovalidate: false,
                                      isDense: true,
                                      isExpanded: true,
                                      dropdownColor: Colors.black,
                                      value: pay1,
                                      items: snap.data.map((e) {
                                        return DropdownMenuItem(
                                          child: Center(
                                            child: new Text(
                                              e,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          value: e,
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        setState(() {
                                          pay1 = v;
                                          dismisskeyboard();
                                        });
                                      },
                                      hint: Center(
                                        child: Text(
                                          widget.l.fra == 1
                                              ? "Dans quel Pays ?"
                                              : widget.l.eng == 1
                                                  ? "In Which Country ?"
                                                  : widget.l.swa == 1
                                                      ? "Mu Nchi gani ?"
                                                      : "Mukihe gihugu ?",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            dismisskeyboard();
                            refreshList();
                            getId();
                            if (mynumber != "") {
                              Fluttertoast.showToast(
                                  msg: widget.l.fra == 1
                                      ? "Pour Payer Connectez-Vous avec Votre Numero"
                                      : widget.l.eng == 1
                                          ? "In Order To Pay Sign In With Your Number"
                                          : widget.l.swa == 1
                                              ? "Kwakulipa Ingia kwanza Na Nambari Yako"
                                              : "Mukuriha Nimwinjire N'Inomero Yanyu",
                                  backgroundColor: Colors.red,
                                  gravity: ToastGravity.CENTER,
                                  toastLength: Toast.LENGTH_LONG);
                              Navigator.pop(context);
                            } else {
                              if (_formKey.currentState.validate()) {
                                if (pay1 != "") {
                                  insertbc();
                                } else {
                                  snackabardropimpty();
                                }
                              }
                            }
                          },
                          child: Container(
                            width: 250,
                            height: 40,
                            color: Colors.blue,
                            alignment: Alignment.center,
                            child: widget.l.eng == 1
                                ? Text(
                                    'Accept',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                : widget.l.swa == 1
                                    ? Text(
                                        'Kubali',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : widget.l.fra == 1
                                        ? Text(
                                            'Accepter',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            'Emeza',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Visibility(
                              visible: visible1,
                              child: Center(
                                  child: LinearProgressIndicator(
                                backgroundColor: Colors.cyanAccent,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                              ))),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(2),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black26, width: 5),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  widget.l.fra == 1
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Choisissez Le Pays Dans lequel vous Etes Maintenant",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : widget.l.eng == 1
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "You Choose A country Where you are now",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : widget.l.swa == 1
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Chagua Nchi Ambayo ukoemwo Sasa hivi",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Hitamwo Igihugu Urimwo ubunyene",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

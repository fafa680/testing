import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/sqldb.dart';
import 'package:flutter/foundation.dart';

class Page3 extends StatefulWidget {
  final Langue l;
  final String nom;
  final String prenom;
  final String pass;
  final String pays;
  final String idphone;
  Page3(
      {Key key,
      this.l,
      this.nom,
      this.prenom,
      this.pass,
      this.pays,
      this.idphone})
      : super(key: key);
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  TextEditingController drop = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  static const _hover = const MethodChannel("it.fab.bi/hover");
  String _actionResponse = "";
  String imihora = "";
  String messagepay1 = "......";
  String messagepay2 = "......";
  String phone = "";
  String montant = "";
  String id = "";
  String id2 = "";
  String numero = "";
  String dure = "";
  String modepayement = "";
  String mynumber = "";
  var dbHelper;
  List<Numero> numeros;
  StreamController<List> _streamcontroller1 = StreamController<List>();
  StreamController<List> _streamcontroller = StreamController<List>();
  ScrollController _scrollcontroller = new ScrollController();
  @override
  void initState() {
    selecttypebossexist();
    selectoperator();
    dbHelper = new DBHelper();
    super.initState();
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    _streamcontroller.close();
    _streamcontroller1.close();
    amount.dispose();
    drop.dispose();
    operateurs.clear();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  List<String> operateurs = [];
  selectoperator() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/get/selectoperatordepays.php",
          body: {"pays": widget.pays});
      var resultat = await compute(_isolate, response.body);
      setState(() {
        final paysl1 = resultat;
        for (int i = 0; i < paysl1.length; i++) {
          setState(() {
            operateurs.add(paysl1[i]['opr']);
          });
        }
        _streamcontroller.add(operateurs);
      });
    } catch (e) {
      setState(() {
        operateurs = [];
      });
    }
  }

  decrypternumero(String numb) {
    var numcrpt = [];
    setState(() {
      numcrpt = numb.split("-");
    });

    String result = "";
    for (int i = 0; i < numcrpt.length; i++) {
      if (numcrpt[i] == '.') {
        if (result == "") {
          result = '.';
        } else {
          result += '.';
        }
      } else {
        try {
          if (result == "") {
            result = (sqrt(sqrt(double.parse(numcrpt[i]) - (1753))).round())
                .toString();
          } else {
            result += (sqrt(sqrt(double.parse(numcrpt[i]) - (1753))).round())
                .toString();
          }
        } catch (e) {}
      }
    }
    return result.toString();
  }

  static _isolate(String body) {
    return jsonDecode(body);
  }

  selecttypepayementdeoperateur(String imihora) async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/get/selecttypepayementdeoperateu.php",
          body: {"imihora": imihora});
      var resultat = jsonDecode(response.body);
      setState(() {
        _streamcontroller1.add(resultat);
      });
    } catch (e) {}
  }

  selecttypebossexist() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/get/selecttypebossexist.php",
          body: {
            "nom_b": widget.nom,
            "pd": widget.pass,
            "prenom_b": widget.prenom,
            "tid": widget.idphone,
            "nro": "",
            "etat": ""
          });
      var resultat = await compute(_isolate, response.body);
      if (resultat.length == 0) {
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Changez Votre Mot Depasse"
                : widget.l.eng == 1
                    ? "Change Your Password"
                    : widget.l.swa == 1
                        ? "Badilisha Nenosiri"
                        : "Hindura Ijambo Kabanga",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        setState(() {
          pop = true;
        });
        Navigator.pop(context);
      } else {
        try {
          setState(() {
            id2 = (resultat[1]['id_b']).toString();
          });
          if (id2 != "") {
            Fluttertoast.showToast(
                msg: widget.l.fra == 1
                    ? "Changez Votre Mot de passe"
                    : widget.l.eng == 1
                        ? "Change Your Password"
                        : widget.l.swa == 1
                            ? "Badilisha Nenosiri"
                            : "Hindura Ijambo Kabanga",
                backgroundColor: Colors.red,
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_LONG);
            setState(() {
              pop = true;
            });
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            setState(() {
              id = (resultat[0]['id_b']).toString();
              numero = numeroBoss(id);
              numero = crypterchaine(numero);
              checkdoublenumero(numero);
            });
          }
        } catch (e) {
          setState(() {
            id = (resultat[0]['id_b']).toString();
            numero = numeroBoss(id);
            numero = crypterchaine(numero);
            checkdoublenumero(numero);
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: widget.l.fra == 1
              ? "Changez Votre Mot de passe"
              : widget.l.eng == 1
                  ? "Change Your Password"
                  : widget.l.swa == 1
                      ? "Badilisha Nenosiri"
                      : "Hindura Ijambo Kabanga",
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
      setState(() {
        pop = true;
      });
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<dynamic> nk(var phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'numero': phoneNumber,
      'montant': amount,
    };
    String response = "";
    try {
      final String result = await _hover.invokeMethod('nk', sendMap);
      setState(() {
        response = result;
      });
    } on PlatformException catch (e) {
      return;
    }
    setState(() {
      _actionResponse = response;
    });
  }

  Future<dynamic> ci(var phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'numero': phoneNumber,
      'montant': amount,
    };
    String response = "";
    try {
      final String result = await _hover.invokeMethod('ci', sendMap);
      setState(() {
        response = result;
      });
    } on PlatformException catch (e) {
      return;
    }
    setState(() {
      _actionResponse = response;
    });
  }

  Future<dynamic> bu(var phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'numero': phoneNumber,
      'montant': amount,
    };
    String response = "";
    try {
      final String result = await _hover.invokeMethod('bu', sendMap);
      setState(() {
        response = result;
      });
    } on PlatformException catch (e) {
      return;
    }
    setState(() {
      _actionResponse = response;
    });
  }

  Future<dynamic> ec(var phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'numero': phoneNumber,
      'montant': amount,
    };
    String response = "";
    try {
      final String result = await _hover.invokeMethod('ec', sendMap);
      setState(() {
        response = result;
      });
    } on PlatformException catch (e) {
      return;
    }
    setState(() {
      _actionResponse = response;
    });
  }

  Future<dynamic> mi(var phoneNumber, amount, aide) async {
    var sendMap = <String, dynamic>{
      'numero': phoneNumber,
      'montant': amount,
      'objet': aide,
    };
    String response = "";
    try {
      final String result = await _hover.invokeMethod('mi', sendMap);
      setState(() {
        response = result;
      });
    } on PlatformException catch (e) {
      return;
    }
    setState(() {
      _actionResponse = response;
    });
  }

  checkdoublenumero(String ynumero) async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/first/checkdoublenumero.php",
          body: {"nro": ynumero});
      var resultat = await compute(_isolate, response.body);
      if (resultat.length == 0) {
      } else {
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Changez Votre Mot de passe"
                : widget.l.eng == 1
                    ? "Change Your Password"
                    : widget.l.swa == 1
                        ? "Badilisha Nenosiri"
                        : "Hindura Ijambo Kabanga",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: widget.l.fra == 1
              ? "Changez Votre Mot de passe"
              : widget.l.eng == 1
                  ? "Change Your Password"
                  : widget.l.swa == 1
                      ? "Badilisha Nenosiri"
                      : "Hindura Ijambo Kabanga",
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
      setState(() {
        pop = true;
      });
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  bool visible1 = false;
  addechecpayement() {
    setState(() {
      visible1 = true;
    });
    try {
      http.post(
          "https://kakwetuburundifafanini.com/add/addechecpayementcreation.php",
          body: {
            "message_echec": _actionResponse,
            "nro": numero,
            "messge_reference": crypterchaine(messagepay1),
            "smsreferenceautre": crypterchaine(messagepay2),
            "op": imihora,
            "pays": widget.pays,
            "motant": montant,
          }).then((value) {
        if (value.statusCode == 200) {
          setState(() {
            _actionResponse = "";
            visible1 = false;
            amount.text = "";
            pop = true;
            Fluttertoast.showToast(
                msg: widget.l.fra == 1
                    ? "Réessayez Encore"
                    : widget.l.eng == 1
                        ? "Retry Once Again"
                        : widget.l.swa == 1
                            ? "Jaribu tena"
                            : "Mugerageze kandi",
                backgroundColor: Colors.red,
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_LONG);
          });
        } else {
          setState(() {
            Fluttertoast.showToast(
                msg: widget.l.fra == 1
                    ? "Echec,Acceptez encore"
                    : widget.l.eng == 1
                        ? "Failed,Accept Once again"
                        : widget.l.swa == 1
                            ? "Bimekatala,Kubari tena"
                            : "Ntivyakunze,Emeza kandi",
                backgroundColor: Colors.red,
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_LONG);
            visible1 = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Echec,Acceptez encore"
                : widget.l.eng == 1
                    ? "Failed,Accept Once again"
                    : widget.l.swa == 1
                        ? "Bimekatala,Kubari tena"
                        : "Ntivyakunze,Emeza kandi",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        visible1 = false;
      });
      return;
    }
  }

  updatebcnumero() {
    setState(() {
      visible1 = true;
    });
    try {
      http.post("https://kakwetuburundifafanini.com/update/updateb_cnumero.php",
          body: {
            "nro": numero,
            "prenom_b": widget.prenom,
            "nom_b": widget.nom,
            "etat": "changed",
            "pd": widget.pass,
            "dre": dure,
            "numero": numero,
            "sme": montant,
            "pays": widget.pays,
            "tid": widget.idphone
          }).then((value) {
        if (value.statusCode == 200) {
          Numero e = Numero(null, numero);
          dbHelper.save(e);
          Fluttertoast.showToast(
              msg: widget.l.fra == 1
                  ? "Bienvenue dans Kakwetu"
                  : widget.l.eng == 1
                      ? "Welcome in Kakwetu"
                      : widget.l.swa == 1
                          ? "Karibu kwenye Kakwetu"
                          : "Murakaza Neza Muri Kakwetu",
              backgroundColor: Colors.black,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
          setState(() {
            _actionResponse = "";
            visible1 = false;
            pop = true;
          });
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          setState(() {
            visible1 = false;
            Fluttertoast.showToast(
                msg: widget.l.fra == 1
                    ? "Echec,Acceptez encore"
                    : widget.l.eng == 1
                        ? "Failed,Accept Once again"
                        : widget.l.swa == 1
                            ? "Bimekatala,Kubari tena"
                            : "Ntivyakunze,Emeza kandi",
                backgroundColor: Colors.red,
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_LONG);
          });
        }
      });
    } catch (e) {
      setState(() {
        visible1 = false;
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Echec,Acceptez encore"
                : widget.l.eng == 1
                    ? "Failed,Accept Once again"
                    : widget.l.swa == 1
                        ? "Bimekatala,Kubari tena"
                        : "Ntivyakunze,Emeza kandi",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      });
      return;
    }
  }

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

  numeroBoss(String id) {
    double b = 0;
    String a1 = "";
    try {
      setState(() {
        b = double.parse(id);
      });
    } catch (e) {
      return;
    }
    setState(() {
      a1 = (sqrt(log(b))).toString();
    });
    return a1;
  }

  update() {
    String pa = "com.nini.fafa";
    try {
      launch("market://details?id=" + pa);
    } on PlatformException catch (e) {
      launch("https://play.google.com/store/apps/details?id=" + pa);
    } finally {
      launch("https://play.google.com/store/apps/details?id=" + pa);
    }
  }

  snackabarfauxop() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: widget.l.fra == 1
                ? Text(
                    'Operateur',
                    style: TextStyle(fontSize: 50, color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : widget.l.eng == 1
                    ? Text(
                        'Operator',
                        style: TextStyle(fontSize: 50, color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    : widget.l.swa == 1
                        ? Text(
                            'Mtandao',
                            style: TextStyle(fontSize: 40, color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Umuhora',
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

  snackabarfauxpa() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: widget.l.fra == 1
                ? Text(
                    'Paquet',
                    style: TextStyle(fontSize: 50, color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : widget.l.eng == 1
                    ? Text(
                        'Packet',
                        style: TextStyle(fontSize: 50, color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    : widget.l.swa == 1
                        ? Text(
                            'Mfuko',
                            style: TextStyle(fontSize: 40, color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Umutekero',
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

  bool pop = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Kakwetu ",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.yellow),
          ),
        ),
        resizeToAvoidBottomPadding: false,
        body: WillPopScope(
          onWillPop: () async => pop,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    StreamBuilder<List>(
                        stream: _streamcontroller.stream,
                        builder: (context, snap) {
                          if (snap.hasError) {
                            return null;
                          } else if (snap.hasData) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 8.0),
                                child: Card(
                                  color: Colors.amber,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.lightBlue, width: 2),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Visibility(
                                    visible:
                                        _actionResponse != "" ? false : true,
                                    child: DropdownButtonFormField(
                                      autofocus: false,
                                      autovalidate: false,
                                      isDense: true,
                                      isExpanded: true,
                                      dropdownColor: Colors.black,
                                      items: snap.data.map((e) {
                                        return DropdownMenuItem(
                                          child: Center(
                                            child: new Text(
                                              e,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          value: e,
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        setState(() {
                                          selecttypepayementdeoperateur(v);
                                          imihora = v;
                                          amount.text = "";
                                          _actionResponse = "";
                                        });
                                      },
                                      hint: Center(
                                        child: Text(
                                          widget.l.fra == 1
                                              ? "Réseau"
                                              : widget.l.eng == 1
                                                  ? "Network"
                                                  : widget.l.swa == 1
                                                      ? "Mtandao"
                                                      : "Umuhora",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          } else {
                            return Visibility(
                                visible: _actionResponse != "" ? false : true,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                        }),
                  ],
                ),
              ),
              StreamBuilder<List>(
                  stream: _streamcontroller1.stream,
                  builder: (context, snap) {
                    if (snap.hasError) {
                    } else if (snap.hasData) {
                      return Expanded(
                          child: ListView.builder(
                              controller: _scrollcontroller,
                              scrollDirection: Axis.horizontal,
                              itemCount: snap.data.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Visibility(
                                    visible:
                                        _actionResponse != "" ? false : true,
                                    child: InkWell(
                                      splashColor: Colors.white,
                                      onTap: () {
                                        setState(() {
                                          widget.l.fra == 1
                                              ? amount.text = snap.data[i]
                                                      ['mtt'] +
                                                  " de " +
                                                  snap.data[i]['dre'] +
                                                  " Jours"
                                              : widget.l.eng == 1
                                                  ? amount.text = snap.data[i]
                                                          ['mtt'] +
                                                      " of " +
                                                      snap.data[i]['dre'] +
                                                      " Days"
                                                  : widget.l.swa == 1
                                                      ? amount.text = snap
                                                              .data[i]['mtt'] +
                                                          " Ya Siku " +
                                                          snap.data[i]['dre']
                                                      : amount.text = snap
                                                              .data[i]['mtt'] +
                                                          " Mumisi " +
                                                          snap.data[i]['dre'];
                                          messagepay1 = decrypterchaine(
                                              snap.data[i]['sms_pmt']);
                                          messagepay2 = decrypterchaine(
                                              snap.data[i]['sms_pmt2']);
                                          phone = decrypterchaine(
                                              snap.data[i]['mamaf_p']);
                                          montant = snap.data[i]['mtt'];
                                          dure = snap.data[i]['dre'];
                                          modepayement = snap.data[i]['nom'];
                                          _actionResponse = "";
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Card(
                                          margin: EdgeInsets.all(3),
                                          color: Colors.black45,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.lightBlue,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                    snap.data[i]['nom'] + ":",
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        decoration:
                                                            TextDecoration
                                                                .underline)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: widget.l.fra == 1
                                                    ? Text("Montant: " + snap.data[i]['mtt'],
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white))
                                                    : widget.l.eng == 1
                                                        ? Text("Amount: " + snap.data[i]['mtt'],
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .white))
                                                        : widget.l.swa == 1
                                                            ? Text("Kiasi: " + snap.data[i]['mtt'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white))
                                                            : Text("Uwa: " + snap.data[i]['mtt'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: widget.l.fra == 1
                                                    ? Text(snap.data[i]['dre'] + " Jours",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white))
                                                    : widget.l.eng == 1
                                                        ? Text(snap.data[i]['dre'] + " Days",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white))
                                                        : widget.l.swa == 1
                                                            ? Text("Siku " + snap.data[i]['dre'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white))
                                                            : Text(
                                                                "Imisi " + snap.data[i]['dre'],
                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }));
                    } else {
                      return Visibility(
                        visible: _actionResponse != "" ? false : true,
                        child: Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black)),
                        ),
                      );
                    }
                    return null;
                  }),
              Expanded(
                child:
                    ListView(scrollDirection: Axis.vertical, children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
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
                                      left: 30.0, right: 30.0),
                                  child: Visibility(
                                    visible:
                                        _actionResponse != "" ? false : true,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: amount,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      maxLength: 30,
                                      decoration: InputDecoration(
                                          labelText: widget.l.fra == 1
                                              ? "Montant"
                                              : widget.l.eng == 1
                                                  ? "Amount"
                                                  : widget.l.swa == 1
                                                      ? "Kiasi"
                                                      : "Amahera",
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic)),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: true,
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      setState(() {
                                        pop = false;
                                      });
                                      if (_actionResponse
                                              .contains(messagepay1) ||
                                          _actionResponse
                                              .contains(messagepay2)) {
                                        updatebcnumero();
                                      } else if (_actionResponse.isEmpty) {
                                        if (imihora == "") {
                                          snackabarfauxop();
                                        } else if (amount.text.isEmpty) {
                                          snackabarfauxpa();
                                        } else {
                                          if (modepayement == "lumicash") {
                                            mi(phone, montant, "Encouragement");
                                          } else if (modepayement ==
                                              "ecocash") {
                                            ec(phone, montant);
                                          } else if (modepayement == "mcash") {
                                            bu(phone, montant);
                                          } else if (modepayement ==
                                              "fonecash") {
                                            ci(phone, montant);
                                          } else if (modepayement ==
                                              "ecobankpay") {
                                            nk(phone, montant);
                                          } else {
                                            update();
                                          }
                                        }
                                      } else {
                                        addechecpayement();
                                      }
                                    },
                                    child: Container(
                                      width: 250,
                                      height: 40,
                                      color: Colors.lightBlueAccent,
                                      alignment: Alignment.center,
                                      child: widget.l.eng == 1
                                          ? Text(
                                              'Accept',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : widget.l.swa == 1
                                              ? Text(
                                                  'Kubali',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : widget.l.fra == 1
                                                  ? Text(
                                                      'Accepter',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      'Emeza',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
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
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ))),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ));
  }
}

class Langue {
  int kir;
  int swa;
  int fra;
  int eng;
  Langue(this.kir, this.swa, this.fra, this.eng);
}

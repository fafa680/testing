import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../page3.dart';

class Encouragement extends StatefulWidget {
  final Langue l;
  final String numero;
  final String pays;
  Encouragement({Key key, this.l, this.numero, this.pays}) : super(key: key);

  @override
  _EncouragementState createState() => _EncouragementState();
}

class _EncouragementState extends State<Encouragement> {
  TextEditingController dropoperateurs = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  static const _hover = const MethodChannel("it.fab.bi/hover");
  String _actionResponse = "";
  String pay1 = "";
  String imihora = "";
  String phone = "";
  String montant = "";
  String dure = "";
  String modepayement = "";
  String messagepay1 = "......";
  String messagepay2 = "......";
  final _formKey = GlobalKey<FormState>();
  List<String> operateurs = [];
  bool probleme = false;
  StreamController<List> _streamcontroller1 = StreamController<List>();
  StreamController<List> _streamcontroller = StreamController<List>();
  ScrollController _scrollcontroller = new ScrollController();
  @override
  void initState() {
    firstcheckvip();
    selectoperator();
    super.initState();
  }

  @override
  void dispose() {
    _streamcontroller.close();
    _streamcontroller1.close();
    dropoperateurs.dispose();
    operateurs.clear();
    amount.dispose();
    _scrollcontroller.dispose();
    super.dispose();
  }

  bool visible1 = false;
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

  int s = 0;
firstcheckvip() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/first/firstcheckvip.php",
          body: {"nro": widget.numero});
          var resultat=await compute(_isolate1,response.body);
      if (resultat.length == 0) {
        setState(() {
          s = 1;
        });
      } else {
        setState(() {
          s = 2;
        });
      }
    } catch (e) {
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
  static _isolate1(String body){
return jsonDecode(body);
  }
 selectoperator() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/get/selectoperatordepays.php",
          body: {"pays": widget.pays});
var resultat=await compute(_isolate1,response.body);
      setState(() {
        for (int i = 0; i < resultat.length; i++) {
          setState(() {
            operateurs.add(resultat[i]['opr']);
          });
        }
        probleme = false;
        _streamcontroller1.add(operateurs);
      });
    } catch (e) {
      setState(() {
        operateurs = [];
        probleme = true;
      });
    }
  }

selecttypepayementvip(String imiho) async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/get/selectoppayementvip.php",
          body: {"imihora": imiho});
          var resultat=jsonDecode(response.body);
      setState(() {
          _streamcontroller.add(resultat);
      });
    } catch (e) {
      setState(() {
      });
    }
  }

  selecttypepayementdeoperateurs(String imihora) async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/get/selecttypepayementdeoperateu.php",
          body: {"imihora": imihora});
  var resultat=jsonDecode(response.body);
      setState(() {
      _streamcontroller.add(resultat);
        probleme = false;
      });
    } catch (e) {
      setState(() {
        probleme = true;
      });
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

  addechecpayement(){
    setState(() {
      visible1 = true;
    });
    try {
      http.post(
          "https://kakwetuburundifafanini.com/add/addechecpayement.php",
          body: {
            "message_echec": _actionResponse,
            "nro": widget.numero,
            "messge_reference": crypterchaine(messagepay1),
            "smsreferenceautre": crypterchaine(messagepay2),
            "op": imihora,
            "pays": pay1,
            "motant": montant,
          }).then((value){
            if(value.statusCode==200){
 setState(() {
        _actionResponse = "";
        amount.text = "";
        visible1 = false;
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
            }else{
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
  updatecontpayetaddhowget(){
    setState(() {
      visible1 = true;
    });
    try {
      http.post(
          "https://kakwetuburundifafanini.com/update/updatecont_pay.php",
          body: {
            "nro": widget.numero,
            "dre": dure,
            "numero": widget.numero,
            "sme": montant,
            "pays": widget.pays
          }).then((value){
            if(value.statusCode==200){
setState(() {
        _actionResponse = "";
        visible1 = false;
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Bravo,Vous avez Un paquet de " + dure + " jours"
                : widget.l.eng == 1
                    ? "Good,You have now a packet of " + dure + " days"
                    : widget.l.swa == 1
                        ? "Asante,hivi Uko na Mfuko wa siku " + dure
                        : "Murakoze,Ubu Mufise Umutekero w'imisi " + dure,
            backgroundColor: Colors.black,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        pop = true;
        Navigator.pop(context);
        Navigator.pop(context);
      });
            }else{
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

  Future<dynamic> ecobank(var phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'numero': phoneNumber,
      'montant': amount,
    };
// response waits for result from java code
    String response = "";
    try {
      final String result = await _hover.invokeMethod('ecobank', sendMap);
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

  Future<dynamic> bbci(var phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'numero': phoneNumber,
      'montant': amount,
    };
// response waits for result from java code
    String response = "";
    try {
      final String result = await _hover.invokeMethod('bbci', sendMap);
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

  Future<dynamic> bancobu(var phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'numero': phoneNumber,
      'montant': amount,
    };
// response waits for result from java code
    String response = "";
    try {
      final String result = await _hover.invokeMethod('bancobu', sendMap);
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

  Future<dynamic> ecocash(var phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'numero': phoneNumber,
      'montant': amount,
    };
// response waits for result from java code
    String response = "";
    try {
      final String result = await _hover.invokeMethod('ecocash', sendMap);
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

  Future<dynamic> lumicash(var phoneNumber, amount, aide) async {
    var sendMap = <String, dynamic>{
      'numero': phoneNumber,
      'montant': amount,
      'object': aide,
    };
// response waits for result from java code
    String response = "";
    try {
      final String result = await _hover.invokeMethod('lumicash', sendMap);
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

  int test = 0;
  snackabarfauxoperateur() {
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

  snackabarfauxpays() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: widget.l.fra == 1
                ? Text(
                    'pays',
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

  snackabarfauxpaquet() {
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

  snackabarfauxpay() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: widget.l.fra == 1
                ? Text(
                    'Echec',
                    style: TextStyle(fontSize: 50, color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : widget.l.eng == 1
                    ? Text(
                        'Failure',
                        style: TextStyle(fontSize: 50, color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    : widget.l.swa == 1
                        ? Text(
                            'Binakatala',
                            style: TextStyle(fontSize: 40, color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Vyase',
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
            "Kakwetu",
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
                        stream: _streamcontroller1.stream,
                        builder: (context, snap) {
                          if (snap.hasError) {
                            return null;
                          } else if (snap.hasData) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20,bottom: 8.0),
                              child: Card(
                                color: Colors.amber,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.lightBlue, width: 2),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Visibility(
                                  visible: _actionResponse != "" ? false : true,
                                  child: DropDownField(
                                    itemsVisibleInDropdown: 3,
                                    onValueChanged: (v) {
                                      setState(() {
                                        if (s == 1) {
                                          selecttypepayementdeoperateurs(v);
                                        } else if (s == 2) {
                                          selecttypepayementvip(v);
                                        }
                                        imihora = v;
                                        amount.text = "";
                                        _actionResponse = "";
                                      });
                                    },
                                    controller: dropoperateurs,
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    labelText: widget.l.fra == 1
                                        ? "Réseau"
                                        : widget.l.eng == 1
                                            ? "Network"
                                            : widget.l.swa == 1
                                                ? "Mtandao"
                                                : "Umuhora",
                                    labelStyle: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic),
                                    strict: false,
                                    items: operateurs,
                                  ),
                                ),
                              ),
                            );
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
                  stream: _streamcontroller.stream,
                  builder: (context, snap) {
                    if (snap.hasError) {
                    } else if (snap.hasData) {
                      return Expanded(
                          child: Scrollbar(
                        child: ListView.builder(
                            controller: _scrollcontroller,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount:snap.data.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Visibility(
                                  visible: _actionResponse != "" ? false : true,
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      setState(() {
                                        widget.l.fra == 1
                                            ? amount.text = snap.data[i]['mtt'] +
                                                " de " +
                                                snap.data[i]['dre'] +
                                                " Jours"
                                            : widget.l.eng == 1
                                                ? amount.text = snap.data[i]['mtt'] +
                                                    " of " +
                                                    snap.data[i]['dre'] +
                                                    " Days"
                                                : widget.l.swa == 1
                                                    ? amount.text = snap.data[i]
                                                            ['mtt'] +
                                                        " Ya Siku " +
                                                        snap.data[i]['dre']
                                                    : amount.text = snap.data[i]
                                                            ['mtt'] +
                                                        " Mumisi " +
                                                        snap.data[i]['dre'];
                                        messagepay1 =
                                            decrypterchaine(snap.data[i]['sms_pmt']);
                                        messagepay2 = decrypterchaine(
                                            snap.data[i]['sms_pmt2']);
                                        phone =
                                            decrypterchaine(snap.data[i]['mamaf_p']);
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
                                           mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(snap.data[i]['nom'] + ":",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      decoration: TextDecoration
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
                                                          color: Colors.white))
                                                  : widget.l.eng == 1
                                                      ? Text("Amount: " + snap.data[i]['mtt'],
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white))
                                                      : widget.l.swa == 1
                                                          ? Text("Kiasi: " + snap.data[i]['mtt'],
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white))
                                                          : Text("Uwa: " + snap.data[i]['mtt'],
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: widget.l.fra == 1
                                                  ? Text(
                                                      snap.data[i]['dre'] + " Jours",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white))
                                                  : widget.l.eng == 1
                                                      ? Text(snap.data[i]['dre'] + " Days",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white))
                                                      : widget.l.swa == 1
                                                          ? Text("Siku " + snap.data[i]['dre'],
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white))
                                                          : Text("Imisi " + snap.data[i]['dre'],
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ));
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
                      padding: const EdgeInsets.only(left: 20 ,right: 20),
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
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return widget.l.fra == 1
                                              ? 'Choisisez Votre Paquet'
                                              : widget.l.eng == 1
                                                  ? 'Choose Your Packet'
                                                  : widget.l.swa == 1
                                                      ? 'Chagua Mfuko Wako'
                                                      : "Hitamwo Umutekero Wawe";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    setState(() {
                                      pop = false;
                                    });
                                    if (_formKey.currentState.validate()) {
                                      if (_actionResponse
                                              .contains(messagepay1) ||
                                          _actionResponse
                                              .contains(messagepay2)) {
                                        updatecontpayetaddhowget();
                                      } else if (_actionResponse == "") {
                                        if (dropoperateurs.text.isEmpty) {
                                          snackabarfauxoperateur();
                                        } else if (amount.text.isEmpty) {
                                          snackabarfauxpaquet();
                                        } else {
                                          if (modepayement == "lumicash") {
                                            lumicash(phone, montant,
                                                "Encouragement");
                                          } else if (modepayement ==
                                              "ecocash") {
                                            ecocash(phone, montant);
                                          } else if (modepayement == "mcash") {
                                            bancobu(phone, montant);
                                          } else if (modepayement ==
                                              "fonecash") {
                                            bbci(phone, montant);
                                          } else if (modepayement ==
                                              "ecobankpay") {
                                            ecobank(phone, montant);
                                          }
                                        }
                                      } else {
                                        addechecpayement();
                                      }
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

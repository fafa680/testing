import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../page3.dart';
import 'package:flutter/foundation.dart';
class Ajouter1 extends StatefulWidget {
  final Langue l;
  final String nom;
  final String prenom;
  final String pass;
  final String nro;
  final String pays;
  final String idphone;
  Ajouter1(
      {Key key, this.l, this.nom, this.prenom, this.pass, this.nro, this.pays,this.idphone})
      : super(key: key);

  @override
  _Ajouter1State createState() => _Ajouter1State();
}

class _Ajouter1State extends State<Ajouter1> {
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
  String numero = "";
  String modepayement = "";
  String dure = "";
  final _formKey = GlobalKey<FormState>();
  List<String> operateurs = [];
  StreamController<List> _streamcontroller1 = StreamController<List>();
  StreamController<List> _streamcontroller = StreamController<List>();
  ScrollController _scrollcontroller = new ScrollController();
  @override
  void dispose() {
    _scrollcontroller.dispose();
    amount.dispose();
    _streamcontroller1.close();
    _streamcontroller.close();
    drop.dispose();
    operateurs.clear();
    super.dispose();
  }

  @override
  void initState() {
    selecttypeworkerexist();
    selectoperator();
    super.initState();
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
        _streamcontroller1.add(operateurs);
      });
    } catch (e) {
      setState(() {
        operateurs = [];
      });
    }
  }

  selecttypepayementdeoperateur(String imihora) async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/get/selecttypepayementdeoperateu.php",
          body: {"imihora": imihora});
          var resultat=jsonDecode(response.body);
      setState(() {
        _streamcontroller.add(resultat);
      });
    } catch (e) {
    }
  }

  String id2 = "";
 selecttypeworkerexist() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/get/selecttypeworkerexist.php",
          body: {
            "nom_w": widget.nom,
            "pd": widget.pass,
            "prenom_w": widget.prenom,
            "nro": widget.nro,
            "tid":widget.idphone,
            "nro_w":"",
            "etat":""
          });
            var resultat=await compute(_isolate1,response.body);
      setState(() {
        if (resultat.length == 0) {
          Fluttertoast.showToast(
              msg: widget.l.fra == 1
                  ? "Changez Le Mot Depasse"
                  : widget.l.eng == 1
                      ? "Change This Pass Word"
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
              id2 = (resultat[1]['id_w']).toString();
            });
            if (id2 != "") {
              Fluttertoast.showToast(
                  msg: widget.l.fra == 1
                      ? "Changez Son Mot Depasse"
                      : widget.l.eng == 1
                          ? "Change His Pass Word"
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
                id = (resultat[0]['id_w']).toString();
                numero = numeroWorker(id);
                numero = crypterchaine(numero);
                checkdoublenumero(numero);
              });
            }
          } catch (e) {
            setState(() {
              id = (resultat[0]['id_w']).toString();
              numero = numeroWorker(id);
              numero = crypterchaine(numero);
              checkdoublenumero(numero);
            });
          }
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: widget.l.fra == 1
              ? "Changez Le Mot Depasse"
              : widget.l.eng == 1
                  ? "Change This Pass Word"
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
    }
  }

  checkdoublenumero(String ynumero) async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/first/checkdoublenumworker.php",
          body: {"nro_w": ynumero});
        var resultat=await compute(_isolate1,response.body);
      if (resultat.length == 0) {
      } else {
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Changez Le Mot Depasse"
                : widget.l.eng == 1
                    ? "Change This Pass Word"
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
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: widget.l.fra == 1
              ? "Changez Le Mot Depasse"
              : widget.l.eng == 1
                  ? "Change This Pass Word"
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
    }
  }

  bool visible1 = false;
  addechecpayement(){
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
          }).then((value){
            if(value.statusCode==200){
             setState(() {
        visible1 = false;
        _actionResponse = "";
        amount.text = "";
        pop = true;
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Réessayez Encore"
                : widget.l.eng == 1
                    ? "Retry Once Again"
                    : widget.l.swa == 1
                        ? "jaribu tena"
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

  updateworkernumero(){
    setState(() {
      visible1 = true;
    });
    try {
      http.post(
          "https://kakwetuburundifafanini.com/update/updatew_cnumero.php",
          body: {
            "nom_w": widget.nom,
            "nro": widget.nro,
            "nro_w": numero,
            "pd": widget.pass,
            "prenom_w": widget.prenom,
            "etat":"changed",
            "numero": numero,
            "sme": montant,
            "pays": widget.pays,
            "dre": dure,
            "tid":widget.idphone
          }).then((value){
            if(value.statusCode==200){
 setState(() {
        _actionResponse = "";
        visible1 = false;
        pop = true;
        Fluttertoast.showToast(
            msg: widget.l.fra == 1
                ? "Bien Fait"
                : widget.l.eng == 1
                    ? "Done"
                    : widget.l.swa == 1
                        ? "Umeweza"
                        : "Vyakunze",
            backgroundColor: Colors.black,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);
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

  numeroWorker(String id) {
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
      a1 = (log(sqrt(b))).toString();
    });
    return a1;
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
                                    onValueChanged: (v) {
                                      setState(() {
                                        selecttypepayementdeoperateur(v);
                                        imihora = v;
                                        amount.text = "";
                                        _actionResponse = "";
                                      });
                                    },
                                    controller: drop,
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
                          child: ListView.builder(
                              controller: _scrollcontroller,
                              scrollDirection: Axis.horizontal,
                              itemCount:snap.data.length,
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
                                              ? amount.text = snap.data[i]['mtt'] +
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
                                                      ? amount.text = snap.data[i]
                                                              ['mtt'] +
                                                          " Ya Siku " +
                                                          snap.data[i]['dre']
                                                      : amount.text = snap.data[i]
                                                              ['mtt'] +
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
                                            mainAxisAlignment: MainAxisAlignment.center,
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
                                                                fontWeight:
                                                                    FontWeight
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
                                                                    fontWeight:
                                                                        FontWeight.bold,
                                                                    color: Colors.white)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                                            : Text("Imisi " + snap.data[i]['dre'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white)),
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
                      padding: const EdgeInsets.only(left: 20,right: 20),
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
                                        updateworkernumero();
                                      } else if (_actionResponse.isEmpty) {
                                        if (drop.text.isEmpty) {
                                          snackabarfauxop();
                                        } else if (amount.text.isEmpty) {
                                          snackabarfauxpa();
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

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page2.dart';
import 'package:kakwetu/page3.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:kakwetu/page4.dart';
import 'package:kakwetu/sqldb.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Page1(),
  ));
}
class Page1 extends StatefulWidget {
  final Langue l;
  Page1({Key key, this.l}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}
class _Page1State extends State<Page1> {
  TextEditingController pass = new TextEditingController();
  TextEditingController number = new TextEditingController();
  var dbHelper;
  bool help = true;
  bool isobscure = true;
  int test2 = 0;
  String mynumber = "";
  FocusNode focusnode;
  FocusNode focusnode1;
  @override
  void initState() {
    selectpublicites();
    dbHelper = new DBHelper();
    refreshList();
    selectetatworker(mynumber);
    focusnode = FocusNode();
    focusnode1 = FocusNode();
    focusnode.addListener(() {});
    focusnode1.addListener(() {});
    super.initState();
  }

  dismisskeyboard() {
    focusnode.unfocus();
    focusnode1.unfocus();
  }

  @override
  void dispose() {
    pass.dispose();
    focusnode1.dispose();
    focusnode.dispose();
    number.dispose();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  int k = 1;
  int s = 0;
  int f = 0;
  int e = 0;
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

  rechangernumero(String value) {
    String chaine = "kdfabvxous";
    String numero = "";
    for (int i = 0; i < value.length; i++) {
      try {
        if (value[i] != "@") {
          numero = numero + chaine.indexOf(value[i]).toString();
        } else {
          numero = numero + ".";
        }
      } catch (e) {}
    }
    return numero;
  }

  bool visible1 = false;
  bool visible2 = false;
  String franc="";
  String engr="";
  String swahi="";
  String kirund="";
  static _isolate(String body){
return jsonDecode(body);
  }
Future selectpublicites() async {
    try {
      final response = await http.get("https://kakwetuburundifafanini.com/first/firstcheckpublicites.php");
var resultat=jsonDecode(response.body);
      setState(() {
        franc=resultat[0]['fra'];
        engr=resultat[0]['eng'];
        swahi=resultat[0]['swahili'];
        kirund=resultat[0]['kirundi'];
      });
    } catch (e) {}
  }
  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    try {
      String url() {
        if (Platform.isIOS) {
          return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
        } else {
          return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
        }
      }

      if (await canLaunch(url())) {
        await launch(url());
      } else {
        Fluttertoast.showToast(
            msg: f == 1
                ? "Installez d'abord whatsapp"
                : e == 1
                    ? "Install first whatsapp"
                    : s == 1
                        ? "Hauna whatsapp"
                        : "Nta whatsapp mufise",
            backgroundColor: Colors.black,
            textColor: Colors.red,
            fontSize: 20,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      }
    } catch (e) {
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
  String etat = "";
  selectetatworker(String numero) async {
    try {
      final response = await http
          .post("https://kakwetuburundifafanini.com/get/getetat.php", body: {
        "nro_w": numero,
      });
 var resultat=await compute(_isolate,response.body);
      setState(() {
        etat =resultat[0]['etat'].toString();
      });
    } catch (e) {}
  }
  addjournal(String nume){
    try {
      http.post("https://kakwetuburundifafanini.com/add/addjournal.php",
          body: {"nro": nume, "etat": "1"});
    } catch (e) {
      return;
    }
  }

  int test = 0;

  loginworkernumero(String numero) async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/login/loginworkernumero.php",
          body: {
            "nro_w": numero,
          });
var resultat=await compute(_isolate,response.body);
      if (resultat.length == 0) {
      } else {
        addjournal(resultat[0]['nro_w']);
      }
    } catch (e) {}
  }
  loginbossnumero(String numero) async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/login/loginbossnumero.php",
          body: {
            "nro": numero,
          });
var resultat=await compute(_isolate,response.body);
      if (resultat.length == 0) {
        loginworkernumero(numero);
      } else {
        addjournal(resultat[0]['nro']);
      }
    } catch (e) {}
  }

  loginworker(String numero) async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/login/loginworkerentrer.php",
          body: {
            "nro_w": numero,
            "pd": crypterchaine(pass.text.trim().replaceAll(' ', '')),
          });
 var resultat=await compute(_isolate,response.body);
      if (resultat.length == 0) {
        if (test2 == 0) {
          addjournal(mynumber);
        }
        setState(() {
          test2 = test2 + 1;
          help = true;
          number.text = "";
          visible1 = false;
          visible2 = false;
          Fluttertoast.showToast(
              msg: f == 1
                  ? "Mot de passe inconnu"
                  : e == 1
                      ? "Uknown password"
                      : s == 1
                          ? "Nenosiri hiyi Yaijulikani"
                          : "Irijabo kabanga ntirizi",
              backgroundColor: Colors.black,
              textColor: Colors.red,
              fontSize: 20,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
        });
      } else {
        setState(() {
          number.text = changernumero(decrypterchaine(numero));
          test2 = 0;
          help = false;
          isobscure = true;
          visible1 = false;
          visible2 = false;
        });
      }
    } catch (e) {
      setState(() {
        test2 = 0;
        help = true;
        number.text = "";
        visible1 = false;
        visible2 = false;
      });
    }
  }

  loginboss(String numero) async {
    setState(() {
      visible1 = true;
    });
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/login/loginboss.php",
          body: {
            "nro": numero,
            "pd": crypterchaine(pass.text.trim().replaceAll(' ', '')),
          });
  var resultat=await compute(_isolate,response.body);
      if (resultat.length == 0) {
        loginworker(numero);
      } else {
        setState(() {
          number.text = changernumero(decrypterchaine(numero));
          help = false;
          test2 = 0;
          isobscure = true;
          visible1 = false;
          visible2 = false;
        });
      }
    } catch (e) {
      setState(() {
        help = true;
        test2 = 0;
        number.text = "";
        visible1 = false;
        visible2 = false;
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
      });
    }
  }

  loginworkernew(String numero) async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/login/loginworkerentrer.php",
          body: {
            "nro_w": numero,
            "pd": crypterchaine(pass.text.trim().replaceAll(' ', '')),
          });
   var resultat=await compute(_isolate,response.body);
      if (resultat.length == 0) {
        if (test == 0) {
          loginbossnumero(numero);
        }
        setState(() {
          Fluttertoast.showToast(
              msg: f == 1
                  ? "Compte Inconnu"
                  : e == 1
                      ? "Uknown Acount"
                      : s == 1
                          ? "Akaunti Yako Haijurikani"
                          : "Iyi Konte Ntizwi",
              backgroundColor: Colors.black,
              textColor: Colors.red,
              fontSize: 20,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
          test = test + 1;
          visible1 = false;
          visible2 = false;
        });
      } else {
        if (mynumber == "") {
          Numero n = Numero(
              null,
              crypterchaine(
                  rechangernumero(number.text.trim().replaceAll(' ', ''))));
          dbHelper.save(n);
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Page4(
                l: new Langue(k, s, f, e),
                isboss: 0,
                controled: 0,
                numero: resultat[0]['nro_w'],
                password: resultat[0]['pd'],
              ),
            ));
        setState(() {
          test = 0;
          help = true;
          pass.text = "";
          number.text = "";
          visible1 = false;
          visible2 = false;
        });
      }
    } catch (e) {
      setState(() {
        test = 0;
        help = true;
        visible1 = false;
        visible2 = false;
      });
    }
  }

  loginbossnew(String numero) async {
    setState(() {
      visible2 = true;
    });
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/login/loginboss.php",
          body: {
            "nro": numero,
            "pd": crypterchaine(pass.text.trim().replaceAll(' ', '')),
          });
var resultat=await compute(_isolate,response.body);
      if (resultat.length == 0) {
        loginworkernew(numero);
      } else {
        if (mynumber == "") {
          Numero n = Numero(
              null,
              crypterchaine(
                  rechangernumero(number.text.trim().replaceAll(' ', ''))));
          dbHelper.save(n);
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Page4(
                l: new Langue(k, s, f, e),
                isboss: 1,
                controled: 0,
                numero: resultat[0]['nro'],
                password: resultat[0]['pd'],
              ),
            ));
        setState(() {
          test = 0;
          help = true;
          pass.text = "";
          number.text = "";
          etat = "";
          visible1 = false;
          visible2 = false;
        });
      }
    } catch (e) {
      setState(() {
        help = true;
        test = 0;
        visible1 = false;
        visible2 = false;
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
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
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                etat == "changed"
                                    ? e == 1
                                        ? Text(
                                            'Now Your Password is Known by your Boss Please Change it',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center)
                                        : s == 1
                                            ? Text(
                                                'Boss Wako Anajua Nenosiri Yako Tafahdali Badirisha',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              )
                                            : f == 1
                                                ? Text(
                                                    'Maintenent Votre Boss Connait Votre Mot de passe Veillez le changer',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center)
                                                : Text(
                                                    "Ubu Boss wawe arazi Ijambo kabanga Ryawe Usabwe kurihindura",
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center)
                                    : Text(""),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Container(
                                    width: 450,
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.green, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      child: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: <Widget>[
                                              InkWell(
                                                splashColor: Colors.black,
                                                onTap: () {
                                                  dismisskeyboard();
                                                  refreshList();
                                                  selectpublicites();
                                                  selectetatworker(mynumber);
                                                  if (pass.text != "") {
                                                    if (mynumber != "") {
                                                      if (test2 <= 3) {
                                                        loginboss(mynumber);
                                                      } else {
                                                        setState(() {
                                                          help = true;
                                                          test2 = test2 + 1;
                                                        });
                                                        Fluttertoast.showToast(
                                                            msg: f == 1
                                                                ? "Entrez Votre Numero"
                                                                : e == 1
                                                                    ? "Enter Your Number"
                                                                    : s == 1
                                                                        ? "Andika Nambari Yako"
                                                                        : "Andika Inomero Yawe",
                                                            backgroundColor:
                                                                Colors.black,
                                                            textColor:
                                                                Colors.red,
                                                            fontSize: 20,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            toastLength: Toast
                                                                .LENGTH_LONG);
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: f == 1
                                                              ? "Desolé,Entrez Votre Numero,Ou bien Créer Un nouveau Compte"
                                                              : e == 1
                                                                  ? "Sorry,Enter Your Number,or Create a new Acount"
                                                                  : s == 1
                                                                      ? "Samahani,Ingiza Nambari Yako au Unda Akaunti Yampya"
                                                                      : "Nimwinjinze Inomero Yanyu Canke Mwugurure Konte nshasha",
                                                          backgroundColor:
                                                              Colors.black,
                                                          textColor: Colors.red,
                                                          fontSize: 20,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          toastLength: Toast
                                                              .LENGTH_LONG);
                                                    }
                                                  } else {
                                                    refreshList();
                                                    Fluttertoast.showToast(
                                                        msg: f == 1
                                                            ? "Entrez d'abord Votre Mot De passe"
                                                            : e == 1
                                                                ? "Sorry,Enter Your Password"
                                                                : s == 1
                                                                    ? "Samahani,Ingiza Nenosiri"
                                                                    : "Banza Wandike Ijambo kabanga",
                                                        backgroundColor:
                                                            Colors.black,
                                                        textColor: Colors.red,
                                                        fontSize: 20,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        toastLength:
                                                            Toast.LENGTH_LONG);
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: 150,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    child: Card(
                                                      margin: EdgeInsets.all(4),
                                                      color: Colors.black,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      child: f == 1
                                                          ? Text(
                                                              "Rappelle-Moi",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          : e == 1
                                                              ? Text(
                                                                  "Remind me",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .red),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              : s == 1
                                                                  ? Text(
                                                                      "Nikumbushe",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.red),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )
                                                                  : Text(
                                                                      "Nyibutsa",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.red),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Visibility(
                                                    visible: visible1,
                                                    child: Center(
                                                        child:
                                                            LinearProgressIndicator(
                                                      backgroundColor:
                                                          Colors.cyanAccent,
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.red),
                                                    ))),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 8),
                                                child: TextFormField(
                                                  focusNode: focusnode1,
                                                  inputFormatters: [
                                                    new FilteringTextInputFormatter
                                                            .allow(
                                                        RegExp("[0-9a-zA-Z@]"))
                                                  ],
                                                  enabled: help,
                                                  controller: number,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                  maxLength: 25,
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                        Icons.account_box,
                                                        color: Colors.black,
                                                      ),
                                                      labelText: f == 1
                                                          ? "Numero"
                                                          : e == 1
                                                              ? "Number"
                                                              : s == 1
                                                                  ? "Nambari"
                                                                  : "Inomero",
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontStyle: FontStyle
                                                              .italic)),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return f == 1
                                                          ? 'Entrez Votre Numero'
                                                          : e == 1
                                                              ? 'Enter Your Number'
                                                              : s == 1
                                                                  ? 'Ingiza Nambari Yako'
                                                                  : 'Shiramwo Inomero Yawe';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: TextFormField(
                                                  focusNode: focusnode,
                                                  inputFormatters: [
                                                    new FilteringTextInputFormatter
                                                            .deny(
                                                        RegExp(
                                                            "[#*'\"/&();=|@]"))
                                                  ],
                                                  controller: pass,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  obscureText: isobscure,
                                                  textAlign: TextAlign.center,
                                                  maxLength: 15,
                                                  decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                        Icons.lock_outlined,
                                                        color: Colors.black,
                                                      ),
                                                      suffixIcon:
                                                          GestureDetector(
                                                        onTap: () {
                                                          if (isobscure) {
                                                            if (number
                                                                .text.isEmpty) {
                                                              setState(() {
                                                                isobscure =
                                                                    false;
                                                              });
                                                            }
                                                          } else {
                                                            setState(() {
                                                              isobscure = true;
                                                            });
                                                          }
                                                        },
                                                        child: Icon(
                                                            isobscure
                                                                ? Icons
                                                                    .visibility_off
                                                                : Icons
                                                                    .visibility,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      labelText: f == 1
                                                          ? "Mot de Passe"
                                                          : e == 1
                                                              ? "PassWord"
                                                              : s == 1
                                                                  ? "Nenosiri"
                                                                  : "Kabanga",
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontStyle: FontStyle
                                                              .italic)),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return f == 1
                                                          ? 'Entrez Votre Mot de Passe'
                                                          : e == 1
                                                              ? 'Enter Your PassWord'
                                                              : s == 1
                                                                  ? 'Ingiza nenosiri'
                                                                  : 'Shiramwo Ijambo Kabanga';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  splashColor: Colors.white,
                                                  onTap: () {
                                                    dismisskeyboard();
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      if (test <= 3) {
                                                        loginbossnew(crypterchaine(
                                                            rechangernumero(
                                                                number.text
                                                                    .trim()
                                                                    .replaceAll(
                                                                        ' ',
                                                                        ''))));
                                                      } else {
                                                        setState(() {
                                                          test = test + 1;
                                                        });
                                                        refreshList();
                                                        Fluttertoast.showToast(
                                                            msg: f == 1
                                                                ? "Desolé,Vous avez Echoué Plusieurs fois et Je l'ai signalé,Si vous voulez continuer Fermez Kakwetu et relancer"
                                                                : e == 1
                                                                    ? "Sorry,You failed many times and I sent a report, if you want to continue close Kakwetu and reopen it"
                                                                    : s == 1
                                                                        ? "Samahani,Umejidanganya Malanyingi na Nimetuma ripoti, Ukitaka kujaribu tena Funga Kakwetu Kisha Ufungue tena "
                                                                        : "Muradutunga,Mwihenze Kenshi Kandi twabitanze Mucegeranyo,Mushaka kubandanya Nimwugare Kakwetu Muce mwongera Mwugurure",
                                                            backgroundColor:
                                                                Colors.black,
                                                            textColor:
                                                                Colors.red,
                                                            fontSize: 20,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            toastLength: Toast
                                                                .LENGTH_LONG);
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 250,
                                                    height: 45,
                                                    color: Colors.green,
                                                    alignment: Alignment.center,
                                                    child: e == 1
                                                        ? Text(
                                                            'Enter',
                                                            style: TextStyle(
                                                                fontSize: 40,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : s == 1
                                                            ? Text(
                                                                'Ingia',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        40,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : f == 1
                                                                ? Text(
                                                                    'Entrer',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            40,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                : Text(
                                                                    'Injira',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            40,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Visibility(
                                                    visible: visible2,
                                                    child: Center(
                                                        child:
                                                            LinearProgressIndicator(
                                                      backgroundColor:
                                                          Colors.cyanAccent,
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.red),
                                                    ))),
                                              ),
                                              SizedBox(
                                                height: 80,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  splashColor: Colors.white,
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Page2(
                                                                    l: new Langue(
                                                                        k,
                                                                        s,
                                                                        f,
                                                                        e))));
                                                  },
                                                  child: Container(
                                                    width: 200,
                                                    height: 35,
                                                    color: Colors.orange,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: e == 1
                                                        ? Text(
                                                            'New Acount',
                                                            style: TextStyle(
                                                                fontSize: 25,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : s == 1
                                                            ? Text(
                                                                'Akaunti Ya Mpya',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        25,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : f == 1
                                                                ? Text(
                                                                    'Nouveau Compte',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                : Text(
                                                                    'Konte Nshasha',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon:
                                            Image.asset("assets/whatsapp.png"),
                                        onPressed: () {
                                          launchWhatsApp(
                                              phone: "+25769927086",
                                              message: "my name is fabien");
                                        }),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Card(
                                          elevation: 0,
                                          margin: EdgeInsets.all(5),
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.white24,
                                                  width: 30),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: f == 1
                                                      ? Text(
                                                          franc, //message from database
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.yellow,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      : e == 1
                                                          ? Text(
                                                             engr, //message from database
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .yellow,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          : s == 1
                                                              ? Text(
                                                                 swahi, //message from database
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .yellow,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              : Text(
                                                                 kirund, //message from database
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .yellow,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                ))),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        if (k == 0) {
                                          setState(() {
                                            k = 1;
                                            f = 0;
                                            s = 0;
                                            e = 0;
                                            selectpublicites();
                                          });
                                        } else {
                                          setState(() {
                                            k = 0;
                                            f = 0;
                                            s = 0;
                                            e = 0;
                                          });
                                        }
                                      },
                                      child: Container(
                                        color: k == 1
                                            ? Colors.greenAccent
                                            : Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "KIR",
                                              style: TextStyle(
                                                  fontSize: k == 1 ? 25 : 18,
                                                  color: k == 1
                                                      ? Colors.red
                                                      : Colors.blueAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Flag(
                                              'BI',
                                              height: 20,
                                              width: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (s == 0) {
                                          setState(() {
                                            k = 0;
                                            f = 0;
                                            s = 1;
                                            e = 0;
                                            selectpublicites();
                                          });
                                        } else {
                                          setState(() {
                                            k = 0;
                                            f = 0;
                                            s = 0;
                                            e = 0;
                                          });
                                        }
                                      },
                                      child: Container(
                                        color: s == 1
                                            ? Colors.greenAccent
                                            : Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "SWA",
                                              style: TextStyle(
                                                  fontSize: s == 1 ? 25 : 18,
                                                  color: s == 1
                                                      ? Colors.red
                                                      : Colors.blueAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Flag(
                                              'TZ',
                                              height: 20,
                                              width: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (e == 0) {
                                          setState(() {
                                            k = 0;
                                            f = 0;
                                            s = 0;
                                            e = 1;
                                            selectpublicites();
                                          });
                                        } else {
                                          setState(() {
                                            k = 0;
                                            f = 0;
                                            s = 0;
                                            e = 0;
                                          });
                                        }
                                      },
                                      child: Container(
                                        color: e == 1
                                            ? Colors.greenAccent
                                            : Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "ENG",
                                              style: TextStyle(
                                                  fontSize: e == 1 ? 25 : 18,
                                                  color: e == 1
                                                      ? Colors.red
                                                      : Colors.blueAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Flag(
                                              'US',
                                              height: 20,
                                              width: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (f == 0) {
                                          setState(() {
                                            k = 0;
                                            f = 1;
                                            s = 0;
                                            e = 0;
                                            selectpublicites();
                                          });
                                        } else {
                                          setState(() {
                                            k = 0;
                                            f = 0;
                                            s = 0;
                                            e = 0;
                                          });
                                        }
                                      },
                                      child: Container(
                                        color: f == 1
                                            ? Colors.greenAccent
                                            : Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "FRA",
                                              style: TextStyle(
                                                  fontSize: f == 1 ? 25 : 18,
                                                  color: f == 1
                                                      ? Colors.red
                                                      : Colors.blueAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Flag(
                                              'FR',
                                              height: 20,
                                              width: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: e == 1
                                ? Text("You Are Offline",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 40),
                                    textAlign: TextAlign.center)
                                : f == 1
                                    ? Text("Connectez-Vous",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 40),
                                        textAlign: TextAlign.center)
                                    : s == 1
                                        ? Text("Fungua Internet",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 40),
                                            textAlign: TextAlign.center)
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

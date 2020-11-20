import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakwetu/page3.dart';
import '../servicepayement.dart';
import 'package:flutter/foundation.dart';
class Probleme extends StatefulWidget {
  final Langue l;
  final String numero;
  final String password;
  final int isboss;
  final int duree;
  final int controled;
  final String worker;
  Probleme(
      {Key key,
      this.l,
      this.numero,
      this.password,
      this.isboss,
      this.duree,
      this.controled,
      this.worker})
      : super(key: key);

  @override
  _ProblemeState createState() => _ProblemeState();
}

class _ProblemeState extends State<Probleme> {
  TextEditingController name1 = new TextEditingController();
  TextEditingController name2 = new TextEditingController();
  TextEditingController qte = new TextEditingController();
  TextEditingController add = new TextEditingController();
  Timer _timer;
  StreamController<List> _streamcontroller1 = StreamController<List>();
  StreamController<List> _streamcontroller = StreamController<List>();
  ScrollController _scrollcontroller1 = new ScrollController();
  ScrollController _scrollcontroller = new ScrollController();
    TextEditingController resultat1 = new TextEditingController();
  bool ispop = true;
  FocusNode focusnode;
  FocusNode focusnode1;
  @override
  void initState() {
    focusnode=FocusNode();
    focusnode1=FocusNode();
    focusnode.addListener(() { });
    focusnode1.addListener(() { });
    selectproblem();
    selectstock();
    _timer = Timer.periodic(const Duration(seconds:5), (timer) {
    selectproblem();
    selectstock();
    });
    super.initState();
  }
 dismisskeyboard(){
  focusnode.unfocus();
  focusnode1.unfocus();
}
  @override
  void dispose() {
    focusnode1.dispose();
    focusnode.dispose();
    name1.dispose();
    _streamcontroller.close();
    _streamcontroller1.close();
    name2.dispose();
    if (_timer.isActive) _timer.cancel();
    qte.dispose();
    add.clear();
    stock.clear();
    _scrollcontroller1.dispose();
    _scrollcontroller.dispose();
    probleme.clear();
    resultat1.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  var stock = [];
  var  probleme = [];
   static _isolate(String body){
return jsonDecode(body);
  }
selectstock() async {
    try {
      final response = await http
          .post("https://kakwetuburundifafanini.com/gs/selectstock.php", body: {
        "nro": widget.numero,
      });
      var resultat=await compute(_isolate,response.body);
      setState(() {
      _streamcontroller1.add(resultat);
        stock =resultat;
      });
    } catch (e) {
      setState(() {
        stock = [];
      });
    }
  }
 selectproblem() async {
    try {
      final response = await http.post(
          "https://kakwetuburundifafanini.com/gp/selectproblem.php",
          body: {
            "nro": widget.numero,
          });
      var resultat=await compute(_isolate,response.body);
      setState(() {
    _streamcontroller.add(resultat);
        probleme =resultat;
      });
    } catch (e) {
      setState(() {
         probleme = [];
      });
    }
  }
firstcheckprobleme(){
    setState(() {
      ispop = false;
      visible1 = true;
    });
    try {
      if (name2.text.isNotEmpty &&
          name1.text.isNotEmpty &&
          (double.parse(qte.text) > 0) &&
          (double.parse(add.text) >= 0) &&
          (double.parse(resultat1.text) >= double.parse(qte.text))) {
    http.post(
            "https://kakwetuburundifafanini.com/fpr/firstcheckprobleme.php",
            body: {
              "ajout": add.text.trim().replaceAll(' ', ''),
              "nro": widget.numero,
              "nom_g": name2.text.trim().replaceAll(' ', ''),
              "qte": qte.text.trim().replaceAll(' ', ''),
              "nom_p": name1.text.trim().replaceAll(' ', ''),
              "q_encien": qte.text.trim().replaceAll(' ', ''),
            }).then((value){
          if(value.statusCode==200){
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
              selectproblem();
              selectstock();
          }else{
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
        });
            setState(() {
          add.text = "";
          qte.text = "";
          name1.text = "";
          name2.text = "";
          visible1 = false;
          ispop = true;
          dismisskeyboard();
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
          ispop = true;
          dismisskeyboard();
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
        ispop = true;
        dismisskeyboard();
      });
    }
  }

deleteprobleme(String nom1, String nom2, String date){
    setState(() {
      ispop = false;
    });
    try {
     http.post(
          "https://kakwetuburundifafanini.com/dpr/deleteprobleme.php",
          body: {
            "nom_p": nom1,
            "nom_g": nom2,
            "nro": widget.numero,
            "dat": date,
          });
      setState(() {
        ispop = true;
      });
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
        ispop = true;
      });
      return;
    }
  }

  paspayemessageechec() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Desolé Il y a un snap.data,Réessayez plus tard",
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

  paspayemessage() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Votre paquet a expiré Vous Voulez payer encore ?",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text(
                  "Your Packet has Finished Do you want to pay once again ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Mfuko wako Umeisha Munataka kulipa tena ?",
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

  bool visible1 = false;
  void messagevalidation() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text(
              "Vous Voulez Changer " +
                  qte.text +
                  " " +
                  name1.text +
                  " par " +
                  qte.text +
                  " " +
                  name2.text +
                  " ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text(
                  "Do you want to Change " +
                      qte.text +
                      "  " +
                      name1.text +
                      " by " +
                      qte.text +
                      "  " +
                      name2.text +
                      " ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text(
                      "Unataka kubadilisha " +
                          name1.text +
                          " " +
                          qte.text +
                          " kwa " +
                          name2.text +
                          " " +
                          qte.text +
                          " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka Guhindura " +
                          name1.text +
                          " " +
                          qte.text +
                          " na " +
                          name2.text +
                          " " +
                          qte.text +
                          " ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            setState(() {
              name1.text = "";
              qte.text = "";
              name2.text = "";
              add.text = "";
            });

            Navigator.pop(context);
          },
          child: widget.l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Hapana",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center)
                      : Text("Oya",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center),
        ),
        MaterialButton(
          onPressed: () {
            dismisskeyboard();
            try {
              if ((double.parse(qte.text.trim()) > 0) &&
                  (double.parse(add.text.trim()) >= 0)) {
                Navigator.pop(context);
                if (double.parse(resultat1.text) >=
                    double.parse(qte.text.trim().replaceAll(' ', ''))) {
                  if (widget.isboss == 0) {
                    if (widget.worker == "y") {
                      firstcheckprobleme();
                    } else if (widget.worker == "n") {
                      setState(() {
                        Fluttertoast.showToast(
                            msg: widget.l.fra == 1
                                ? "Desolé,Vous Avez pas L'autorisation d'enregistrer,Contacter Votre Boss"
                                : widget.l.eng == 1
                                    ? "Sorry,You don't have a permission of registering,please Contact your Boss"
                                    : widget.l.swa == 1
                                        ? "Samahani,Umenyanganywa Ruhusa Rwakuingiza Bidhaa,Wasiriana kwanza na Boss wako"
                                        : "Muradutunga,Mwatswe Uburenganzira Boss,Nimubaze Boss Wanyu",
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_LONG);
                        visible1 = false;
                        ispop = true;
                        Navigator.pop(context);
                      });
                    } else {
                      setState(() {
                        Fluttertoast.showToast(
                            msg: widget.l.fra == 1
                                ? "Reessayez encore"
                                : widget.l.eng == 1
                                    ? "Retry"
                                    : widget.l.swa == 1
                                        ? "Bonyeza tena"
                                        : "Subira Wemeze",
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_LONG);
                        visible1 = false;
                        ispop = true;
                      });
                    }
                  } else {
                 firstcheckprobleme();
                  }
                } else {
                  setState(() {
                    Fluttertoast.showToast(
                        msg: widget.l.fra == 1
                            ? "Verifiez le stock de " + name2.text
                            : widget.l.eng == 1
                                ? "Check the stock of " + name2.text
                                : widget.l.swa == 1
                                    ? "Cunguza Hisa ya " + name2.text
                                    : "Suzuma Sitoke ya " + name2.text,
                        backgroundColor: Colors.red,
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_LONG);
                    visible1 = false;
                    ispop = true;
                  });
                }
              } else {
                Fluttertoast.showToast(
                    msg: widget.l.fra == 1
                        ? "Soyez Serieux!!!!! Cette Valeur est Invalide"
                        : widget.l.eng == 1
                            ? "Be Serious!!!!! That value is not valid"
                            : widget.l.swa == 1
                                ? "Samahani!!!! Kiasi hico Hatukikubari"
                                : "Muradutunga!!! Ico gitigiri Nticemewe",
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.CENTER,
                    toastLength: Toast.LENGTH_LONG);
              }
            } catch (e) {
              Fluttertoast.showToast(
                  msg: widget.l.fra == 1
                      ? "utilisez . comme virgule(pour les decimaux)"
                      : widget.l.eng == 1
                          ? "use . for double"
                          : widget.l.swa == 1
                              ? "Tumia . kama mkato"
                              : "Nimukoreshe . Mukwandika igitigiri kirimwo ibice",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG);
            }
          },
          child: widget.l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
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

  void messagevalidersuppression(String nomp, String nomg, String date,int i) {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: widget.l.fra == 1
          ? Text("Vous Voulez Vraiment Supprimer ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Do you Want to delete ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Unataka Kuondoa ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka guhanagura  ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: widget.l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Hapana",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center)
                      : Text("Oya",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center),
        ),
        MaterialButton(
          onPressed: () {
            if (widget.duree >= 0) {
              Navigator.pop(context);
              deleteprobleme(nomp, nomg, date);
            } else {
              Navigator.pop(context);
              if (widget.duree != -1002) {
                paspayemessage();
              } else {
                paspayemessageechec();
              }
            }
          },
          child: widget.l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
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

  bool _isontop = true;
  _scrolltop() {
    _scrollcontroller.animateTo(_scrollcontroller.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    setState(() {
      _isontop = true;
    });
  }

  _scrolldown() {
    _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent,
        duration: Duration(seconds: stock.isEmpty ? 1 :stock.length*2),
        curve: Curves.easeOut);
    setState(() {
      _isontop = false;
    });
  }

  bool _isontop1 = true;
  _scrolltop1() {
    _scrollcontroller1.animateTo(_scrollcontroller1.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    setState(() {
      _isontop1 = true;
    });
  }

  _scrolldown1() {
    _scrollcontroller1.animateTo(_scrollcontroller1.position.maxScrollExtent,
        duration: Duration(seconds:probleme.isEmpty ? 1 :probleme.length*2),
        curve: Curves.easeOut);
    setState(() {
      _isontop1 = false;
    });
  }

  void messagevalidation1() {
    AlertDialog alerte = new AlertDialog(
      content: widget.l.fra == 1
          ? Text("Vous Voulez Fermer Tout ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
              textAlign: TextAlign.center)
          : widget.l.eng == 1
              ? Text("Do you want to Close All ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center)
              : widget.l.swa == 1
                  ? Text("Unataka Kufunga vyote ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka Kwugara Vyose ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            setState(() {
              ispop = true;
              Navigator.pop(context);
            });
          },
          child: widget.l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Hapana",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center)
                      : Text("Oya",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center),
        ),
        MaterialButton(
          onPressed: () {
            setState(() {
              ispop = true;
              Navigator.pop(context);
              Navigator.pop(context);
            });
          },
          child: widget.l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  textAlign: TextAlign.center)
              : widget.l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      textAlign: TextAlign.center)
                  : widget.l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
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

  Future<bool> _willpop() async {
    return Future.value(ispop);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (ispop) {
          messagevalidation1();
        }
        return _willpop();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: widget.controled == 1 ? true : false,
            child: StreamBuilder<List>(
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
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 20),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.grey, width: 0),
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Colors.white24,
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      showSearch(
                                          context: context,
                                          delegate: DataSearch2(
                                              context,
                                              widget.l,
                                              widget.numero,
                                              widget.duree,
                                              snap.data,
                                              widget.isboss));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        widget.l.fra == 1
                                            ? Text(
                                                "Chercher",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )
                                            : widget.l.eng == 1
                                                ? Text(
                                                    "Search",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )
                                                : widget.l.swa == 1
                                                    ? Text(
                                                        "Tafuta",
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Text(
                                                        "Higa",
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.search),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Scrollbar(
                                child: ListView.builder(
                                    controller: _scrollcontroller1,
                                    physics: BouncingScrollPhysics(),
                                    itemCount:
                                        snap.data.length,
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        splashColor: Colors.white,
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: widget.l.fra == 1
                                                      ? snap.data[i]['jour']
                                                                  .toString() ==
                                                              '1'
                                                          ? Text(
                                                              "Dimanche le " +
                                                                  snap.data[i]
                                                                      ['dat'] +
                                                                  " : ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white))
                                                          : snap.data[i]['jour']
                                                                      .toString() ==
                                                                  '2'
                                                              ? Text("Lundi le " + snap.data[i]['dat'] + " : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight.bold,
                                                                      color: Colors.white))
                                                              : snap.data[i]['jour'].toString() == '3'
                                                                  ? Text("Mardi le " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                  : snap.data[i]['jour'].toString() == '4'
                                                                      ? Text("Mercredi le " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                      : snap.data[i]['jour'].toString() == '5'
                                                                          ? Text("Jeudi le " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                          : snap.data[i]['jour'].toString() == '6'
                                                                              ? Text("Vendredi le " + snap.data[i]['dat'] + ":", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                              : Text("Samedi le " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                      : widget.l.eng == 1
                                                          ? snap.data[i]['jour'].toString() == '1'
                                                              ? Text("Sunday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                              : snap.data[i]['jour'].toString() == '2'
                                                                  ? Text("Monday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                  : snap.data[i]['jour'].toString() == '3'
                                                                      ? Text("Tuesday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                      : snap.data[i]['jour'].toString() == '4'
                                                                          ? Text("Wednesday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                          : snap.data[i]['jour'].toString() == '5'
                                                                              ? Text("Thursday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                              : snap.data[i]['jour'].toString() == '6'
                                                                                  ? Text("Friday the " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                  : Text("Saturday the " + snap.data[i]['dat'] + ":", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                          : widget.l.swa == 1
                                                              ? snap.data[i]['jour'].toString() == '1'
                                                                  ? Text("Jumapili tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                  : snap.data[i]['jour'].toString() == '2'
                                                                      ? Text("Jumatatu tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                      : snap.data[i]['jour'].toString() == '3'
                                                                          ? Text("Jumanne tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                          : snap.data[i]['jour'].toString() == '4'
                                                                              ? Text("Jumatano tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                              : snap.data[i]['jour'].toString() == '5'
                                                                                  ? Text("Alhamisi tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                  : snap.data[i]['jour'].toString() == '6'
                                                                                      ? Text("Ijumaa tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                      : Text("Jumamosi tarehe " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                              : snap.data[i]['jour'].toString() == '1'
                                                                  ? Text("Kuw'Imana itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                  : snap.data[i]['jour'].toString() == '2'
                                                                      ? Text("Kuwambere Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                      : snap.data[i]['jour'].toString() == '3'
                                                                          ? Text("Kuwakabiri Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                          : snap.data[i]['jour'].toString() == '4'
                                                                              ? Text("Kuwagatatu Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                              : snap.data[i]['jour'].toString() == '5'
                                                                                  ? Text("Kuwakane Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                  : snap.data[i]['jour'].toString() == '6'
                                                                                      ? Text("Kuwagatanu Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                                                      : Text("Kuwagatandatu Itariki " + snap.data[i]['dat'] + " : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: widget.l.fra == 1
                                                    ? Text(
                                                        "En panne: " +
                                                            snap.data[i]
                                                                ['nom_p'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : widget.l.eng == 1
                                                        ? Text(
                                                            "With Problem: " +
                                                                snap.data[i]
                                                                    ['nom_p'],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : widget.l.swa == 1
                                                            ? Text(
                                                                "Vyenye tatizo: " +
                                                                    snap.data[i][
                                                                        'nom_p'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            : Text(
                                                                "Ibifise ikibazo: " +
                                                                    snap.data[i][
                                                                        'nom_p'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: widget.l.fra == 1
                                                    ? Text(
                                                        "Quantité: " +
                                                            snap.data[i]['qte'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : widget.l.eng == 1
                                                        ? Text(
                                                            "Quantity: " +
                                                                snap.data[i]
                                                                    ['qte'],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : widget.l.swa == 1
                                                            ? Text(
                                                                "Kiasi: " +
                                                                    snap.data[i]
                                                                        ['qte'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            : Text(
                                                                "Igitigiri: " +
                                                                    snap.data[i]
                                                                        ['qte'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: widget.l.fra == 1
                                                    ? Text(
                                                        "En bon etat: " +
                                                            snap.data[i]
                                                                ['nom_g'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : widget.l.eng == 1
                                                        ? Text(
                                                            "Good products: " +
                                                                snap.data[i]
                                                                    ['nom_g'],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : widget.l.swa == 1
                                                            ? Text(
                                                                "Vizuri: " +
                                                                    snap.data[i][
                                                                        'nom_g'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            : Text(
                                                                "Ibimeze neza: " +
                                                                    snap.data[i][
                                                                        'nom_g'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: widget.l.fra == 1
                                                    ? Text(
                                                        "Montant Ajouté: " +
                                                            snap.data[i]
                                                                ['ajout'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : widget.l.eng == 1
                                                        ? Text(
                                                            "Add amount : " +
                                                                snap.data[i]
                                                                    ['ajout'],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : widget.l.swa == 1
                                                            ? Text(
                                                                "Aliyo ongeza: " +
                                                                    snap.data[i][
                                                                        'ajout'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            : Text(
                                                                "Ayongewe: " +
                                                                    snap.data[i][
                                                                        'ajout'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      messagevalidersuppression(
                                                        snap.data[i]['nom_p'],
                                                        snap.data[i]['nom_g'],
                                                        snap.data[i]['dat'],
                                                        i
                                                      );
                                                    }),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )),
                              FloatingActionButton(
                                onPressed:
                                    _isontop1 ? _scrolldown1 : _scrolltop1,
                                child: Icon(_isontop1
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
          ),
          Visibility(
            visible: widget.controled == 0 ? true : false,
            child: StreamBuilder<List>(
                stream: _streamcontroller1.stream,
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
                                    itemCount:snap.data.length,
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        splashColor: Colors.white,
                                        onLongPress: () {
                                          setState(() {
                                            name1.text = "";
                                            name2.text = "";
                                          });
                                        },
                                        onTap: () {
                                          setState(() {
                                            resultat1.text = (snap.data[i]['q_encien']).toString();
                                          });
                                          if (name1.text.isEmpty) {
                                            setState(() {
                                              name1.text = snap.data[i]['nom'];
                                            });
                                          } else if (name2.text.isEmpty) {
                                            setState(() {
                                              name2.text = snap.data[i]['nom'];
                                            });
                                          } else {
                                            setState(() {
                                              name1.text = snap.data[i]['nom'];
                                              name2.text = "";
                                            });
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  snap.data[i]['nom'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: widget.l.fra == 1
                                                    ? Text(
                                                        "stock:" +
                                                            snap.data[i]
                                                                ['q_encien'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : widget.l.eng == 1
                                                        ? Text(
                                                            "stock:" +
                                                                snap.data[i][
                                                                    'q_encien'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        : widget.l.swa == 1
                                                            ? Text(
                                                                "Hisa:" +
                                                                    snap.data[i][
                                                                        'q_encien'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            : Text(
                                                                "Sitoke:" +
                                                                    snap.data[i][
                                                                        'q_encien'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )),
                              FloatingActionButton(
                                onPressed: _isontop ? _scrolldown : _scrolltop,
                                child: Icon(_isontop
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
          ),
          Visibility(
            visible: widget.controled == 0 ? true : false,
            child: Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 3),
                  child: Container(
                    width: 175,
                    child: Card(
                      color: Colors.white30,
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 20),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.grey, width: 0),
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Colors.white24,
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                  showSearch(
          context: context,
          delegate:
              DataSearch1(name1, name2, context, widget.l,stock, resultat1));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        widget.l.fra == 1
                                            ? Text(
                                                "Chercher",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )
                                            : widget.l.eng == 1
                                                ? Text(
                                                    "Search",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )
                                                : widget.l.swa == 1
                                                    ? Text(
                                                        "Tafuta",
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Text(
                                                        "Higa",
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.search),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: TextFormField(
                                      enabled: false,
                                      controller: name1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          labelText: widget.l.fra == 1
                                              ? "Produit en panne"
                                              : widget.l.eng == 1
                                                  ? "Product with problem"
                                                  : widget.l.swa == 1
                                                      ? "Cakubadirishwa"
                                                      : "Ikidandazwa case",
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return widget.l.fra == 1
                                              ? 'choisissez le produit'
                                              : widget.l.eng == 1
                                                  ? 'choose product'
                                                  : widget.l.swa == 1
                                                      ? 'chagua bidhaa'
                                                      : 'hitamwo izina';
                                        }
                                        return null;
                                      }),
                                ),
                              ),
                              Container(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: TextFormField(
                                    focusNode: focusnode,
                                    autofocus: false,
                                    controller: qte,
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                        inputFormatters: [
                                    new FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                                  ],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                        labelText: widget.l.fra == 1
                                            ? "Quantité"
                                            : widget.l.eng == 1
                                                ? "Quantity"
                                                : widget.l.swa == 1
                                                    ? "Wingi"
                                                    : "Igitigiri",
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                            fontStyle: FontStyle.italic)),
                                    validator: (value) {
                                      if ((value.isEmpty) ||
                                          (qte.text == "0")) {
                                        return widget.l.fra == 1
                                            ? 'Entrez la Quantité '
                                            : widget.l.eng == 1
                                                ? 'Enter a Quantity'
                                                : widget.l.swa == 1
                                                    ? 'Andika wingi wake'
                                                    : 'Shiramwo uko bingana';
                                      } else if (qte.text.contains(",")) {
                                        return widget.l.fra == 1
                                            ? 'Utilisez .'
                                            : widget.l.eng == 1
                                                ? 'Use .'
                                                : widget.l.swa == 1
                                                    ? 'Tumiya .'
                                                    : 'Koresha .';
                                      } else if (qte.text.contains("-")) {
                                        return widget.l.fra == 1
                                            ? 'Enlevez -'
                                            : widget.l.eng == 1
                                                ? 'remove -'
                                                : widget.l.swa == 1
                                                    ? 'tosha -'
                                                    : 'kuramwo -';
                                      } else if (qte.text.contains(" ")) {
                                        return widget.l.fra == 1
                                            ? "Enlevez l'espace"
                                            : widget.l.eng == 1
                                                ? 'remove space'
                                                : widget.l.swa == 1
                                                    ? 'ambatanisha wingi'
                                                    : 'Fatanya';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: TextFormField(
                                      enabled: false,
                                      controller: name2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          labelText: widget.l.fra == 1
                                              ? "Produit en Bon état"
                                              : widget.l.eng == 1
                                                  ? "Safe Product"
                                                  : widget.l.swa == 1
                                                      ? "Cenye kiko sawa"
                                                      : "Igikomeye",
                                          border: OutlineInputBorder(),
                                          labelStyle: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return widget.l.fra == 1
                                              ? 'choisissez le produit'
                                              : widget.l.eng == 1
                                                  ? 'choose product'
                                                  : widget.l.swa == 1
                                                      ? 'chagua bidhaa'
                                                      : 'hitamwo izina';
                                        }
                                        return null;
                                      }),
                                ),
                              ),
                              Container(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: TextFormField(
                                    focusNode: focusnode1,
                                    autofocus: false,
                                    controller: add,
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                        inputFormatters: [
                                    new FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                                  ],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                        labelText: widget.l.fra == 1
                                            ? "Montant ajouté"
                                            : widget.l.eng == 1
                                                ? "Add Amount"
                                                : widget.l.swa == 1
                                                    ? "Pesa Anaongeza"
                                                    : "Ayo Yongeye",
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                            fontStyle: FontStyle.italic)),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return widget.l.fra == 1
                                            ? 'Entrez le Montant ajouté'
                                            : widget.l.eng == 1
                                                ? 'Enter Add Amount'
                                                : widget.l.swa == 1
                                                    ? 'Andika Pesa Anaongeza'
                                                    : 'Andika Ayo Yongeye';
                                      } else if (add.text.contains(",")) {
                                        return widget.l.fra == 1
                                            ? 'Utilisez .'
                                            : widget.l.eng == 1
                                                ? 'Use .'
                                                : widget.l.swa == 1
                                                    ? 'Tumiya .'
                                                    : 'Koresha .';
                                      } else if (add.text.contains("-")) {
                                        return widget.l.fra == 1
                                            ? 'Enlevez -'
                                            : widget.l.eng == 1
                                                ? 'remove -'
                                                : widget.l.swa == 1
                                                    ? 'tosha -'
                                                    : 'kuramwo -';
                                      } else if (add.text.contains(" ")) {
                                        return widget.l.fra == 1
                                            ? "Enlevez l'espace"
                                            : widget.l.eng == 1
                                                ? 'remove a space'
                                                : widget.l.swa == 1
                                                    ? 'ambatanisha wingi'
                                                    : 'Fatanya';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                              visible:false,
                             child: TextFormField(
                                controller:resultat1,
                              ),
                            ),
                              InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  if (widget.duree >= 0) {
                                    if (_formKey.currentState.validate()) {
                                      dismisskeyboard();
                                      if (name1.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: widget.l.fra == 1
                                                ? "chosissez le produit en panne"
                                                : widget.l.eng == 1
                                                    ? "Choose a product wich has problem"
                                                    : widget.l.swa == 1
                                                        ? "chagua jina la bidha yenye tatizo"
                                                        : "Muhitemwo izina rifise ikibazo",
                                            backgroundColor: Colors.red,
                                            gravity: ToastGravity.CENTER,
                                            toastLength: Toast.LENGTH_LONG);
                                      } else if (qte.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: widget.l.fra == 1
                                                ? "Ecrivez la quatité"
                                                : widget.l.eng == 1
                                                    ? "Write a quantity"
                                                    : widget.l.swa == 1
                                                        ? "Andika kiasi"
                                                        : "Mwandike igitigiri",
                                            backgroundColor: Colors.red,
                                            gravity: ToastGravity.CENTER,
                                            toastLength: Toast.LENGTH_LONG);
                                      } else if (name2.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: widget.l.fra == 1
                                                ? "chosissez le produit en bon etat"
                                                : widget.l.eng == 1
                                                    ? "Choose a product wich is good"
                                                    : widget.l.swa == 1
                                                        ? "chagua jina la bidhaa nzuri"
                                                        : "Muhitemwo izina ry'ikimeze neza",
                                            backgroundColor: Colors.red,
                                            gravity: ToastGravity.CENTER,
                                            toastLength: Toast.LENGTH_LONG);
                                      } else if (add.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: widget.l.fra == 1
                                                ? "Ecrivez le montant ajouté"
                                                : widget.l.eng == 1
                                                    ? "Write a add amount"
                                                    : widget.l.swa == 1
                                                        ? "Andika pesa anaongeza"
                                                        : "Mwandike amahera yongeye",
                                            backgroundColor: Colors.red,
                                            gravity: ToastGravity.CENTER,
                                            toastLength: Toast.LENGTH_LONG);
                                      } else {
                                        messagevalidation();
                                      }
                                    }
                                  } else {
                                    if (widget.duree != -1002) {
                                      paspayemessage();
                                    } else {
                                      paspayemessageechec();
                                    }
                                  }
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 5),
                                    child: Container(
                                        color: Colors.lightBlueAccent,
                                        alignment: Alignment.center,
                                        child: widget.l.eng == 1
                                            ? Text(
                                                'Accept',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        'Emeza',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))),
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
                              Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.black26, width: 5),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        widget.l.fra == 1
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "On cherche Tous les produits dans la liste(en panne et en bon etat) puis on ecrit La quatité en panne et Le montant que le client ajoute,si le client n'ajoute pas,le montant ajouté est 0",
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            : widget.l.eng == 1
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Choose all products in a list(problem and safe) and you write a quantity of product with problem and an Add amount,if no add amount write 0",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                : widget.l.swa == 1
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Majina yote ya bidhaa Niyakutafutwa kwenye orodha unaandika tu wingi wa bidhaa zinarudia kisha pesa anaongeza,kama hakuna pesa anaongeza andika 0",
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Amazina Yose nayo guhiga murutonde(iry'ivyapfuye hamwe niry'ivyo ugira uhinduze) wewe wandika gusa igitigiri kigarutse hamwe n'amahera yongeye,atayo yongeye andika 0",
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                          textAlign:
                                                              TextAlign.center,
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
                              InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                              showSearch(
          context: context,
          delegate: DataSearch2(context, widget.l, widget.numero, widget.duree,
              probleme, widget.isboss));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 5),
                                    child: Container(
                                        color: Colors.lightBlueAccent,
                                        alignment: Alignment.center,
                                        child: widget.l.eng == 1
                                            ? Text(
                                                'historia',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : widget.l.swa == 1
                                                ? Text(
                                                    'ona vyote',
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : widget.l.fra == 1
                                                    ? Text(
                                                        'Historique',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        'raba vyose',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DataSearch1 extends SearchDelegate<String> {
  TextEditingController nom = new TextEditingController();
  TextEditingController nom2 = new TextEditingController();
    TextEditingController resultat1 = new TextEditingController();
  BuildContext context;
  Langue l;
  var noms;
  DataSearch1(
      this.nom, this.nom2, this.context, this.l, this.noms, this.resultat1);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.red,
        child: Text(query),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugest = query.isEmpty
        ? this.noms
        : this
            .noms
            .where((element) =>
                element['nom']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element['nom']
                    .toString()
                    .toUpperCase()
                    .contains(query.toUpperCase()))
            .toList();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: sugest.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        resultat1.text = (sugest[index]['q_encien']).toString();
                                        if (nom.text.isEmpty) {
                                          nom.text = sugest[index]['nom'];
                                          } else if (nom2.text.isEmpty) {
                                          nom2.text = sugest[index]['nom'];
                                          } else {
                                            nom.text = sugest[index]['nom'];
                                              nom2.text = "";
                                          }
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 3),
                        child: Column(
                          children: [
                            Card(
                              elevation: 0,
                              margin: EdgeInsets.all(2),
                              shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.grey, width: 5),
                                  borderRadius: BorderRadius.circular(15)),
                              color: Colors.blueGrey,
                              child: ListTile(
                                subtitle: this.l.fra == 1
                                    ? Text("stock:" + sugest[index]['q_encien'],
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white))
                                    : this.l.eng == 1
                                        ? Text(
                                            "stock:" +
                                                sugest[index]['q_encien'],
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white))
                                        : this.l.swa == 1
                                            ? Text(
                                                "Hisa:" +
                                                    sugest[index]['q_encien'],
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white))
                                            : Text(
                                                "Sitoke:" +
                                                    sugest[index]['q_encien'],
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white)),
                                title: RichText(
                                  text: TextSpan(
                                      text: sugest[index]['nom']
                                          .substring(0, query.length),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                      children: [
                                        TextSpan(
                                            text: sugest[index]['nom']
                                                .substring(query.length),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 30)),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class DataSearch2 extends SearchDelegate<String> {
  BuildContext context;
  Langue l;
  List noms;
  String numero;
  int duree;
  int isboss;
  DataSearch2(
      this.context, this.l, this.numero, this.duree, this.noms, this.isboss);
  snackabargood() {
    final snackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: l.fra == 1
                ? Text(
                    "Bravo",
                    style: TextStyle(fontSize: 50, color: Colors.green),
                    textAlign: TextAlign.center,
                  )
                : l.eng == 1
                    ? Text(
                        'Done',
                        style: TextStyle(fontSize: 50, color: Colors.green),
                        textAlign: TextAlign.center,
                      )
                    : l.swa == 1
                        ? Text(
                            'Vizuri',
                            style: TextStyle(fontSize: 40, color: Colors.green),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Vyakunze',
                            style: TextStyle(fontSize: 40, color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              Icons.warning,
              color: Colors.green,
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

  paspayemessage() {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: l.fra == 1
          ? Text("Votre paquet a expiré Vous Voulez payer encore ?",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center)
          : l.eng == 1
              ? Text(
                  "Your Packet has Finished Do you want to pay one again ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center)
              : l.swa == 1
                  ? Text("Mfuko wako Umeisha Unataka kulipa tena ?",
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
          onPressed: () {
            Navigator.pop(context);
          },
          child: l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : l.swa == 1
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
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Service(
                          l: l,
                          numero: numero,
                        )));
          },
          child: l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              color: Colors.green,
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

  snackabarfaux() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: l.fra == 1
                ? Text(
                    'Réessayez',
                    style: TextStyle(fontSize: 50, color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : l.eng == 1
                    ? Text(
                        'Retry',
                        style: TextStyle(fontSize: 50, color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    : l.swa == 1
                        ? Text(
                            'binakatara',
                            style: TextStyle(fontSize: 40, color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'vyase',
                            style: TextStyle(fontSize: 20, color: Colors.red),
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

deleteprobleme(String nom1, String nom2, String date){
    try {
      http.post(
          "https://kakwetuburundifafanini.com/dpr/deleteprobleme.php",
          body: {
            "nom_p": nom1,
            "nom_g": nom2,
            "nro": this.numero,
            "dat": date,
          });
    } catch (e) {
      snackabarfaux();
      return;
    }
  }

  void messagevalidersuppression(String nomp, String nomg, String date,int i) {
    AlertDialog alerte = new AlertDialog(
      backgroundColor: Colors.black,
      content: l.fra == 1
          ? Text("Vous Voulez Vraiment Supprimer ?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center)
          : l.eng == 1
              ? Text("Do you Want to delete ?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : l.swa == 1
                  ? Text("Unataka Kuondoa ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text(
                      "Mushaka guhanagura  ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: l.fra == 1
              ? Text("Non",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Not",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                  : l.swa == 1
                      ? Text("Hapana",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center)
                      : Text("Oya",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center),
        ),
        MaterialButton(
          onPressed: () {
            if (this.duree >= 0) {
              deleteprobleme(nomp, nomg, date);
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Navigator.pop(context);
              paspayemessage();
            }
          },
          child: l.fra == 1
              ? Text("Oui",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center)
              : l.eng == 1
                  ? Text("Yes",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center)
                  : l.swa == 1
                      ? Text("Ndio",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          textAlign: TextAlign.center)
                      : Text("Egome",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
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
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.red,
        child: Text(query),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugest = query.isEmpty
        ? this.noms
        : this
            .noms
            .where((element) =>
                element['nom_p']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element['nom_p']
                    .toString()
                    .toUpperCase()
                    .contains(query.toUpperCase())||element['nom_g']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element['nom_g']
                    .toString()
                    .toUpperCase()
                    .contains(query.toUpperCase())||element['dat']
                    .toString()
                    .contains(query))
            .toList();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: sugest.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            Card(
                              elevation: 0,
                              margin: EdgeInsets.all(2),
                              shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.grey, width: 5),
                                  borderRadius: BorderRadius.circular(15)),
                              color: Colors.blueGrey,
                              child: ListTile(
                                subtitle: Column(
                                  children: [
                                    this.l.fra == 1
                                        ? Text(
                                            "En panne : " +
                                                sugest[index]['nom_p'],
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.redAccent))
                                        : this.l.eng == 1
                                            ? Text(
                                                "problems : " +
                                                    sugest[index]['nom_p'],
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.redAccent))
                                            : this.l.swa == 1
                                                ? Text(
                                                    "Tatizo : " +
                                                        sugest[index]['nom_p'],
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color:
                                                            Colors.redAccent))
                                                : Text(
                                                    "Ivyapfuye : " +
                                                        sugest[index]['nom_p'],
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors
                                                            .redAccent)),
                                    this.l.fra == 1
                                        ? Text(
                                            "quantité : " +
                                                sugest[index]['qte'],
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white))
                                        : this.l.eng == 1
                                            ? Text(
                                                "Quantity : " +
                                                    sugest[index]['qte'],
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white))
                                            : this.l.swa == 1
                                                ? Text(
                                                    "kiasi : " +
                                                        sugest[index]['qte'],
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.white))
                                                : Text(
                                                    "Igitigiri : " +
                                                        sugest[index]['qte'],
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.white)),
                                    this.l.fra == 1
                                        ? Text(
                                            "En bon Etat : " +
                                                sugest[index]['nom_g'],
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white))
                                        : this.l.eng == 1
                                            ? Text(
                                                "Safe : " +
                                                    sugest[index]['nom_g'],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white))
                                            : this.l.swa == 1
                                                ? Text(
                                                    "vizuri : " +
                                                        sugest[index]['nom_g'],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white))
                                                : Text(
                                                    "Ibikomeye : " +
                                                        sugest[index]['nom_g'],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white)),
                                    Visibility(
                                      visible: this.isboss == 1 ? true : false,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 3.0),
                                        child: IconButton(
                                            splashColor: Colors.white,
                                            icon: Icon(
                                              Icons.delete,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              messagevalidersuppression(
                                                sugest[index]['nom_p'],
                                                sugest[index]['nom_g'],
                                                sugest[index]['dat'],index
                                              );
                                            }),
                                      ),
                                    )
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    this.l.fra == 1
                                        ? Text(
                                            "montant ajouté : " +
                                                sugest[index]['ajout'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold))
                                        : this.l.eng == 1
                                            ? Text(
                                                "add amount : " +
                                                    sugest[index]['ajout'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : this.l.swa == 1
                                                ? Text(
                                                    "Ameongezea : " +
                                                        sugest[index]['ajout'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold))
                                                : Text(
                                                    "amahera yongeye : " +
                                                        sugest[index]['ajout'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                    Text(sugest[index]['dat'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                title: RichText(
                                  text: TextSpan(
                                      text:sugest[index]['nom_p'].toString().contains(query)? sugest[index]['nom_p']
                                          .substring(0, query.length):sugest[index]['nom_p'].toString().contains(query.toUpperCase())?sugest[index]['nom_p']
                                          .substring(0, query.length):sugest[index]['dat'].toString().contains(query)?sugest[index]['dat']
                                          .substring(0, query.length):sugest[index]['nom_g'].toString().contains(query)?sugest[index]['nom_g']
                                          .substring(0, query.length):sugest[index]['nom_g'].toString().contains(query.toUpperCase())?sugest[index]['nom_g']
                                          .substring(0, query.length):sugest[index]['nom_p']
                                          .substring(0, query.length),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                      children: [
                                        TextSpan(
                                            text:sugest[index]['nom_p'].toString().contains(query)?sugest[index]['nom_p']
                                                .substring(query.length):sugest[index]['nom_p'].toString().contains(query.toUpperCase())?sugest[index]['nom_p']
                                                .substring(query.length):sugest[index]['dat'].toString().contains(query)?sugest[index]['dat']
                                                .substring(query.length):sugest[index]['nom_g'].toString().contains(query)?sugest[index]['nom_g']
                                                .substring(query.length):sugest[index]['nom_g'].toString().contains(query.toUpperCase())?sugest[index]['nom_g']
                                                .substring(query.length):sugest[index]['nom_p']
                                                .substring(query.length),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 30)),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}

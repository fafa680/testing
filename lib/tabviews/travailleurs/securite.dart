import 'dart:async';
import 'dart:convert';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:kakwetu/page3.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
class Security extends StatefulWidget {
  final Langue l;
  final String numero;
  final int isboss;
  final int controled;
  Security({Key key, this.l, this.numero,this.isboss,this.controled}) : super(key: key);
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
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
                        ? Securite(
                            l: widget.l,
                            numero: widget.numero,isboss: widget.isboss,controled: widget.controled,
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

class Securite extends StatefulWidget {
  final Langue l;
  final String numero;
  final int isboss;
  final int controled;
  Securite(
      {Key key,
      this.l,
      this.numero,this.isboss,this.controled})
      : super(key: key);

  @override
  _SecuriteState createState() => _SecuriteState();
}

class _SecuriteState extends State<Securite>{
  Timer _timer;
   StreamController<List> _streamcontroller1=StreamController<List>();
    ScrollController _scrollcontroller=new ScrollController();
  @override
  void initState() {
    selectjournal();
    if(widget.controled==0){
      updateagtetatjournl();
    }
   _timer = Timer.periodic(Duration(seconds:2), (timer) {
      selectjournal();
    });
    super.initState();
  }
  @override
  void dispose() {
    _scrollcontroller.dispose();
    _streamcontroller1.close();
     if (_timer.isActive) _timer.cancel();
    super.dispose();
  }
updateagtetatjournl(){
    try {
      http.post(
          "https://kakwetuburundifafanini.com/update/updateetatjournl.php",
          body: {
            "etat":"0",
            "nro": widget.numero,
          });
    } catch (e) {
    }
  }
  static _isolate(String body){
return jsonDecode(body);
  }
  selectjournal() async {
    try {
      final response = await http
          .post("https://kakwetuburundifafanini.com/get/selectjournal.php", body: {
        "nro": widget.numero,
      });
      var resultat=await compute(_isolate,response.body);
     setState(() {
                   _streamcontroller1.add(resultat);
        });
    } catch (e) {
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
StreamBuilder<List>(
              stream:_streamcontroller1.stream,
              builder: (context, snap) {
                if (snap.hasError) {
                } else if (snap.hasData) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                              child: Scrollbar(
                                child: ListView.builder(
                                  controller: _scrollcontroller,
                                  physics: BouncingScrollPhysics(),
                                    itemCount:
                                        snap.data.length,
                                   
                                    itemBuilder: (context, i) {
                                      
                                      return Card(
                                          color: Colors.black45,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.lightBlue,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            children: [
                                          widget.isboss==1?widget.controled==1?Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0),
                                                child: widget.l.fra == 1
            ? Text("Boss,Quelqu'un a tenté d'entrer chez ce travailleur",
                style: TextStyle(decoration: TextDecoration.underline,
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                textAlign: TextAlign.center)
            : widget.l.eng == 1
                ? Text(
                    "Boss,Some one tried to Enter at this worker ",
                    style: TextStyle(decoration: TextDecoration.underline,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                    textAlign: TextAlign.center)
                : widget.l.swa == 1
                    ? Text("Boss,Kuna Mtu Alijaribu kuingia kwa mufanyakazi huyu",
                        style: TextStyle(decoration: TextDecoration.underline,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        textAlign: TextAlign.center)
                    : Text(
                        "Boss,Harumuntu Yagerageje Kwinjira kuruyu mukozi",
                        style: TextStyle(decoration: TextDecoration.underline,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                                              ):Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0),
                                                child: widget.l.fra == 1
            ? Text("Boss,Quelqu'un a tenté d'entrer dans votre compte",
                style: TextStyle(decoration: TextDecoration.underline,
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                textAlign: TextAlign.center)
            : widget.l.eng == 1
                ? Text(
                    "Boss,Some one tried to Enter in your acount",
                    style: TextStyle(decoration: TextDecoration.underline,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                    textAlign: TextAlign.center)
                : widget.l.swa == 1
                    ? Text("Boss,Kuna Mtu Alijaribu kuingia kwenye akaunti yako",
                        style: TextStyle(decoration: TextDecoration.underline,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        textAlign: TextAlign.center)
                    : Text(
                        "Boss,Harumuntu Yagerageje Kwinjira",
                        style: TextStyle(decoration: TextDecoration.underline,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                                              ):Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0),
                                                child: widget.l.fra == 1
            ? Text("Quelqu'un a tenté d'entrer",
                style: TextStyle(decoration: TextDecoration.underline,
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                textAlign: TextAlign.center)
            : widget.l.eng == 1
                ? Text(
                    "Some one tried to Enter",
                    style: TextStyle(decoration: TextDecoration.underline,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                    textAlign: TextAlign.center)
                : widget.l.swa == 1
                    ? Text("Kuna Mtu Alijaribu kuingia",
                        style: TextStyle(decoration: TextDecoration.underline,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        textAlign: TextAlign.center)
                    : Text(
                        "Harumuntu Yagerageje Kwinjira",
                        style: TextStyle(decoration: TextDecoration.underline,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                                              ),
                                          Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: widget.l.fra == 1
                                                      ? snap.data[i]['jour'].toString() == '1'
                                                          ? Text("Dimanche le " + snap.data[i]['gmt']+" GMT",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white))
                                                          : snap.data[i]['jour']
                                                                      .toString() ==
                                                                  '2'
                                                              ? Text(
                                                                  "Lundi le " +
                                                                      snap.data[i]
                                                                          ['gmt']+" GMT",
                                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                              : snap.data[i]['jour'].toString() == '3' ? Text("Mardi le " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '4' ? Text("Mercredi le " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '5' ? Text("Jeudi le " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '6' ? Text("Vendredi le " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : Text("Samedi le " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                                      : widget.l.eng == 1 ? snap.data[i]['jour'].toString() == '1' ? Text("Sunday The " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '2' ? Text("Monday The " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '3' ? Text("Tuesday The " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '4' ? Text("Wednesday The " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '5' ? Text("Thursday The " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '6' ? Text("Friday The " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : Text("Saturday " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : widget.l.swa == 1 ? snap.data[i]['jour'].toString() == '1' ? Text("Jumapili Tarehe " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '2' ? Text("Jumatatu Tarehe " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '3' ? Text("Jumanne Tarehe " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '4' ? Text("Jumatano Tarehe " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '5' ? Text("Alhamisi Tarehe " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '6' ? Text("Ijumaa Tarehe " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : Text("Jumamosi Tarehe " + snap.data[i]['gmt']+" GMT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '1' ? Text("Kuw'Imana Igenekerezo rya " + snap.data[i]['burundi'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '2' ? Text("Kuwambere Igenekerezo rya " + snap.data[i]['burundi'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '3' ? Text("Kuwakabiri Igenekerezo rya " + snap.data[i]['burundi'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '4' ? Text("Kuwagatatu Igenekerezo rya " + snap.data[i]['burundi'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '5' ? Text("Kuwakane Igenekerezo rya " + snap.data[i]['burundi'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : snap.data[i]['jour'].toString() == '6' ? Text("Kuwagatanu Igenekerezo rya " + snap.data[i]['burundi'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : Text("Kuwagatandatu Igenekerezo rya " + snap.data[i]['burundi'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                              
                                            widget.isboss==1?widget.controled==1? Padding(
                                               padding: const EdgeInsets.only(top:8.0),
                                               child: widget.l.fra == 1
            ? Text("Soit C'est lui ou C'est vous car vous connaissez le numero tous",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center)
            : widget.l.eng == 1
                ? Text(
                    "May be that is you or your worker because you know his number",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center)
                : widget.l.swa == 1
                    ? Text("Inawezekana kuwa niwewe au yeye kwasababu unajuwa nambari",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center)
                    : Text(
                        "Birashika akaba ari mwebwe canke umukozi wanyu kubera muzi numero mwese",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                                             ):Padding(
                                               padding: const EdgeInsets.only(top:8.0),
                                               child: widget.l.fra == 1
            ? Text("Si ce n'est pas vous peut etre que c'est l'autre qui a soit vue votre numero ou qui a utilisé votre téléphone",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center)
            : widget.l.eng == 1
                ? Text(
                    "If is not you may be that is some one else who used your phone or some one who know your number",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center)
                : widget.l.swa == 1
                    ? Text("Kama siyo weye inawezekana kuwa ni mtu mwengine alitumia simu yako au mtu anaye juwa nambari yako",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center)
                    : Text(
                        "Namba atari mwebwe vyoshika akaba ari uwakoresheje ngendanwa yawe canke uwundi wabwiye numero yawe",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                                             ):Padding(
                                               padding: const EdgeInsets.only(top:8.0),
                                               child: widget.l.fra == 1
            ? Text("Si ce n'est pas vous peut etre que c'est l'autre qui a soit vue votre numero ou qui a utilisé votre téléphone(ou votre Boss,Mais ici n'ayez pas peur car il ne sait pas votre mot de passe si vous l'avez changé)",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center)
            : widget.l.eng == 1
                ? Text(
                    "If is not you may be that is some one else who used your phone or some one who know your number (or your Boss but here don't worry because he don't know your password if you changed it)",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center)
                : widget.l.swa == 1
                    ? Text("Kama siyo weye inawezekana kuwa ni mtu mwengine alitumia simu yako au mtu anaye juwa nambari yako (Au Ni Boss wako arakini hapa usikuwe na wonga kwasababu hajuwi nenosiri lako kama ulisha libadilisha)",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center)
                    : Text(
                        "Namba atari mwebwe vyoshika akaba ari uwakoresheje ngendanwa yawe canke uwundi wabwiye numero yawe (Canke Boss wawe ariko aha ntugire ubwoba kuko ntazi ijambo kabanga ryawe namba wararihinduye)",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                                             ),
                                            ],
                                          ),
                                        );
                                    }),
                              )),
                        ],
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
          
        ],
    );
  }
}

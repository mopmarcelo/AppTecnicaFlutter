import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdi_marcelo/data/schedule_data.dart';
import 'package:pdi_marcelo/model/store_model.dart';
import 'package:pdi_marcelo/model/user_model.dart';
import 'package:pdi_marcelo/pages/login_page.dart';
import 'package:pdi_marcelo/widgets/custom_drawer.dart';
import 'package:scoped_model/scoped_model.dart';

class CardStore extends StatefulWidget {
  @override
  _CardStoreState createState() => _CardStoreState();
}

class _CardStoreState extends State<CardStore> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController();
  ScrollController listScrollController;

  int _dropDownValue;
  List<ScheduleData> schedule = [];

  final dateFormatter = new DateFormat('dd/MM/yyyy');
  final hourFormatter = new DateFormat('hh:mm');


  @override
  void initState() {
    listScrollController = ScrollController();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Container(
              height: 20.0,
              child: Align(
                child: Text("Bem Vindo!"),
                alignment: Alignment.center,
              ),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2)
        )
    ));
  }

  void _scrollToTop() {
    if (listScrollController.hasClients) {
      listScrollController.animateTo(
        0.0,
        duration: Duration(seconds: 2),
        curve: Curves.easeOut,
      );
    }
  }

  void recarregar(){
    setState(() {});
  }

  Future<List<ScheduleData>> carregarAgendamento() async {
    schedule = [];

    Dio dio = new Dio();
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Access-Control-Allow-Origin"] = "*";
    dio.options.headers["Authorization"] =
        "Bearer " + UserModel.of(context).responseData["access_token"];
    dio.options.validateStatus = (status) => true;
    dio.options.followRedirects = false;
    dio.options.connectTimeout = 15000;

    var dataPars = {
      "DT_INICIO": StoreModel.of(context).dtIni != null
          ? DateFormat('dd/MM/yyyy').format(StoreModel.of(context).dtIni)
          :DateFormat('dd/MM/yyyy').format(DateTime.now()),
      "DT_FIM": StoreModel.of(context).dtFim != null
          ? DateFormat('dd/MM/yyyy').format(StoreModel.of(context).dtFim)
          : DateFormat('dd/MM/yyyy').format(DateTime.now()),
      "CD_PESSOA_LOJA": StoreModel.of(context).cdPessoaLoja != null &&
              StoreModel.of(context).cdPessoaLoja > 0
          ? StoreModel.of(context).cdPessoaLoja
          : null,
      "DS_PERIODO": StoreModel.of(context).dsPeriodo != "Selecione..."
          ? StoreModel.of(context).dsPeriodo
          : null,
      "NR_STATUS": StoreModel.of(context).cdStatus != null &&
              StoreModel.of(context).cdStatus > 0
          ? StoreModel.of(context).cdStatus
          : null,
      "CD_LOCAL_INSTALACAO": StoreModel.of(context).cdLocalInstalacao != null &&
              StoreModel.of(context).cdLocalInstalacao > 0
          ? StoreModel.of(context).cdLocalInstalacao
          : null,
      "NR_TIPO_AGENDAMENTO": StoreModel.of(context).cdTipoAgendamento != null &&
              StoreModel.of(context).cdTipoAgendamento > 0
          ? StoreModel.of(context).cdTipoAgendamento
          : null,
      "DS_PLACA": StoreModel.of(context).dsPlaca,
      "DS_CHASSI": StoreModel.of(context).dsChassi,
      "NM_PESSOA_BENEFICIARIO": StoreModel.of(context).nmBeneficiario
    };

    try{
      var resSchedule = await dio
          .post("http://192.168.56.101:80/getAgendamentos", data: dataPars);

      if (resSchedule.statusCode == HttpStatus.ok ||
          resSchedule.statusCode == HttpStatus.created) {
        resSchedule.data.forEach((element) {
          schedule.add(ScheduleData.fromJson(element));
        });
        schedule.sort((a, b) => (a.CD_AGENDAMENTO > b.CD_AGENDAMENTO ? 1 : -1));
      }
    }catch (e){
      _onFail();
    }

    return schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(2.0),
          child: Container(
            height: 30.0,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: AssetImage("images/ituran-logo-white.png"),
                    alignment: Alignment.topLeft)),
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5.0,),
            child: Row(
              children: <Widget>[
                Icon(Icons.person,size: 20.0,color: Colors.white),
                ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                    return Text(
                        "${!model.isLoggedIn() ? "" : model.userData["userName"]}",
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold));
                  },
                ),
              ],
            ),
          ),
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () => !_scaffoldKey.currentState.isEndDrawerOpen
                  ? _scaffoldKey.currentState.openEndDrawer()
                  : null),
          Container(
            child: PopupMenuButton(
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                    child: Text(
                        "Olá, ${!UserModel.of(context).isLoggedIn() ? "" : UserModel.of(context).userData["userName"]}",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold))),
                PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.list,
                          size: 18.0,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        Text(
                          "Agendamentos",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    value: 0),
                PopupMenuItem(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.logout,
                        size: 18.0,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: 25.0,
                      ),
                      Text("Sair",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          )),
                    ],
                  ),
                  value: 1,
                )
              ],
              onSelected: (result) {
                if (result == 1) {
                  UserModel.of(context).signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
            ),
          ),
        ],
      ),
      endDrawer: CustomDrawer(_pageController, recarregar),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        controller: listScrollController,
        child:
            ScopedModelDescendant<StoreModel>(builder: (context, child, model) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /*Flexible(
                child: Text("",
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
              ),*/
              Padding(
                padding: EdgeInsets.all(8.0),
                child: DropdownButton<int>(
                  isExpanded: true,
                  hint: _dropDownValue == null
                      ? Text("Selecione a Loja")
                      : Text(
                          model.getNomeLoja(_dropDownValue),
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                  items: model.getLojas().map((Map<String, dynamic> loja) {
                    return DropdownMenuItem<int>(
                        value: loja["CD_PESSOA_LOJA"],
                        child: Text(loja["NM_PESSOA_LOJA"]));
                  }).toList(),
                  onChanged: (val) {
                    model.cdPessoaLoja = val == 0 ? null : val;
                    setState(() {
                      _dropDownValue = val == 0 ? null : val;
                      //schedules = model.getAgendamentos();
                      carregarAgendamento();
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(1),
                child: FutureBuilder(
                  future: carregarAgendamento(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError)
                          return Container();
                        else{
                          if (snapshot.data.length == 0){
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(top:30.0),
                                child:  Text("Não há itens para serem exibidos.",
                                    style: TextStyle(color: Colors.black, fontSize: 16.0)),
                              )
                            );
                          }
                          else
                            return createListView(context, snapshot);
                        }
                    }
                  },
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        child: Icon(Icons.arrow_upward),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        if (snapshot.data.length > 0)
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                    color: _getColorBorder(snapshot.data[index].NR_STATUS))),
            color: _getColor(snapshot.data[index].NR_STATUS),
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                  border: Border.all(
                                      color: _getColorBorder(
                                          snapshot.data[index].NR_STATUS))),
                              child: Center(
                                child: Text(_getText(snapshot.data[index].NR_TIPO_AGENDAMENTO)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[index].DS_PLACA != null &&
                                            snapshot.data[index].DS_PLACA != ""
                                        ? snapshot.data[index].DS_PLACA
                                        : snapshot.data[index].DS_CHASSI,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17.0),
                                  ),
                                  Text(
                                      snapshot.data[index].DS_PLACA != null &&
                                              snapshot.data[index].DS_PLACA !=
                                                  ""
                                          ? snapshot.data[index].DS_CHASSI
                                          : "",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16.0))
                                ],
                              ),
                            )
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, right: 10.0, bottom: 15.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _getDsStatus(snapshot.data[index].NR_STATUS),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    _getDetailsRows(
                        snapshot.data[index].CD_LOCAL_INSTALACAO == 1
                            ? Icons.location_on
                            : Icons.home,
                        snapshot.data[index].NM_LOCAL_INSTALACAO +
                            ": " +
                            snapshot.data[index].NM_FANTASIA),
                    _getDetailsRows(
                        Icons.calendar_today_rounded,
                        dateFormatter.format(snapshot.data[index].DT_INICIO) +
                            " " +
                            hourFormatter
                                .format(snapshot.data[index].DT_INICIO) +
                            " - " +
                            hourFormatter.format(snapshot.data[index].DT_FIM)),
                    _getDetailsRows(Icons.person,
                        snapshot.data[index].NM_PESSOA_BENEFICIARIO),
                    _getDetailsRows(
                        Icons.directions_car, snapshot.data[index].NM_MODELO),
                    _getDetailsRows(
                        Icons.work_outline,
                        snapshot.data[index].DS_SEGMENTO +
                            " " +
                            snapshot.data[index].DS_TIPO_PRODUTO),
                    if (snapshot.data[index].CD_LOCAL_INSTALACAO != 1)
                      _getDetailsRows(Icons.map, snapshot.data[index].NR_CEP),
                    if (snapshot.data[index].NR_QTD_FOTOS > 0)
                      _getDetailsRows(
                          Icons.photo_camera,
                          snapshot.data[index].NR_QTD_FOTOS.toString() +
                              "/" +
                              snapshot.data[index].NR_QTD_FOTOS_APROVADAS
                                  .toString()),
                  ],
                )),
          );
        else
          return Center(
            child: Text("Não há itens para serem exibidos.",
                style: TextStyle(color: Colors.black, fontSize: 16.0)),
          );
      },
    );
  }

  Color _getColor(int nrStatus) {
    switch (nrStatus) {
      case 1:
        return Color(0xFFfff2cf);
      case 2:
      case 8:
        return Color(0xFFffffff);
      case 3:
        return Color(0xFFcde1f2);
      case 4:
        return Color(0xFFe2efda);
      case 5:
      case 7:
        return Color(0XFFFCE4Df);
      case 6:
        return Color(0xFFd9e1f2);
      default:
        return Colors.white;
    }
  }

  Color _getColorBorder(int nrStatus) {
    switch (nrStatus) {
      case 1:
        return Colors.orangeAccent;
      case 2:
      case 8:
        return Colors.grey[300];
      case 3:
        return Colors.blueAccent;
      case 4:
        return Colors.lightGreen;
      case 5:
      case 7:
        return Colors.redAccent;
      case 6:
        return Colors.indigoAccent;
      default:
        return Colors.grey[300];
    }
  }

  String _getDsStatus(int nrStatus) {
    switch (nrStatus) {
      case 1:
        return 'PENDENTE';
      case 2:
        return 'EM ATENDIMENTO';
      case 3:
        return 'AGUARDANDO ÁREA TÉCNICA';
      case 4:
        return 'FINALIZADO';
      case 5:
        return 'CANCELADO';
      case 6:
        return 'AGUARDANDO DESINSTALAÇÃO';
      case 7:
        return 'FRUSTRADO';
      case 8:
        return 'RECUSA DA ÁREA TÉCNICA';
      default:
        return "";
    }
  }

  AssetImage _getAssetIcon(int nrTipo) {
    switch (nrTipo) {
      case 1:
        return AssetImage("images/Letter_I.png");
      case 2:
        return AssetImage("images/Letter_D.png");
      case 9:
        return AssetImage("images/Letter_M.png");
      case 11:
        return AssetImage("images/Letter_V.png");
      default:
        return AssetImage("images/Letter_none.png");
    }
  }

  String _getText(int nrTipo) {
    switch (nrTipo) {
      case 1:
        return "I";
      case 2:
        return "D";
      case 9:
        return "M";
      case 11:
        return "V";
      default:
        return " ";
    }
  }

  Widget _getDetailsRows(IconData icon, String text) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, top: 3.0),
        child: Row(children: <Widget>[
          Icon(icon),
          Padding(padding: EdgeInsets.only(left: 8.0)),
          Flexible(
            child: Text(text,
              style: TextStyle(fontSize: 15.0, color: Colors.black),
            ),
          )
        ])
    );
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:Container(
        height: 20.0,
        child: Align(
          child: Text("Falha na operação."),
          alignment: Alignment.center,
        ),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}

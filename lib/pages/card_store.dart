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

  int _dropDownValue;

  List<ScheduleData> schedules = [];
  final dateFormatter = new DateFormat('dd/MM/yyyy');
  final hourFormatter = new DateFormat('hh:mm');

  //final StoreModel storeModel = new StoreModel(_userModel);
  //var user = userModel._loadCurrentUser();

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
            padding: EdgeInsets.only(
              top: 5.0,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.person,
                  size: 20.0,
                  color: Colors.white,
                ),
                ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                    return Text(
                        "${!model.isLoggedIn() ? "" : model.userData["userName"]}",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold));
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
                            fontSize: 16.0, fontWeight: FontWeight.bold))
                ),
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
              onSelected: (result){
                if(result == 1){
                  UserModel.of(context).signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
            ),
          ),
        ],
      ),
      endDrawer: CustomDrawer(_pageController),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: ScopedModelDescendant<StoreModel>(

          builder: (context, child, model){
            schedules = model.getAgendamentos();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DropdownButton<int>(
                    isExpanded: true,
                    hint: _dropDownValue == null
                        ? Text("Selecione a Loja")
                        : Text(model.getNomeLoja(_dropDownValue)
                      ,
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                    items: StoreModel.of(context).getLojas().map((Map<String, dynamic> loja) {
                      return DropdownMenuItem<int>(
                          value: loja["CD_PESSOA_LOJA"], child: Text(loja["NM_PESSOA_LOJA"]));
                    }).toList(),
                    onChanged: (val) {
                      model.cdPessoaLoja = val == 0 ? null : val;
                      setState(() {
                        _dropDownValue = val == 0 ? null : val;
                        schedules = model.getAgendamentos();
                      });
                    },
                  ),
                ),

                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    /*return Container(
                  width: 80.0,
                  height: 80.0,
                  child: Text("Ola"),
                );*/
                    return _schedulesCard(context, index);
                  },
                )
              ],
            );
          }
        ),

      )
    );
  }

  Widget _schedulesCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: _getColorBorder(schedules[index].NR_STATUS))
        ),
        color: _getColor(schedules[index].NR_STATUS),
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
                              image: DecorationImage(
                                image: _getAssetIcon(
                                    schedules[index].NR_TIPO_AGENDAMENTO),
                                fit: BoxFit.cover,
                              ),
                            border: Border.all(color: _getColorBorder(schedules[index].NR_STATUS))
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                schedules[index].DS_PLACA != ""
                                ? schedules[index].DS_PLACA
                                : schedules[index].DS_CHASSI,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17.0),
                              ),
                              Text(schedules[index].DS_PLACA != ""
                                  ? schedules[index].DS_CHASSI
                                  : "",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16.0))
                            ],
                          ),
                        )
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 15.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _getDsStatus(schedules[index].NR_STATUS),
                        style: TextStyle(fontSize: 16.0,),
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
                _getDetailsRows(schedules[index].CD_LOCAL_INSTALACAO == 1? Icons.location_on: Icons.home,schedules[index].NM_LOCAL_INSTALACAO + ": "+ schedules[index].NM_FANTASIA),
                _getDetailsRows(Icons.calendar_today_rounded,dateFormatter.format(schedules[index].DT_INICIO) + " " + hourFormatter.format(schedules[index].DT_INICIO)+ " - " + hourFormatter.format(schedules[index].DT_FIM)),
                _getDetailsRows(Icons.person,schedules[index].NM_PESSOA_BENEFICIARIO),
                _getDetailsRows(Icons.directions_car,schedules[index].NM_MODELO),
                _getDetailsRows(Icons.work_outline,schedules[index].DS_SEGMENTO + " " +  schedules[index].DS_TIPO_PRODUTO),
                if(schedules[index].CD_LOCAL_INSTALACAO != 1) _getDetailsRows(Icons.map,schedules[index].NR_CEP),
                if(schedules[index].NR_QTD_FOTOS > 0) _getDetailsRows(Icons.photo_camera,schedules[index].NR_QTD_FOTOS.toString() + "/" + schedules[index].NR_QTD_FOTOS_APROVADAS.toString()),

              ],
            )),
      ),
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

  Widget _getDetailsRows(IconData icon, String text) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, top: 3.0),
        child: Row(children: <Widget>[
          Icon(icon),
          Padding(padding: EdgeInsets.only(left: 8.0)),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 15.0, color: Colors.black),
            ),
          )

        ]));
  }
}

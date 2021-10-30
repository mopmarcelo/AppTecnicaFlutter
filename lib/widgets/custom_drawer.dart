import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdi_marcelo/model/store_model.dart';
import 'package:pdi_marcelo/model/user_model.dart';
import 'package:pdi_marcelo/pages/login_page.dart';
import 'package:scoped_model/scoped_model.dart';

import 'drawer_menu.dart';

class CustomDrawer extends StatefulWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final dtIniC = TextEditingController();
  final dtFimC = TextEditingController();
  final tpAgendamentoC = TextEditingController();
  final statusC = TextEditingController();
  final periodoC = TextEditingController();
  final localC = TextEditingController();
  final placaC = TextEditingController();
  final chassiC = TextEditingController();
  final nmBeneficiarioC = TextEditingController();

  int _ddlTipo;
  int _ddlStatus;
  String _ddlPeriodo;
  int _ddlLocal;

  StoreModel _storeModel;

  @override
  void initState() {
    super.initState();

    setState(() {
      dtIniC.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      dtFimC.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 5.0),
                child: ScopedModelDescendant<StoreModel>(
                  builder: (context, child, model){
                    this._storeModel = model;
                    if (model.dtIni != null){
                      dtIniC.text = DateFormat('dd/MM/yyyy').format(model.dtIni);
                    }
                    if (model.dtFim != null){
                      dtFimC.text = DateFormat('dd/MM/yyyy').format(model.dtFim);
                    }
                    if (model.dsPlaca != null && model.dsPlaca != ""){
                      placaC.text = model.dsPlaca;
                    }
                    if (model.dsChassi != null && model.dsChassi != ""){
                      chassiC.text = model.dsChassi;
                    }
                    if (model.nmBeneficiario != null && model.nmBeneficiario != ""){
                      nmBeneficiarioC.text = model.nmBeneficiario;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(children: [
                            Text(
                              "Agendamento",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.calendar_today, size: 22.0),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          border: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          labelText: "De"),
                                      readOnly: true,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14.0),
                                      controller: dtIniC,
                                      keyboardType: TextInputType.datetime,
                                      onTap: () async {
                                        DateTime pickedDate = await showDatePicker(
                                            context: context,
                                            locale: const Locale('pt', 'PT'),
                                            initialDate: model.dtIni != null
                                                ? model.dtIni
                                                : DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2023));
                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickedDate);
                                          model.dtIni = pickedDate;

                                          print(model.dtIni);

                                          setState(() {
                                            dtIniC.text = formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.calendar_today, size: 22.0),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          border: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          labelText: "Até"),
                                      readOnly: true,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14.0),
                                      controller: dtFimC,
                                      keyboardType: TextInputType.datetime,
                                      onTap: () async {
                                        DateTime pickedDate = await showDatePicker(
                                            context: context,
                                            locale: const Locale('pt', 'PT'),
                                            initialDate: model.dtFim != null
                                                ? DateFormat('dd/MM/yyyy').format(model.dtFim)
                                                : DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2023));
                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickedDate);
                                          model.dtFim = pickedDate;

                                          setState(() {
                                            dtFimC.text = formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                    Container(
                                      child: DropdownButton<int>(
                                        isExpanded: true,
                                        hint: _ddlTipo == null || _ddlTipo == 0
                                            ? Text("Tipo de Agendamento",style:
                                        TextStyle(color: Colors.black54, fontSize: 14.0))
                                            : Text(
                                          model.getHintTipo(_ddlTipo),
                                          style:
                                          TextStyle(color: Colors.black, fontSize: 14.0),
                                        ),
                                        underline: Container(
                                          decoration: ShapeDecoration(
                                            shape: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black54)),
                                          ),
                                        ),
                                        value: model.cdTipoAgendamento,
                                        items: model.getTipoAgendamento().map((Map<String, dynamic> value) {
                                          return DropdownMenuItem<int>(
                                              value: value["value"],
                                              child: Text(value["key"], style: TextStyle(fontSize: 14.0),));
                                        }).toList(),
                                        onChanged: (val) {
                                          model.cdTipoAgendamento = val == 0 ? null : val;
                                          setState(() {
                                            _ddlTipo = val == 0 ? null : val;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: DropdownButton<int>(
                                        isExpanded: true,
                                        hint: _ddlStatus == null || _ddlStatus == 0
                                            ? Text("Status",style:TextStyle(color: Colors.black54, fontSize: 14.0))
                                            : Text(model.getDsStatus(_ddlStatus),style:TextStyle(color: Colors.green, fontSize: 14.0),
                                        ),
                                        underline: Container(
                                          decoration: ShapeDecoration(
                                            shape: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black54)),
                                          ),
                                        ),
                                        value: model.cdStatus,
                                        items: model.getStatusAgendamento().map((Map<String, dynamic> value) {
                                          return DropdownMenuItem<int>(
                                              value: value["value"],
                                              child: Text(value["key"], style: TextStyle(fontSize: 14.0)));
                                        }).toList(),
                                        onChanged: (val) {
                                          model.cdStatus = val == 0 ? null : val;
                                          setState(() {
                                            _ddlStatus = val == 0 ? null : val;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        hint: _ddlPeriodo == null
                                            ? Text("Período",style:
                                        TextStyle(color: Colors.black54, fontSize: 14.0))
                                            : Text(_ddlPeriodo == "Selecione" ? "Período" : _ddlPeriodo,
                                          style:
                                          TextStyle(color: Colors.black, fontSize: 14.0),
                                        ),
                                        underline: Container(
                                          decoration: ShapeDecoration(
                                            shape: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black54)),
                                          ),
                                        ),
                                        value: model.dsPeriodo,
                                        items: model.getPeriodo().map((String value) {
                                          return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value, style: TextStyle(fontSize: 14.0),));
                                        }).toList(),
                                        onChanged: (val) {
                                          model.dsPeriodo = val  == "Selecione..." ? null : val;
                                          setState(() {
                                            _ddlPeriodo = val == "Selecione..." ? null : val;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: DropdownButton<int>(
                                        isExpanded: true,
                                        hint: _ddlLocal == null || _ddlLocal == -1
                                            ? Text("Local de Instalação",style:
                                        TextStyle(color: Colors.black54, fontSize: 14.0))
                                            : Text(model.getDsLocal(_ddlLocal),
                                          style:
                                          TextStyle(color: Colors.black, fontSize: 14.0),
                                        ),
                                        underline: Container(
                                          decoration: ShapeDecoration(
                                            shape: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black54)),
                                          ),
                                        ),
                                        value: model.cdLocalInstalacao,
                                        items: model.getLocal().map((Map<String, dynamic> value) {
                                          return DropdownMenuItem<int>(
                                              value: value["value"],
                                              child: Text(value["key"], style: TextStyle(fontSize: 14.0)));
                                        }).toList(),
                                        onChanged: (val) {
                                          model.cdLocalInstalacao = val == 0 ? null : val;
                                          setState(() {
                                            _ddlLocal = val == 0 ? null : val;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                          ]),
                        ),
                        Padding(padding: EdgeInsets.all(3.0)),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(children: [
                            Text(
                              "Plataforma",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 15.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          border: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          labelText: "Placa", labelStyle: TextStyle(fontSize: 14.0,color: Colors.black54), alignLabelWithHint: true),
                                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                                      controller: placaC,
                                      keyboardType: TextInputType.text,
                                      onChanged: (text){
                                        model.dsPlaca = text;
                                      },
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          border: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          labelText: "Chassi", labelStyle: TextStyle(fontSize: 14.0, color: Colors.black54), alignLabelWithHint: true),
                                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                                      controller: chassiC,
                                      keyboardType: TextInputType.text,
                                      onChanged: (text){
                                        model.dsChassi = text;
                                      },
                                    ),
                                  ],
                                )),
                          ]),
                        ),
                        Padding(padding: EdgeInsets.all(3.0)),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(children: [
                            Text(
                              "Beneficiário",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 15.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          border: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black54)),
                                          labelText: "Nome", labelStyle: TextStyle(fontSize: 14.0,color: Colors.black54), alignLabelWithHint: true),
                                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                                      controller: nmBeneficiarioC,
                                      keyboardType: TextInputType.text,
                                      onChanged: (text){
                                        model.nmBeneficiario = text;
                                      },
                                    ),
                                  ],
                                )),
                          ]),
                        ),


                      ],
                    );
                  },
                )
              ),
            ),
          ),
        bottomNavigationBar:Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              primaryColor: Colors.white,
              textTheme: Theme
                  .of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.white))),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            onTap: (int index){
              if (index == 0){
                this._storeModel.getAgendamentos();
              }
              else if (index == 1){
                setState(() {
                  this._storeModel.dtIni = null;
                  this._storeModel.dtFim = null;
                  this._storeModel.cdTipoAgendamento = null;
                  this._storeModel.cdStatus = null;
                  this._storeModel.dsPeriodo = null;
                  this._storeModel.cdLocalInstalacao = null;
                  this._storeModel.dsPlaca = null;
                  this._storeModel.dsChassi = null;
                  this._storeModel.nmBeneficiario = null;
                  dtIniC.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
                  dtFimC.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
                  _ddlTipo = null;
                  _ddlStatus = null;
                  _ddlLocal = null;
                  _ddlPeriodo = null;
                  placaC.text = "";
                  chassiC.text = "";
                  nmBeneficiarioC.text = "";
                });

              }
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Pesquisar',
                backgroundColor: Colors.blue,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cancel_outlined),
                label: 'Limpar',
                backgroundColor: Colors.blue,
              ),
            ],
            backgroundColor: Colors.blue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
          ),
        )
      ),
    );
  }

}

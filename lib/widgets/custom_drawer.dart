import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdi_marcelo/model/store_model.dart';
import 'package:pdi_marcelo/model/user_model.dart';
import 'package:pdi_marcelo/pages/login_page.dart';
import 'package:scoped_model/scoped_model.dart';

import 'drawer_menu.dart';

class CustomDrawer extends StatefulWidget {
  final PageController pageController;
  VoidCallback onSeach;

  CustomDrawer(this.pageController, this.onSeach);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  VoidCallback onSeach;

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
  String _hintTipo = "Tipo de Agendamento";
  int _ddlStatus;
  String _hintStatus = "Status";
  String _ddlPeriodo;
  String _hintPeriodo = "Período";
  int _ddlLocal;
  String _hintLocal = "Local";
  int count = 0;

  StoreModel _storeModel;

  @override
  void initState() {
    super.initState();

    onSeach = widget.onSeach;

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

                    if (model.dtIni != null && count == 0){
                      dtIniC.text = DateFormat('dd/MM/yyyy').format(model.dtIni);
                    }
                    if (model.dtFim != null  && count == 0){
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
                    if (model.cdTipoAgendamento != null && model.cdTipoAgendamento > 0 && count == 0){
                      _ddlTipo = model.cdTipoAgendamento;
                    }
                    if (model.cdStatus != null && model.cdStatus > 0 && count == 0){
                      _ddlStatus = model.cdStatus;
                    }
                    if (model.cdLocalInstalacao != null && model.cdLocalInstalacao > 0 && count == 0){
                      _ddlLocal = model.cdLocalInstalacao;
                    }
                    if (model.dsPeriodo != null && model.dsPeriodo != "" && count == 0){
                      _ddlPeriodo = model.dsPeriodo;
                    }
                    count = 1;

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
                                                ? model.dtFim
                                                : DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2023));
                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickedDate);

                                          setState(() {
                                            dtFimC.text = formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                    Container(
                                      child: DropdownButton<int>(
                                        isExpanded: true,
                                        hint: Text(
                                          _hintTipo,
                                          style: _ddlTipo == null || _ddlTipo == 0
                                          ? TextStyle(color: Colors.black54, fontSize: 14.0)
                                          : TextStyle(color: Colors.black, fontSize: 14.0),
                                        ),
                                        underline: Container(
                                          decoration: ShapeDecoration(
                                            shape: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black54)),
                                          ),
                                        ),
                                        value: _ddlTipo,
                                        items: model.getTipoAgendamento().map((Map<String, dynamic> value) {
                                          return DropdownMenuItem<int>(
                                              value: value["value"],
                                              child: Text(value["key"], style: TextStyle(fontSize: 14.0),));
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            _ddlTipo = val == 0 ? null : val;
                                            _hintTipo = model.getHintTipo(_ddlTipo);
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: DropdownButton<int>(
                                        isExpanded: true,
                                        hint: Text(
                                          _hintStatus,
                                          style: _ddlStatus == null || _ddlStatus == 0
                                              ? TextStyle(color: Colors.black54, fontSize: 14.0)
                                              : TextStyle(color: Colors.black, fontSize: 14.0),
                                        ),
                                        underline: Container(
                                          decoration: ShapeDecoration(
                                            shape: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black54)),
                                          ),
                                        ),
                                        value: _ddlStatus,
                                        items: model.getStatusAgendamento().map((Map<String, dynamic> value) {
                                          return DropdownMenuItem<int>(
                                              value: value["NR_STATUS_AGENDAMENTO"],
                                              child: Text(value["DS_STATUS_AGENDAMENTO"], style: TextStyle(fontSize: 14.0)));
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            _ddlStatus = val == 0 ? null : val;
                                            _hintStatus = model.getDsStatus(val);
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          _hintPeriodo,
                                          style: _ddlPeriodo == null || _ddlPeriodo == "Selecione..."
                                              ? TextStyle(color: Colors.black54, fontSize: 14.0)
                                              : TextStyle(color: Colors.black, fontSize: 14.0),
                                        ),
                                        underline: Container(
                                          decoration: ShapeDecoration(
                                            shape: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black54)),
                                          ),
                                        ),
                                        value: _ddlPeriodo,
                                        items: model.getPeriodo().map((String value) {
                                          return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value, style: TextStyle(fontSize: 14.0),));
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            _ddlPeriodo = val == "Selecione..." ? null : val;
                                            _hintPeriodo = val == "Selecione..." ? "Período" : val;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: DropdownButton<int>(
                                        isExpanded: true,
                                        hint: Text(
                                          _hintLocal,
                                          style: _ddlLocal == null || _ddlLocal == 0
                                              ? TextStyle(color: Colors.black54, fontSize: 14.0)
                                              : TextStyle(color: Colors.black, fontSize: 14.0),
                                        ),
                                        underline: Container(
                                          decoration: ShapeDecoration(
                                            shape: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black54)),
                                          ),
                                        ),
                                        value: _ddlLocal,
                                        items: model.getLocal().map((Map<String, dynamic> value) {
                                          return DropdownMenuItem<int>(
                                              value: value["value"],
                                              child: Text(value["key"], style: TextStyle(fontSize: 14.0)));
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            _ddlLocal = val == 0 ? null : val;
                                            _hintLocal = model.getDsLocal(val);
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
                                      onChanged: (text){},
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
                                      onChanged: (text){},
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
                                      onChanged: (text){},
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
                this._storeModel.dtIni = DateFormat('dd/MM/yyyy').parse(dtIniC.text);
                this._storeModel.dtFim = DateFormat('dd/MM/yyyy').parse(dtFimC.text);
                this._storeModel.cdTipoAgendamento = _ddlTipo == 0 ? null : _ddlTipo;
                this._storeModel.cdStatus = _ddlStatus == 0 ? null : _ddlStatus;
                this._storeModel.dsPeriodo = _ddlPeriodo  == "Selecione..." ? null : _ddlPeriodo;
                this._storeModel.cdLocalInstalacao = _ddlLocal == 0 ? null : _ddlLocal;
                this._storeModel.cdLocalInstalacao = _ddlLocal == 0 ? null : _ddlLocal;
                this._storeModel.dsPlaca = placaC.text == "" ? null : placaC.text;
                this._storeModel.dsChassi = chassiC.text == "" ? null : chassiC.text;
                this._storeModel.nmBeneficiario = nmBeneficiarioC.text == "" ? null : nmBeneficiarioC.text;

                onSeach();
                Navigator.pop(context);
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

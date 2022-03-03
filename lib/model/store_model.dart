import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdi_marcelo/data/schedule_data.dart';
import 'package:pdi_marcelo/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class StoreModel extends Model {
  UserModel user;
  bool isLoading = false;

  Dio dio = new Dio();

  int cdPessoaLoja = 0;
  DateTime dtIni;
  DateTime dtFim;
  int cdTipoAgendamento;
  int cdStatus;
  String dsPeriodo;
  int cdLocalInstalacao;
  String dsPlaca;
  String dsChassi;
  String nmBeneficiario;

  List<ScheduleData> schedule = [];
  List<Map<String, dynamic>> listaLojas = [];
  List<Map<String, dynamic>> listaStatus = [
    {'NR_STATUS_AGENDAMENTO': 0, 'DS_STATUS_AGENDAMENTO': "Selecione..."}
  ];
  List<Map<String, dynamic>> listaTipoAgendamento = [
    {"key": "Selecione...", "value": 0},
    {"key": "Instalação", "value": 1},
    {"key": "Desinstalação", "value": 2},
    {"key": "Manutenção", "value": 9},
    {"key": "Vistoria", "value": 11},
  ];
  List<String> listaPeriodo = [];
  List<String> listaPeriodosGeral = [];

  List<Map<String, dynamic>> listaLocal = [
    {"key": "Selecione...", "value": 0},
    {"key": "Loja", "value": 1},
    {"key": "Domiciliar", "value": 2}
  ];

  StoreModel(this.user) {
    if (user != null && user.isLoggedIn()) {
      listaLojas = user.listaLojas;
      carregarListas();
      //carregarAgendamento();
    }
  }

  static StoreModel of(BuildContext context) =>
      ScopedModel.of<StoreModel>(context);

  void carregarListas() async {
    Dio dio = new Dio();

    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Access-Control-Allow-Origin"] = "*";
    dio.options.headers["Authorization"] =
        "Bearer " + user.responseData["access_token"];
    dio.options.validateStatus = (status) => true;
    dio.options.followRedirects = false;
    dio.options.connectTimeout = 15000;

    //listarStatus
    var resStatus =
        await dio.get("http://192.168.56.101:80/getStatusAgendamento");
    if (resStatus.statusCode == HttpStatus.ok ||
        resStatus.statusCode == HttpStatus.created) {
      resStatus.data.forEach((element) {
        listaStatus.add({
          'NR_STATUS_AGENDAMENTO': element['NR_STATUS_AGENDAMENTO'],
          'DS_STATUS_AGENDAMENTO': element['DS_STATUS_AGENDAMENTO']
        });
      });
    }

    //listarPeríodos
    var resPeriodos = await dio.post(
        "http://192.168.56.101:80/getPeriodos",
        data: {"CD_PESSOA_LOJA": cdPessoaLoja});

    if (resPeriodos.statusCode == HttpStatus.ok ||
        resPeriodos.statusCode == HttpStatus.created) {
      resPeriodos.data.forEach((element) {
        listaPeriodosGeral.add(element["DS_PERIODO"]);
      });
      listaPeriodosGeral.sort((a, b) => (a.compareTo(b)));

      listaPeriodosGeral.insert(0, "Selecione...");
      listaPeriodo = [...listaPeriodosGeral];
    }
  }

  List<Map<String, dynamic>> getTipoAgendamento() => listaTipoAgendamento;

  List<Map<String, dynamic>> getStatusAgendamento() => listaStatus;

  recarregarPeriodos() async {
    listaPeriodo = [];
    Dio dio = new Dio();

    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Access-Control-Allow-Origin"] = "*";
    dio.options.headers["Authorization"] =
        "Bearer " + user.responseData["access_token"];
    dio.options.validateStatus = (status) => true;
    dio.options.followRedirects = false;
    dio.options.connectTimeout = 15000;

    var resPeriodos = await dio.post(
        "http://192.168.56.101:80/getPeriodos",
        data: {"CD_PESSOA_LOJA": cdPessoaLoja});

    if (resPeriodos.statusCode == HttpStatus.ok ||
        resPeriodos.statusCode == HttpStatus.created) {
      resPeriodos.data.forEach((element) {
        listaPeriodo.add(element["DS_PERIODO"]);
      });
      listaPeriodo.sort((a, b) => (a.compareTo(b)));

      listaPeriodo.insert(0, "Selecione...");
    }
  }

  List<String> getPeriodo() => listaPeriodo;

  List<Map<String, dynamic>> getLocal() => listaLocal;

  List<Map<String, dynamic>> getLojas() => listaLojas;

  String getNomeLoja(int valor) {
    String retorno = "Selecione a loja";
    if (valor == 0) {
      cdPessoaLoja = 0;
      listaPeriodo = [...listaPeriodosGeral];
      return retorno;
    } else {
      recarregarPeriodos();
      cdPessoaLoja = valor;
    }

    listaLojas.forEach((element) {
      if (element["CD_PESSOA_LOJA"] == valor)
        retorno = element["NM_PESSOA_LOJA"];
    });

    return retorno;
  }

  String getHintTipo(val) {
    String retorno = "Tipo de Agendamento";
    if (val == 0){
      return retorno;
    }
    else {
      listaTipoAgendamento.forEach((element) {
        if (element["value"] == val) retorno = element["key"];
      });
      return retorno;
    }
  }

  String getDsStatus(nrStatus) {
    String retorno = "Status";
    if (nrStatus == 0){
      return retorno;
    }
    else {
      listaStatus.forEach((element) {
        if (element["NR_STATUS_AGENDAMENTO"] == nrStatus)
          retorno = element["DS_STATUS_AGENDAMENTO"];
      });
      return retorno;
    }
  }

  String getDsLocal(val) {
    switch (val) {
      case 1:
        return "Loja";
      case 2:
        return "Domiciliar";
      default:
        return "Local de Instalação";
    }
  }
}

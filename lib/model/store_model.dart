import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdi_marcelo/data/schedule_data.dart';
import 'package:pdi_marcelo/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class StoreModel extends Model {
  UserModel user;
  bool isLoading = false;

  int cdPessoaLoja;
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
  List<Map<String, dynamic>> listaTipoAgendamento = [];
  List<Map<String, dynamic>> listaPeriodo = [];
  List<Map<String, dynamic>> listaLocal = [];

  StoreModel(this.user) {
    if (user != null && user.isLoggedIn()) {
       listaLojas = getLojas();
       getAgendamentos();
    }
  }

  static StoreModel of(BuildContext context) =>
      ScopedModel.of<StoreModel>(context);

  List<Map<String, dynamic>> getTipoAgendamento() => <Map<String, dynamic>>[
    {"key": "Selecione...", "value": 0},
    {"key": "Instalação", "value": 1},
    {"key": "Desinstalação", "value": 2},
    {"key": "Manutenção", "value": 9},
    {"key": "Vistoria", "value": 11},
  ];

  List<Map<String, dynamic>> getStatusAgendamento() => <Map<String, dynamic>>[
    {"key": "Selecione...", "value": 0},
    {"key": "Aguardando desinstalação", "value": 6},
    {"key": "Aguardando área técnica", "value": 3},
    {"key": "Cancelado", "value": 5},
    {"key": "Em Atendimento", "value": 2},
    {"key": "Finalizado", "value": 4},
    {"key": "Frustrado", "value": 7},
    {"key": "Pendente", "value": 1},
    {"key": "Recusa área técnica", "value": 8},
  ];

  List<String> getPeriodo() => <String>[
    "Selecione...",
    "07:30:00",
    "08:00:00",
    "08:15:00",
    "08:30:00",
    "09:00:00",
    "09:30:00",
    "10:00:00",
    "10:30:00",
    "11:00:00",
    "11:30:00",
    "12:00:00",
    "12:30:00",
    "13:00:00",
    "13:10:00",
    "13:15:00",
    "13:30:00",
    "14:00:00",
    "14:30:00",
    "15:00:00",
    "15:10:00",
    "15:30:00",
    "16:00:00",
    "16:30:00",
    "17:00:00",
    "17:30:00",
    "17:45:00",
    "18:00:00",
    "18:30:00",
  ];

  List<Map<String, dynamic>> getLocal() => <Map<String, dynamic>>[
    {"key": "Selecione...", "value": 0},
    {"key": "Loja", "value": 1},
    {"key": "Domiciliar", "value": 2},
  ];
  
  List<Map<String, dynamic>> getLojas() => <Map<String, dynamic>> [
        {'CD_PESSOA_LOJA': 0, 'NM_PESSOA_LOJA': 'Selecione a loja'},
        {'CD_PESSOA_LOJA': 782078, 'NM_PESSOA_LOJA': 'ELITTE SOUND'},
        {'CD_PESSOA_LOJA': 782217, 'NM_PESSOA_LOJA': 'CAMPSOM'},
        {'CD_PESSOA_LOJA': 783608, 'NM_PESSOA_LOJA': 'ALFECAR'},
        {'CD_PESSOA_LOJA': 788268, 'NM_PESSOA_LOJA': 'ISHII SOUND '},
        {'CD_PESSOA_LOJA': 878740, 'NM_PESSOA_LOJA': 'TRANSZERO SÃO BERNARDO'},
        {'CD_PESSOA_LOJA': 919450,'NM_PESSOA_LOJA': 'GARAGEM 03 Parque das Nações'},
        {'CD_PESSOA_LOJA': 931948, 'NM_PESSOA_LOJA': 'AUTO SOM'},
        {'CD_PESSOA_LOJA': 938165,'NM_PESSOA_LOJA': 'GARAGEM 05 Empresa Urbana '},
        {'CD_PESSOA_LOJA': 942733, 'NM_PESSOA_LOJA': 'AVP SOM E ACESSÓRIOS'},
        {'CD_PESSOA_LOJA': 960369, 'NM_PESSOA_LOJA': 'EQUIP FLARHST SOM'},
        {'CD_PESSOA_LOJA': 984153, 'NM_PESSOA_LOJA': 'NITRO SOUND'},
        {'CD_PESSOA_LOJA': 984790, 'NM_PESSOA_LOJA': 'MILLANO AUTO SOM'},
        {'CD_PESSOA_LOJA': 985115, 'NM_PESSOA_LOJA': 'MC SOM'},
        {'CD_PESSOA_LOJA': 985920, 'NM_PESSOA_LOJA': 'SYSTEM CAR'},
      ];

  String getNomeLoja(int valor){
        String retorno = "Selecione a loja";
        if (valor == 0){
              cdPessoaLoja = 0;
              return retorno;
        }

        cdPessoaLoja = valor;

        getLojas().forEach((element) {
           if (element["CD_PESSOA_LOJA"] == valor)
                 retorno =  element["NM_PESSOA_LOJA"];
        });

    return retorno;
  }

  String getHintTipo(val) {
    switch (val) {
      case 1:
        return "Instalação";
      case 2:
        return "Desinstalação";
      case 9:
        return "Manutenção";
      case 11:
        return "Vistoria";
      default:
        return "Tipo de Agendamento";
    }
  }

  String getDsStatus(nrStatus) {
    switch (nrStatus) {
      case 1:
        return 'Pendente';
      case 2:
        return 'Em Atendimento';
      case 3:
        return 'Aguardando área técnica';
      case 4:
        return 'Finalizado';
      case 5:
        return 'Cancelado';
      case 6:
        return 'Aguardando desinstalação';
      case 7:
        return 'Frustrado';
      case 8:
        return 'Recusa área técnica';
      default:
        return "Status";
    }
  }

  String getDsLocal(val){
    switch(val){
      case 1:
        return "Loja";
      case 2:
        return "Domiciliar";
      default:
        return "Local de Instalação";
    }
  }

  List<ScheduleData>getAgendamentos(){
    List<ScheduleData> lista = [];
    lista.add(ScheduleData.fromJson({
      "CD_AGENDAMENTO": 4920433,
      "NM_FANTASIA": "GERAÇÃO SOM",
      "DT_INICIO": "2021-10-23T10:00:00",
      "DT_FIM": "2021-10-23T12:00:00",
      "CD_LOCAL_INSTALACAO": 1,
      "NM_LOCAL_INSTALACAO": "Loja",
      "NR_TIPO_AGENDAMENTO": 1,
      "DS_TIPO_AGENDAMENTO": "Instalação",
      "DS_PLACA": "LQX3069",
      "DS_CHASSI": "9BWDB05U0BT089941",
      "NM_MODELO": "VOYAGE I MOTION COMF/Hghli.1.6 T.Flex 8V",
      "NM_PESSOA_BENEFICIARIO": "DOMINIC MORETTI",
      "NR_STATUS": 4,
      "NR_QTD_FOTOS": 0,
      "NR_QTD_FOTOS_APROVADAS": 0,
      "NR_QTD_FOTOS_REPROVADAS": 0,
      "NR_CEP": "13420590",
      "DS_SEGMENTO": "VAREJO",
      "DS_TIPO_PRODUTO": "MONITORAMENTO"
    }));
    lista.add(ScheduleData.fromJson({
      "CD_AGENDAMENTO": 4920521,
      "NM_FANTASIA": "GIROTTO PIQUERI",
      "DT_INICIO": "2021-10-23T09:30:00",
      "DT_FIM": "2021-10-23T11:00:00",
      "CD_LOCAL_INSTALACAO": 2,
      "NM_LOCAL_INSTALACAO": "Loja",
      "NR_TIPO_AGENDAMENTO": 11,
      "DS_TIPO_AGENDAMENTO": "Instalação",
      "DS_PLACA": "",
      "DS_CHASSI": "9BWDB45U8GT046799",
      "NM_MODELO": "VOYAGE COMF/Highli. 1.6 Mi T.Flex 8V 4p",
      "NM_PESSOA_BENEFICIARIO": "ANA FERRARA",
      "NR_STATUS": 6,
      "NR_QTD_FOTOS": 1,
      "NR_QTD_FOTOS_APROVADAS": 0,
      "NR_QTD_FOTOS_REPROVADAS": 0,
      "NR_CEP": "02924000",
      "DS_SEGMENTO": "VAREJO",
      "DS_TIPO_PRODUTO": "MONITORAMENTO"
    }));

    return lista;
  }

}

import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdi_marcelo/model/store_model.dart';
import 'package:pdi_marcelo/pages/login_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:crypton/crypton.dart';

class UserModel extends Model {
  Map<String, dynamic> userData = Map();
  Map<String, dynamic> responseData = Map();
  List<Map<String, dynamic>> listaLojas = [];

  final String publicKey =
      "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDVTUS+4BhoQ/s4ukE/8Hu1n4UK9UbRNnrsSxfkiagb5oSzVnt3igDJSz8JH18pYrkL40pEaGqqxIaDozJke8APiHJRzn8FS9psH2PfdTnsmXGGuQfnrlSjYHBIsmghX2uLSoSy4NgPOgitUsjLPrSsCPsyT14LA0vc+UbVG7J8zQIDAQAB";
  RSAPublicKey _publicKey;

  @override
  String encrypt(String plain) {
    _publicKey ??= RSAPublicKey.fromPEM(publicKey);
    return _publicKey.encrypt(plain);
  }

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  void signIn(
      {String user,
      String pass,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    Dio dio = new Dio();

    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Access-Control-Allow-Origin"] = "*";
    dio.options.validateStatus = (status) => true;
    dio.options.followRedirects = false;
    dio.options.connectTimeout = 15000;

    try {
	//batendo direto no app kerstrell na vm centOs
      var response = await dio.post(
          "http://192.168.56.101:80/login2",
          data: {"username": encrypt(user), "password": encrypt(pass)});

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        responseData = Map();
        responseData = response.data;

        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(responseData["access_token"]);

        await _loadCurrentUser();
        userData = {
          "userId": decodedToken["userId"],
          "userName": decodedToken["userName"],
          "accessToken": responseData["access_token"]
        };

        dio.options.headers["Authorization"] =
            "Bearer " + responseData["access_token"];
        var responseLojas = await dio.get(
            "http://192.168.56.101:80/getLojas");

        if (responseLojas.statusCode == HttpStatus.ok ||
            responseLojas.statusCode == HttpStatus.created) {
          responseLojas.data['LOJAS'].forEach((element) {
            listaLojas.add({
              'CD_PESSOA_LOJA': element['CD_PESSOA_LOJA'],
              'NM_PESSOA_LOJA': element['NM_PESSOA_LOJA']
            });
          });
          listaLojas.sort(
              (a, b) => (a["NM_PESSOA_LOJA"].compareTo(b["NM_PESSOA_LOJA"])));
          listaLojas.insert(
              0, {'CD_PESSOA_LOJA': 0, 'NM_PESSOA_LOJA': "Selecione..."});
        }
        onSuccess();

        isLoading = false;
        notifyListeners();
      } else {
        onFail();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  String getToken() {
    if (responseData.isNotEmpty) {
      return responseData["access_token"];
    }
  }

  bool isLoggedIn() {
    return this.userData.isNotEmpty && this.userData["user"] != "";
  }

  void signOut() async {
    userData = Map();
    responseData = Map();

    notifyListeners();
  }

  Future<Null> _loadCurrentUser() async {
    if (userData.isEmpty && this.responseData.isNotEmpty) {
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(this.responseData["access_token"]);

      userData = {
        "userId": decodedToken["userId"],
        "userName": decodedToken["userName"],
        "accessToken": this.responseData["access_token"]
      };
    }
    if (userData.isNotEmpty) {
      if (userData["userName"] == null && this.responseData.isNotEmpty) {
        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(this.responseData["access_token"]);
        userData = {
          "userId": decodedToken["userId"],
          "userName": decodedToken["userName"],
          "accessToken": this.responseData["access_token"]
        };
      }
    }
    notifyListeners();
  }
}

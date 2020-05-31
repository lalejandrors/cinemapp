import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:movies/src/models/actor_model.dart';

class ActorProvider{//consulta el servicio y alimenta al modelo para que este sea definido

  String _apiKey = '41da850a40f5a82e8643a01d22262a7e';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  Future<List<Actor>> _procesarRespuesta(Uri url) async {//el future se utiliza con el async para que la app espere a que el servicio web sea consultado

    final resp = await http.get(url);//al usar await, se le indica a la app que espere a que se tenga la respuesta del servicio, para poder asignar esa respuesta final a la variable resp
    final decodedData = json.decode(resp.body);//el json decode devuelve un listado de elementos "map" llave valor, a partir del json consultado en el servicio
    final actores = new Actores.desdeListaJson(decodedData['cast']);//se manda el listado al model, para que este lo recorra y defina la clase pelicula

    return actores.items;//esto ya contiene el listado de elementos de la clase pelicula
  }

  Future<List<Actor>> getActores(String peliId) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key' : _apiKey,
      'language' : _language
    });

    return await _procesarRespuesta(url);//el await me dice que retornará hasta que se complete toda la consulta de la información en procesar respuesta, por eso es una función async
  }

}
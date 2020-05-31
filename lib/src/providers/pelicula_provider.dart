import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:movies/src/models/pelicula_model.dart';

class PeliculaProvider{//consulta el servicio y alimenta al modelo para que este sea definido

  String _apiKey = '41da850a40f5a82e8643a01d22262a7e';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  //la definicion del stream////(parcialmente un bloc)
  int _popularesPage = 0;//indicador de pagina actual del listado de populares que se consulta
  
  bool _cargando = false;//hace que mientras se espera con el await de la peticion se devuelva un array vacio para que no haga mayor cantidad de consultas a las necesarias

  List<Pelicula> _populares = new List();//donde se van a ir almacenando todas las peliculas populares consultadas

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();//el controlador del stream que me va a permitir trabajarlo. La propiedad broadcast hace que el stream pueda ser accedido desde cualquier lugar de la app y no solo desde un lugar

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;//para indicar de manera mas sencilla la funcion de agregar por medio de sink data al stream... cuando se hace referencia a una funcion sin agregar los (), significa que estamos haciendo referencia a esa funcion, mas no ejecutandola
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;//para obtener el stream de manera mas sencilla

  void disposeStreams(){//la funcion que limpia los stream de la aplicacion, es obligatorio para el StreamController
    _popularesStreamController?.close();//el signo de interrogacion funciona como un if anidado... si hay informacion en el stream que se cierre
  }
  ///////////////////////////

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {//el future se utiliza con el async para que la app espere a que el servicio web sea consultado

    final resp = await http.get(url);//al usar await, se le indica a la app que espere a que se tenga la respuesta del servicio, para poder asignar esa respuesta final a la variable resp
    final decodedData = json.decode(resp.body);//el json decode devuelve un listado de elementos "map" llave valor, a partir del json consultado en el servicio
    final peliculas = new Peliculas.desdeListaJson(decodedData['results']);//se manda el listado al model, para que este lo recorra y defina la clase pelicula

    return peliculas.items;//esto ya contiene el listado de elementos de la clase pelicula
  }

  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apiKey,
      'language' : _language
    });

    return await _procesarRespuesta(url);//el await me dice que retornará hasta que se complete toda la consulta de la información en procesar respuesta, por eso es una función async
  }

  Future<List<Pelicula>> getPopulares() async {

    if(_cargando) return [];
    _cargando = true;

    _popularesPage++;
    
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    //cada vez que se llame a getPopulares, se manda la fraccion actual de peliculas al sink para que asi se alimente el stream
    _populares.addAll(resp);
    popularesSink(_populares);
    //////////////////////
    _cargando = false;
    
    return resp;
  }

  Future<List<Pelicula>> searchPeliculas(String query) async {//funcion para construir la logica del buscador de peliculas, pasando como parametro lo que se escribe en el buscador

    final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apiKey,
      'language' : _language,
      'query' : query
    });

    return await _procesarRespuesta(url);//el await me dice que retornará hasta que se complete toda la consulta de la información en procesar respuesta, por eso es una función async
  } 
}
import 'package:flutter/material.dart';

import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/providers/pelicula_provider.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';
import 'package:movies/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {
  
  final peliculaProvider = new PeliculaProvider();

  @override
  Widget build(BuildContext context) {

    peliculaProvider.getPopulares();//llenar con la data inicial al stream en esta instancia, luego esta misma instancia al ser enviada como parametro del movieHorizontal, se ejecutara cada que el scroll llegue hasta el final

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en Cine'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(//show search es una funcion propia de flutter, que recibe como parametros el context y un delegate, que es lo que define la estrucutra y funcionamiento del buscador
                context: context, 
                delegate: peliculasSearch(),
                // query: 'Something'
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context)
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas(){
    
    return FutureBuilder(//ya que la informacion del widget se retorna en un future, armamos el widget desde un future builder
      future: peliculaProvider.getEnCines(),//hacemos referencia al future que se devuelve en el provider de peliculas
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        
        if(snapshot.hasData){
          return CardSwiper(//retornamos el widget personalizado que necesita como parametro el listado de items de tipo pelicula
            peliculas: snapshot.data,
          );
        }else{//mientras no se tenga respuesta del service, que se muestre el loading
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            ),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context){

    return Container(
      width: double.infinity,//ocupa todo el ancho siempre
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,//ubica los elementos de la columna a la izquierda de la pantalla
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead)
          ),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculaProvider.popularesStream,//el getter del stream
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculaProvider.getPopulares,//cada vez que en el widget se escucha el evento de final de scroll, se ejecuta la funcion de getPopulares del provider, que vuelve a alimentar el stream con datos nuevos del servicio. Como se alimenta de nuevo el stream, su builder redibuja el widget con los nuevos datos que se obtuvieron
                );
              }else{
                return Center(
                  child: CircularProgressIndicator()
                );
              }
            },
          )
        ],
      ),
    );
  }

}
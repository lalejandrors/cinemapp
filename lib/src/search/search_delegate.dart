import 'package:flutter/material.dart';

import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/providers/pelicula_provider.dart';

class peliculasSearch extends SearchDelegate{

  final peliculaProvider = new PeliculaProvider();
  
  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';//query es la variable interna del search delegate que permite referirnos al texto que se escribe en el buscador
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);//close es una funcion interna del search delegate que me permite definir que se devuelve al salir del buscador
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que se van a mostrar
    return Container(

    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // son las sugerencias que aparecen mediante se escribe
    if(query.isEmpty){
      return Container();
    }
    
    return FutureBuilder(
      future: peliculaProvider.searchPeliculas(query),//pasamos como parametro lo que se escribe en el buscador, para que por medio de ese texto se busque en el api
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData){
          final peliculas = snapshot.data;

          return ListView(//el listado de peliculas segun lo escrito en el buscador
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);//cierra el buscador
                  pelicula.uniqueId = '';//para que no se genere conflicto con el unique id, se deja en vacio, por la implementacion del Hero
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);//nos dirigimos al detalle de la pelicula, pasando como argumento el objeto de tipo pelicula
                },
              );
            }).toList(),//los hijos del list view, es un listado generado a partir del mapeo de el listado de objetos de tipo pelicula
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}
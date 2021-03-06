import 'package:flutter/material.dart';

import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/models/actor_model.dart';
import 'package:movies/src/providers/actor_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;//obtenemos el parametro enviado desde el navigaor

    return Scaffold(
      body: CustomScrollView(//contenedor de slivers
        slivers: <Widget>[
          _crearAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([//widget para crear los demas widgets que iran dentro del listado de slivers
              SizedBox(height: 10.0),
              _posterTitulo(context, pelicula),
              _descripcion(pelicula),
              _crearCasting(pelicula)
            ]),
          )
        ],
      ),
    );
  }

  Widget _crearAppBar(Pelicula pelicula){

    return SliverAppBar(//existe un sliver especial para el appBar
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula){
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.date_range),
                    Text(pelicula.releaseDate, style: Theme.of(context).textTheme.subhead)
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 15.0),
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula){

    final actorProvider = ActorProvider();

    return FutureBuilder(
      future: actorProvider.getActores(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        
        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores){

    return SizedBox(
      height: 200.0,
      child: PageView.builder(//el pageView builder me permite crear cada item de la lista por cada iteracion
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1,
        ),
        itemCount: actores.length,
        itemBuilder: (context, i){
          return _actorTarjeta(actores[i]);
        },
      ),
    );
  }

  Widget _actorTarjeta(Actor actor){//cada item del pageView

    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis
          )
        ],
      ),
    );
  }
}
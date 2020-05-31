import 'package:flutter/material.dart';

import 'package:movies/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  //creamos el controlador qu me permita manejar el evento del scroll hasta el final
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3//la cantidad de tarjetas por pantalla
  );
  
  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener((){//agregando el listener al controlador del PageView para determinar cuando llega al final del scroll
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){//si estoy llegando al final del scroll
        siguientePagina();//se ejecuta la funcion que ejecuta a getPopulares, es decir... alimenta de nuevo al stream, que a su vez a traves de su builder, vuelve a dibujar el widget de tarjetas ahora con las nuevas peliculas
      }
    });
    
    return Container(
      height: _screenSize.height * 0.28,//el contenedor de las imagenes del footer tendra un alto de 25% de la pantalla
      child: PageView.builder(//pageView es una clase de flutter (no de terceros como el swiper)... que permite crear un scroll de elementos de manera vertical u horizontal
        pageSnapping: false,//hace que se vea mas fluida la transicion
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, i){
          return _tarjeta(context, peliculas[i]);//me pide que envie un return por cada tarjeta del listado
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula){

    pelicula.uniqueId = '${ pelicula.id }-tarjetita';
    
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),//separacion entre peliculas
      child: Column(
        children: <Widget>[
          Hero(//permite animar su contenido haciendo un traslado del mismo hasta su elemento hermano en algun otra posicion de la app, sea en la misma pagina o en diferentes paginas. El tag debe ser igual entre los dos hermanos, y Hero debe contener las propiedades tag y elemento hijo
            tag: pelicula.uniqueId,
            child: ClipRRect(//elemento que envuelve cada poster de pelicula
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),//separacion entre el poster y el titulo
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,//toma el contexto para siempre a partir de este, manejar el mismo estilo en toda la app
          )
        ],
      ),
    );

    return GestureDetector(//widget que permite manejar los eventos en la app de sus widgets hijos
      child: tarjeta,
      onTap: (){
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);//navegamos llevando como parametro todo el objeto tipo pelicula
      },
    );
  }

}
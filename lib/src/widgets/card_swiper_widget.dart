import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});//hace que sea requerido pasar una lista al crear la instancia de la clase
  
  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;//media query contiene informacion de las dimensiones de la pantalla

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,//stack es el diseno del swiper
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index){//para definir cada item del swiper

          peliculas[index].uniqueId = '${ peliculas[index].id }-tarjeta';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(//hace que el widget hijo se pueda mostrar como un rectangulo redondeado
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(//requiere su hijo y el evento al hacer el on tap
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),//ahora a cada objeto pelicula del recorrido, se le llama su metodo getPosterImg, que ya devuelve la url de la imagen
                  placeholder: AssetImage('assets/img/no-image.jpg'),//la imagen que se muestra mientras carga
                  fit: BoxFit.cover,//para que la imagen abarque todo su contenedor
                ),
                onTap: (){
                  Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
                },
              ),
            ),
          );
        },
        itemCount: peliculas.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
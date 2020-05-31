class Peliculas {//esta clase mapea cada pelicula traida del servicio y las almacena en una lista de elementos de la clase pelicula

  List<Pelicula> items = new List();

  Peliculas.desdeListaJson(List<dynamic> jsonList){//este constructor recibe el mapa que se genero al decodificar el json en el provider de peliculas

    if(jsonList == null) return;

    for(var item in jsonList){//aca se recorre ese mapa y se define la clase pelicula con cada uno de los item de ese mapa de peliculas
      final pelicula = new Pelicula.desdeMapaJson(item);
      items.add(pelicula);//en la lista se anaden elementos de la clase pelicula, ya con sus propiedades asignadas
    }
  }
}

class Pelicula {

  String uniqueId;//esta propiedad permite animar en la transicion de los poster a sus descripciones por medio del Hero

  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;

  Pelicula({//constructor

    this.uniqueId,

    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  Pelicula.desdeMapaJson(Map<String, dynamic> json){//este constructor recibe cada item del mapa de peliculas decodificado del llamado al servicio en el provider, y asigna esos valores a las propiedades de la clase

    popularity = json['popularity'] / 1;
    voteCount = json['vote_count'];
    video = json['video'];
    posterPath = json['poster_path'];
    id = json['id'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    title = json['title'];
    voteAverage = json['vote_average'] / 1;
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

  getPosterImg(){//este metodo permite enviar el parametro de url de la imagen completo

    if(posterPath == null){
      return 'https://i-love-png.com/images/no-image-png-7.png';
    }else{
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }

  getBackgroundImg(){

    if(backdropPath == null){
      return 'https://i-love-png.com/images/no-image-png-7.png';
    }else{
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }
  }
  
}

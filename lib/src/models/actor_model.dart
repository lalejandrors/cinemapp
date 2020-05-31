class Actores{

  List<Actor> items = new List();

  Actores.desdeListaJson(List<dynamic> jsonList){

    if(jsonList == null) return;

    jsonList.forEach((item){
      final actor = new Actor.desdeMapaJson(item);
      items.add(actor);
    });
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.desdeMapaJson(Map<String, dynamic> json){

    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath= json['profile_path'];
  }

  getFoto(){//este metodo permite enviar el parametro de url de la imagen completo

    if(profilePath == null){
      return 'https://i-love-png.com/images/no-image-png-7.png';
    }else{
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}



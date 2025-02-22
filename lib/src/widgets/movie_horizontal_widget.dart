import 'package:flutter/material.dart';
import 'package:peliculas/src/config/config.dart';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/widgets/tarjeta_widget.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;
  final String seccion;

  MovieHorizontal({ @required this.peliculas,  @required this.siguientePagina, @required this.seccion });

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: ConfigApp().viewportFractionCard,
    keepPage: true
  );

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() { 
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      } 
    });

    return Container(
      height: _screenSize.height * ConfigApp().screenSizeHeight,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return _tarjeta(context, peliculas[i], seccion);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula, String seccion) {

    pelicula.uniqueId = pelicula.id.toString() + '-' + seccion;

    final tarjeta = Tarjeta(tipo: 'pelicula', pelicula: pelicula);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: tarjeta,
    );
  }

 }
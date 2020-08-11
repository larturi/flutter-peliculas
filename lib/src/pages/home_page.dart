import 'package:flutter/material.dart';

import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/movie_horizontal_widget.dart';

import 'package:peliculas/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();
    peliculasProvider.getTopRated();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en Cartelera'),
        centerTitle: false,
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () {
              showSearch(
                context: context, 
                delegate: DataSearch(),
              );
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _swiperTarjetas(),
            _populares(context),
            _topRated(context)
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        if(snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );

  }

  Widget _populares(BuildContext context) {
    return _genericHorizontalWidget(
      context, 
      'Populares',
       peliculasProvider.popularesStream, 
       peliculasProvider.getPopulares
    );
  }

  Widget _topRated(BuildContext context) {
    return _genericHorizontalWidget(
      context, 
      'Mejor Puntuación', 
      peliculasProvider.topRatedStream, 
      peliculasProvider.getTopRated
    );
  }

  Widget _genericHorizontalWidget(BuildContext context, String titulo, Stream stream, Function siguiente) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[

          Container(
            padding: EdgeInsets.only(left: 20.0, top: 20.0),
            child: Text(titulo, style: Theme.of(context).textTheme.subtitle1)
          ),

          SizedBox(height: 10.0),
          
          // Crea el StreamBuilder con el dataset de peliculas
          StreamBuilder(
            stream: stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              if(snapshot.hasData) {
                // Por cada pelicula arma la tarjeta con link a la pagina de detalle
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: siguiente
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );

  }


}
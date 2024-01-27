import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WidgetHomeSlider extends StatelessWidget {
  const WidgetHomeSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: [
          'Ingresa  a la App',
          'Busca en la Lista',
          'Abre el mapa',
          'y Listo'
        ].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(color: Colors.grey),
                  child: Center(
                    child: Text(
                      '$i',
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                  ));
            },
          );
        }).toList(),
        options: CarouselOptions(
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.decelerate,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8));
  }
}

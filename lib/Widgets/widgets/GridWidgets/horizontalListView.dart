import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/AppPages/ProductDetail/ProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

Widget myHorizontalImages(BuildContext context) {
  final List<Widget> imageSliders = ConstantsVar.netImages
      .map((item) => InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProductDe();
              }));
            },
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: item,
                        width: 1000.0,
                        fit: BoxFit.cover,
                        placeholder: (context, reason) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, item, error) =>
                            Text('Image Cannot be loaded'),
                      )
                    ],
                  )),
            ),
          ))
      .toList();

  return CarouselSlider(
    options: CarouselOptions(
      initialPage: 0,
      reverse: false,
      autoPlay: false,
      aspectRatio: 2.0,
      enlargeCenterPage: true,
    ),
    items: imageSliders,
  );
}

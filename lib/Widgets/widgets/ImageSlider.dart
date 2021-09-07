import 'package:flutter/material.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

final List<Widget> imageSliders = ConstantsVar.netImages
    .map((item) => Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    item,
                    fit: BoxFit.cover,
                    width: 1000.0,
                    height: 800,
                  ),
                ],
              )),
        ))
    .toList();

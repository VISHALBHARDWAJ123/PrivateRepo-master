import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

Widget SliderImages(
    List<String> images, List<String> largeImage, BuildContext context) {
  return Center(
    child: Container(
      width: 80.w,
      padding: EdgeInsets.all(0),
      height: 40.h,
      child: Center(
        child: CarouselSlider.builder(
          enableAutoSlider: images.length > 1 ? true : false,
          unlimitedMode: true,
          slideBuilder: (index) {
            return Container(
              padding: EdgeInsets.all(4.w),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: images[index],
                placeholder: (context, reason) => Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
          slideTransform: DefaultTransform(),
          slideIndicator: CircularSlideIndicator(
              alignment: Alignment.bottomCenter,
              currentIndicatorColor: Colors.black),
          itemCount: images.length,
        ),
      ),
    ),
  );
}

class ImageDialog extends StatelessWidget {
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: AspectRatio(
          aspectRatio: 4 / 4,
          child: Container(
            // width: double.infinity,
            // height: 200,
            decoration: BoxDecoration(
                // color: Colors.transparent,
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.fill)),
          ),
        ),
      ),
    );
  }

  ImageDialog({required this.imageUrl});
}

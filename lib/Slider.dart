import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

Widget SliderImages(List<String> images, List<String> largeImage,
    BuildContext context, String discountPercentage) {
  return Container(
    height: 52.h,
    width: 85.w,
    child: Stack(
      children: [
        Center(
          child: Container(
            // padding: EdgeInsets.all(0),
            child: Center(
              child: CarouselSlider.builder(
                enableAutoSlider: images.length > 1 ? true : false,
                unlimitedMode: true,
                viewportFraction: 1,
                slideBuilder: (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.w),
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
                    padding: EdgeInsets.only(top: 4.w),
                    alignment: Alignment.bottomCenter,
                    currentIndicatorColor: Colors.black),
                itemCount: images.length,
              ),
            ),
          ),
        ),
        Visibility(
          visible: discountPercentage.trim().length != 0 ? true : false,
          child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 15.w,
                height: 15.w,
                child: Stack(
                  children: [
                    Image.asset(
                      'MyAssets/plaincircle.png',
                      width: 15.w,
                      height: 15.w,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        discountPercentage,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 4.8.w,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )),
        )
      ],
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

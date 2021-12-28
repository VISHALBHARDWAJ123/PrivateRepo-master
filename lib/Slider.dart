import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:play_kit/play_kit.dart';
import 'package:share/share.dart';
import 'package:screenshot/screenshot.dart';

import 'Constants/ConstantVariables.dart';

Widget SliderImages(
  List<String> images,
  List<String> largeImage,
  BuildContext context,
  String discountPercentage,
  String productId, {
  required ScreenshotController myKey,
  required String overview,

}) {
  double _scale = 1.0;
  double _previousScale = 0;
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
                    child: Hero(
                      tag: 'ProductImage$productId',
                      transitionOnUserGestures: true,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => ImageDialog(
                              imageUrl: images[index],
                            ),
                          );
                        },
                        child: Screenshot(
                          controller: myKey,
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: images[index],
                            placeholder: (context, reason) => Center(
                              child: SpinKitRipple(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
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
                    ),
                  ],
                ),
              )),
        ),
        Positioned(
          top: 1,
          right: .1,
          child: GestureDetector(
            onTap: () async {
              await myKey
                  .capture(delay: const Duration(milliseconds: 10))
                  .then((image) async {
                if (image != null) {
                  final directory = await getApplicationDocumentsDirectory();
                  final imagePath =
                      await File('${directory.path}/image.png').create();
                  await imagePath.writeAsBytes(image);

                  /// Share Plugin
                  await Share.shareFiles([imagePath.path],
                      text: 'Hi There this is for testing purpose\n${ConstantsVar.stripHtmlIfNeeded(overview)}');
                }
              });
            },
            child: Icon(
              Icons.share,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}

class ImageDialog extends StatelessWidget {
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: PlayContainer(
        blur: 20,
        width: 105.w,
        height: 100.h,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }

  ImageDialog({required this.imageUrl});
}

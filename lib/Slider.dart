import 'dart:core';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:play_kit/play_kit.dart';
import 'package:share/share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'Constants/ConstantVariables.dart';

class SliderClass extends StatefulWidget {
  SliderClass({
    Key? key,
    required this.myKey,
    required this.images,
    required this.largeImage,
    required this.context,
    required this.productId,
    required this.discountPercentage,
    required this.overview,
    required this.productUrl,
    required this.apiToken,
    required this.customerId,
    required this.productName,
    required this.senderName,
    required this.recevierName,
    required this.senderEmail,
    required this.receiverEmail,
    required this.message,
    required this.attributeId,
    // required this.myKey,
    required this.isWishlisted,
    required this.isGiftCard,
    required VoidCallback setState,
  }) : super(key: key);
  List<String> images;
  List<String> largeImage;
  BuildContext context;
  String discountPercentage;
  String productId;
  bool isWishlisted, isGiftCard;
  String productName,
      customerId,
      apiToken,
      productUrl,
      overview,
      senderName,
      recevierName,
      senderEmail,
      receiverEmail,
      message,
      attributeId;
  ScreenshotController myKey;

  @override
  _SliderClassState createState() => _SliderClassState();
}

class _SliderClassState extends State<SliderClass> {
  Color? _color = ConstantsVar.appColor;
  bool _isLiked = false;

  @override
  initState() {
    setState(() => _isLiked = widget.isWishlisted);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliderImages(widget.images, widget.largeImage, widget.context,
        widget.discountPercentage, widget.productId,
        productUrl: widget.productUrl,
        customerId: widget.customerId,
        myKey: widget.myKey,
        apiToken: widget.apiToken,
        overview: widget.overview,
        productName: widget.productName,
        isWishlisted: widget.isWishlisted);
  }

  Widget SliderImages(
    List<String> images,
    List<String> largeImage,
    BuildContext context,
    String discountPercentage,
    String productId, {
    required ScreenshotController myKey,
    required String overview,
    required String productUrl,
    required String apiToken,
    required String customerId,
    required String productName,
    required bool isWishlisted,
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
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: Positioned(
              top: 1,
              right: .1,
              child: Row(
                children: [
                  Card(
                    elevation: 10,
                    shape: CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6,left: 6,bottom: 4,right: 4),
                      child: Center(
                        child: LikeButton(

                          bubblesSize: 15,
                          circleSize: 20,
                          onTap: (isLiked) async {
                            _isLiked == false
                                ? checkGiftCard()
                                : await ApiCalls.removeFromWishlist(
                                    apiToken: apiToken,
                                    customerId: customerId,
                                    productId: productId,
                                    productName: productName,
                                    imageUrl: images[0],
                                    context: context,
                                  ).then((value) =>
                                    setState(() => _isLiked = value));

                            return _isLiked;
                          },
                          // size: IconTheme.of(context).size! + 4,
                          circleColor: CircleColor(
                            start: ConstantsVar.appColor,
                            end: ConstantsVar.appColor,
                          ),
                          isLiked: _isLiked,
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: ConstantsVar.appColor,
                            dotSecondaryColor: Colors.green,
                          ),
                          // isLiked: isWishlisted,
                          likeBuilder: (bool isLiked) {
                            return Center(
                              child: Icon(
                                FontAwesomeIcons.solidHeart,
                                color: isLiked ? _color : Colors.grey,
                                size: IconTheme.of(context).size!,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await myKey.capture().then((image) async {
                        if (image != null) {
                          final directory =
                              await getApplicationDocumentsDirectory();
                          final imagePath =
                              await File('${directory.path}/image.png')
                                  .create();
                          await imagePath.writeAsBytes(image).whenComplete(
                              () async => await Share.shareFiles(
                                  [imagePath.path],
                                  text: 'View product: $productUrl'));
                          print(image);

                          /// Share Plugin

                        }
                      });
                    },
                    child: Card(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.only(top:7.0,right: 9,left: 7,bottom: 7),
                        child: Center(
                          child: Icon(
                            Icons.share,
                            color: ConstantsVar.appColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkGiftCard() async {
    if (widget.isGiftCard == true) {
      if (widget.recevierName.isEmpty ||
          widget.recevierName == '' ||
          widget.receiverEmail.isEmpty ||
          widget.receiverEmail == '' ||
          widget.senderEmail.isEmpty ||
          widget.senderEmail == '' ||
          widget.senderName.isEmpty ||
          widget.senderName == '') {
        Fluttertoast.showToast(
            msg:
                'Please check following fields: Recipient Name,\nRecipient Email,\nSender Name,\nSender Email,\nTHE Special On Gift Card UAE.');
      } else {
        await ApiCalls.addToWishlist(
          apiToken: widget.apiToken,
          customerId: widget.customerId,
          productId: widget.productId,
          imageUrl: widget.images[0],
          productName: widget.productName,
          context: context,
          senderName: widget.senderName,
          receiverEmail: widget.receiverEmail,
          msg: widget.message,
          receiverName: widget.recevierName,
          senderEmail: widget.senderEmail,
          attributeId: widget.attributeId,
        ).then((value) => setState(() => _isLiked = value));
      }
    } else {
      await ApiCalls.addToWishlist(
        apiToken: widget.apiToken,
        customerId: widget.customerId,
        productId: widget.productId,
        imageUrl: widget.images[0],
        productName: widget.productName,
        context: context,
        senderName: '',
        receiverEmail: '',
        msg: '',
        receiverName: '',
        senderEmail: '',
        attributeId: '',
      ).then((value) => setState(() => _isLiked = value));
    }
  }
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

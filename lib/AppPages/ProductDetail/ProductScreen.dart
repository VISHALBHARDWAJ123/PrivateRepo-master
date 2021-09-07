import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled2/AppPages/FeedbackScreen/FeedbackScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/ProductBanner/ProductBanner.dart';
import 'package:untitled2/Widgets/widgets/ImageSlider.dart';
import 'package:untitled2/utils/HeartIcon.dart';

class ProductDe extends StatefulWidget {
  const ProductDe({Key? key}) : super(key: key);

  @override
  _ProductDeState createState() => _ProductDeState();
}

class _ProductDeState extends State<ProductDe> {
  int changedValue = 1;

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> similarImages = ConstantsVar.similarimages
        .map((item) => AspectRatio(
              aspectRatio: 1 / 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: InkWell(
                      onTap: () {},
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: item,
                        placeholder: (context, reason) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                    )),
              ),
            ))
        .toList();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 196, 190, 196),
        extendBody: false,
        body: Column(
          children: [
            ProductBanner(),
            Expanded(
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  productImages(context),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'AED 2,695 incl VAT',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantsVar.appColor,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(HeartIcon.heart))
                              ],
                            ),
                            Text(
                              'NIGHT Armcchair Natural',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                'L 90xW87xH69 cm',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            stockDetails(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Similar Products',
                                  style: TextStyle(
                                      fontSize: ConstantsVar.textSize,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.navigate_next))
                              ],
                            ),
                            Container(
                              height: 125,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: similarImages,
                              ),
                            ),
                            overViewWidgets(context),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.grey.shade300,
                                        child: InkResponse(
                                          onTap: () {
                                            print('tap appeared on facebook');
                                          },
                                          child: Icon(HeartIcon.facebook),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.black,
                                        child: InkResponse(
                                          onTap: () {
                                            print('tap appeared on pinterest');
                                          },
                                          child: Icon(
                                            HeartIcon.pinterest,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.black,
                                        child: InkResponse(
                                          onTap: () {
                                            print(
                                                'Tap appeared on insta button');
                                          },
                                          child: Icon(
                                            HeartIcon.instagram,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.grey.shade300,
                                        child: InkResponse(
                                          onTap: () {
                                            print('Tap Appeared on user icon');
                                          },
                                          child: Icon(HeartIcon.user),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column overViewWidgets(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cartButtons(),
        Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Divider(
                  thickness: 2,
                  color: Colors.grey.shade200,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border(right: BorderSide(color: Colors.black26))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            print('Tap Found on OverView');
                          },
                          child: Container(
                              padding:
                                  EdgeInsets.only(left: 15, top: 5, bottom: 5),
                              width: 150,
                              child: Text('OVERVIEW')),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          width: 120,
                          child: Divider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('Tap Found on Contact Us');
                          },
                          child: Container(
                              padding:
                                  EdgeInsets.only(left: 15, top: 5, bottom: 5),
                              width: 150,
                              child: Text('CONTACT US')),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('NIGHT armchair natural'),
                  )),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Container cartButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    color: Colors.black,
                    padding: EdgeInsets.only(
                        left: 18, right: 18, top: 13, bottom: 13),
                    child: Text(
                      '$changedValue',
                      style: TextStyle(color: Colors.white),
                    )),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  color: Colors.black,
                  height: 30.0,
                  minWidth: 20.0,
                  onPressed: () {
                    setState(() {
                      if (changedValue > 1) {
                        changedValue--;
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Quantity cannot be less then 1 ');
                      }
                    });
                  },
                  child: Container(
                    width: 10,
                    height: 40,
                    child: Container(
                      width: 10,
                      height: 40,
                      child: Divider(
                        thickness: 3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  color: Colors.black,
                  height: 30.0,
                  minWidth: 20.0,
                  onPressed: () {
                    setState(() {
                      if (changedValue < 10 && changedValue != 0) {
                        changedValue++;
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Quantity cannot be greater then 10 ');
                      }
                    });
                  },
                  child: Container(
                      width: 10,
                      height: 40,
                      child: Center(
                        child: Text(
                          '+',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: ConstantsVar.appColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedBackScreen()));
              },
              child: Text(
                'Add to Cart',
                style: TextStyle(
                    letterSpacing: 1,
                    wordSpacing: 1,
                    color: Colors.white,
                    fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column stockDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SKU : 6666566',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.start,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
          child: Text(
            'Availability : In Stock',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }

  Column productImages(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                    height: 250,
                    disableCenter: false,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ConstantsVar.netImages.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 30.0,
                      height: 3.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        )
      ],
    );
  }
}

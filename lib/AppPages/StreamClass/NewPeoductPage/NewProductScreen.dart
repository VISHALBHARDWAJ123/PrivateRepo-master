import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay/flutter_overlay.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/ContactsUS/ContactsUS.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Slider.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:loader_overlay/loader_overlay.dart';

class NewProductDetails extends StatefulWidget {
  NewProductDetails({Key? key, required this.productId}) : super(key: key);
  final productId;

  @override
  _NewProductDetailsState createState() => _NewProductDetailsState();
}

class _NewProductDetailsState extends State<NewProductDetails> {
  var visible;
  var indVisibility;
  var snapshot;
  var customerId;
  var guestCustomerID;
  var productID;
  var name;
  var description;
  var price;
  double? priceValue;
  var sku;
  var stockAvailabilty;
  var image1;
  var image2;
  var image3;
  var id;
  List<String> imageList = [];
  List<String> largeImage = [];
  var connectionStatus;
  bool isScroll = true;
  var assemblyCharges;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      productID = widget.productId;
      guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                radius: 48,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CartScreen2(),
                  ),
                ),
              ),
            )
          ],
          toolbarHeight: 18.w,
          backgroundColor: ConstantsVar.appColor,
          centerTitle: true,
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => MyHomePage()),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
        ),
        body: FutureBuilder<dynamic>(
            future: ApiCalls.getProductData('$productID'),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                    child: Center(
                      child: SpinKitRipple(
                        color: Colors.red,
                        size: 90,
                      ),
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return SafeArea(
                      top: true,
                      child: Scaffold(
                        body: Container(
                          child: Center(
                            child: Text(
                              snapshot.error.toString(),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    Map<String, dynamic> items = snapshot.data;
                    imageList.clear();

                    for (int i = 0;
                        i <= items['PictureModels'].length - 1;
                        i++) {
                      image1 = items['PictureModels'][i]['ImageUrl'];
                      image2 = items['PictureModels'][i]['FullSizeImageUrl'];
                      imageList.add(image1);
                      largeImage.add(image2);
                    }

                    image2 = items['PictureModels'][0]['FullSizeImageUrl'];

                    id = items['id'];

                    name = items['Name'];
                    description = items['ShortDescription'];
                    price = items['ProductPrice']['Price'];
                    priceValue = items['ProductPrice']['PriceValue'];
                    sku = items['Sku'];
                    stockAvailabilty = items['StockAvailability'];
                    assemblyCharges = items['ProductAttributes'].length != 0
                        ? 'Assembly Charges ' +
                            items['ProductAttributes'][0]['Values'][0]
                                ['PriceAdjustment'] +
                            ' includes'
                        : '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 9,
                          child: customList(
                            context: context,
                            name: name,
                            price: price,
                            descritption: description,
                            priceValue: '$priceValue',
                            sku: sku,
                            stockAvaialbility: stockAvailabilty,
                            imageList: imageList,
                            largeImage: largeImage,
                            assemblyCharges: assemblyCharges,
                            items: items,
                          ),
                        ),
                        Container(
                          width: 100.w,
                          child: AddCartBtn(
                            productId: id,
                            isTrue: false,
                            guestCustomerId: guestCustomerID,
                          ),
                        )
                      ],
                    );
                  }
              }
            }),
      ),
    );
  }

  ListView customList(
      {required BuildContext context,
      required String name,
      required String descritption,
      required String sku,
      required String stockAvaialbility,
      required String price,
      required String priceValue,
      required List<String> imageList,
      required List<String> largeImage,
      required String assemblyCharges,
      required dynamic items}) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(child: SliderImages(imageList, largeImage, context)),
        ),
        Container(
          height: 36.h,
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(255, 234, 235, 235),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  style: TextStyle(
                    wordSpacing: 1,
                    letterSpacing: 1,
                    fontSize: 7.w,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 3.w,
                    bottom: 3.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        descritption,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 5.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'SKU: $sku',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 6.3.w,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.w, bottom: 2.w),
                  child: RichText(
                    text: TextSpan(
                      text: 'Availablity: '.toUpperCase(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 5.w,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                            text: stockAvaialbility,
                            style: TextStyle(
                              fontSize: 5.w,
                              color: stockAvailabilty.contains('In')
                                  ? Colors.green
                                  : Colors.red,
                            ))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: assemblyCharges.length != 0 ||
                          assemblyCharges.isNotEmpty ||
                          assemblyCharges != null
                      ? true
                      : false,
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.w, bottom: 1.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          assemblyCharges,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 4.w,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            letterSpacing: 1,
                            wordSpacing: 2,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.5.w, bottom: 1.5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 7.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1,
                          wordSpacing: 2,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Divider(
            thickness: 2,
          ),
        ),
        ExpandablePanel(
          header: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text('OVERVIEW', style: TextStyle(fontSize: 4.w)),
          ),
          collapsed: Text(
            '',
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          expanded: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 6.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => HiOverlay.show(context, child: ContactUS(id: id, name: name, desc: descritption)),
          child: Container(
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(width: 1, color: Colors.black))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 13.0),
              child: Text('CONTACT US'),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

void showDialog1(BuildContext context) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 400),
    context: context,
    pageBuilder: (_, __, ___) {
      return Card(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.PrimaryAccentColor, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          height: 5.8.h,
          child: CupertinoScrollbar(
            child: ListView(children: [
              ListTile(
                title: TextFormField(),
              ),
              ListTile(
                title: TextFormField(),
              ),
            ]),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, .7)).animate(anim),
        child: child,
      );
    },
  );
}

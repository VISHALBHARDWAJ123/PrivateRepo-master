import 'package:badges/badges.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_overlay/flutter_overlay.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/ContactsUS/ContactsUS.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Slider.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:untitled2/utils/utils/colors.dart';
// import 'package:loader_overlay/loader_overlay.dart';

import 'ProductResponse.dart';

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
  FocusNode yourfoucs = FocusNode();
  ProductResponse? initialData;

  var _isVisibility;

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
    ApiCalls.getProductData('$productID').then((value) {
      ProductResponse myResponse = ProductResponse.fromJson(value);
      setState(() {
        initialData = myResponse;

        // List<Value> value=[] ;
        for (int i = 0; i <= initialData!.pictureModels.length - 1; i++) {
          image1 = initialData!.pictureModels[i].imageUrl;
          image2 = initialData!.pictureModels[i].fullSizeImageUrl;
          imageList.add(image1);
          largeImage.add(image2);
          // setState((){value.addAll(initialData!.productAttributes[i].values);});
        }

        // image2 = initialData['PictureModels'][0]['FullSizeImageUrl'];

        id = initialData!.id;
        name = initialData!.name;
        description = initialData!.shortDescription;
        price = initialData!.productPrice.price;
        priceValue =
            double.parse(initialData!.productPrice.priceValue.toString());
        sku = initialData!.sku;
        stockAvailabilty = initialData!.stockAvailability;

        if (initialData!.productAttributes!.length != 0) {
          if (initialData!
                  .productAttributes![0].values[0].priceAdjustmentValue !=
              0.0) {
            setState(() {
              _isVisibility = true;
              assemblyCharges = 'Assembly Charges ' +
                  initialData!.productAttributes![0].values[0].priceAdjustment +
                  ' includes';
            });
          }
        } else {
          setState(() {

            _isVisibility = true;
            assemblyCharges = '';
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (initialData == null) {
      return SafeArea(
        child: Scaffold(
          body: Container(
              child: Center(child: SpinKitRipple(color: Colors.red, size: 90))),
        ),
      );
    } else {
      return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: new AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: InkWell(
                    radius: 48,
                    child: Consumer<cartCounter>(
                      builder: (context, value, child) {
                        return Badge(
                          badgeColor: Colors.white,
                          badgeContent: new Text(value.badgeNumber.toString()),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                        );
                      },
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
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  // flex: 9,
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
                    initialData: initialData,
                  ),
                ),
                Container(
                  width: 100.w,
                  child: AddCartBtn(
                    productId: id,
                    isTrue: false,
                    guestCustomerId: guestCustomerID,
                    checkIcon:
                        stockAvailabilty.toString().contains('Out of stock')
                            ? Icon(HeartIcon.cross)
                            : Icon(Icons.check),
                    text: stockAvailabilty.toString().contains('Out of stock')
                        ? 'out of stock'.toUpperCase()
                        : 'add to cart'.toUpperCase(),
                    color: stockAvailabilty.toString().contains('Out of stock')
                        ? Colors.grey.shade700
                        : ConstantsVar.appColor,
                  ),
                )
              ],
            )),
      );
    }
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
      required dynamic initialData}) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(child: SliderImages(imageList, largeImage, context)),
        ),
        Container(
          height: 40.h,
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(255, 234, 235, 235),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    bottom: 2.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        descritption,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 5.w,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'SKU: $sku',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 5.w,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Availability: '.toUpperCase(),
                    style: TextStyle(
                        color: Colors.grey.shade700,
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
                Visibility(
                  maintainSize: false,
                  visible: assemblyCharges == null?false: true,

                  child: Text(
                    assemblyCharges == null ? '': assemblyCharges,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 5.w,
                      color: Colors.grey.shade700,
                      letterSpacing: 1,
                      wordSpacing: 2,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Text(
                  price,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 7.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    letterSpacing: 1,
                    wordSpacing: 2,
                  ),
                  textAlign: TextAlign.start,
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
                  name,
                  style: TextStyle(
                    fontSize: 6.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      ContactUS(id: sku, name: name, desc: descritption))),
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

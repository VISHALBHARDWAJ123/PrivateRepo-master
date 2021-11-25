import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:menu_button/menu_button.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import 'RetrunResponse.dart';

class ReturnScreen extends StatefulWidget {
  String orderId;

  ReturnScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  _ReturnScreenState createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  RetrunOrderResponse? returnResponse;
  List<ReturnableItem> itemList = [];
  final colorizeTextStyle =
      TextStyle(fontSize: 6.w, fontWeight: FontWeight.bold);

  final colorizeColors = [
    Colors.lightBlueAccent,
    Colors.grey,
    Colors.black,
    ConstantsVar.appColor,
  ];

  var _scrollController;

  List<ReturnableItem> mList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();

    getRetrunableItems();
  }

  List<int> _quantity = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: ConstantsVar.appColor,
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyHomePage(
                    pageIndex: 0,
                  ),
                ),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 18.w,
        ),
        body: returnResponse == null
            ? Container(
                child: Center(
                  child: SpinKitRipple(
                    color: Colors.red,
                    size: 90,
                  ),
                ),
              )
            : itemList.length == 0
                ? Container(
                    child: Center(
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          ColorizeAnimatedText(
                            'No Data Available',
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 100.h,
                    width: 100.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListTile(
                          title: Center(
                            child: AutoSizeText(
                              'RETURN ITEM(S) FROM ORDER #${widget.orderId}',
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 6.w,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: VsScrollbar(
                            controller: _scrollController,
                            isAlwaysShown: true,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: itemList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => NewProductDetails(
                                          screenName: 'Return Order Screen',
                                          productId: itemList[index].productId,
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    Fluttertoast.showToast(
                                      msg: itemList[index]
                                          .productName
                                          .toString()
                                          .toUpperCase(),
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          // borderRadius:
                                          ),
                                      child: Container(
                                        // height: 35.h,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0, vertical: 2),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Center(
                                                child: AutoSizeText(
                                                  '\Sr. no. \# ' +
                                                      (index+1)
                                                          .toString()
                                                          .toUpperCase(),
                                                  // maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  // textAlign: TextAlign.center,
                                                  style: CustomTextStyle
                                                      .textFormFieldBold
                                                      .copyWith(
                                                          fontSize: 5.5.w),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                // height: 40.w,
                                                width: 100.w,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Utils.getSizedBox(
                                                      null,
                                                      3,
                                                    ),
                                                    Container(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: 'Name: ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 4.w,
                                                            // fontWeight:
                                                            //     FontWeight.bold,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: itemList[
                                                                      index]
                                                                  .productName
                                                                  .toString()
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 4.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,

                                                                // fontWeight:
                                                                //     FontWeight
                                                                //         .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Utils.getSizedBox(null, 6),
                                                    Container(
                                                        child: AutoSizeText(
                                                      'Total Quantity: ' +
                                                          itemList[index]
                                                              .quantity
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontSize: 4.w,

                                                        // fontWeight:
                                                        //     FontWeight.bold,
                                                      ),
                                                    )),
                                                    Utils.getSizedBox(null, 20),
                                                    Container(
                                                      width: 100.w,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          AutoSizeText(
                                                            'Price: ' +
                                                                '${itemList[index].unitPrice == null ? '' : itemList[index].unitPrice.toString()}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 4.w,

                                                              // fontWeight:
                                                              //     FontWeight.bold,
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text(
                                                                  'Select Quantity'),
                                                              CustomDropDown(
                                                                mList: mList,
                                                                returnableItem:
                                                                    itemList[
                                                                        index],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Utils.getSizedBox(null, 10),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  void getRetrunableItems() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    var apiToken = ConstantsVar.prefs.getString('apiTokken');
    var customerId = ConstantsVar.prefs.getString('userId');

    final url = Uri.parse(BuildConfig.base_url +
        'apis/GetReturnRequestForm?apiToken=$apiToken&customerid=$customerId&orderId=${widget.orderId}');
    print(url);

    try {
      var response = await get(url);
      print(response.body);
      if (mounted) {
        returnResponse = RetrunOrderResponse.fromJson(
          jsonDecode(response.body),
        );
        itemList = returnResponse!.returnrequestform.items;
        setState(() {});
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }
}

class CustomDropDown extends StatefulWidget {
  final ReturnableItem returnableItem;
  List<ReturnableItem> mList;

  CustomDropDown({
    Key? key,
    required this.returnableItem,
    required this.mList,
  }) : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return MenuButton<int>(
      divider: Container(
        width: 10.w,
        child: Divider(
          thickness: 2,
          color: Colors.black,
        ),
      ),
      scrollPhysics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (value) {
        return Container(
          height: 30,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: Text(value.toString()),
        );
      },
      topDivider: true,
      items:
          List.generate(widget.returnableItem.quantity + 1, (_index) => _index),
      toggledChild: Container(
        child: Container(
          height: 2.w,
          child: Text(_quantity.toString()),
        ),
      ),
      onItemSelected: (value)
          // wait mam
          {
        _quantity = value;
        Fluttertoast.showToast(
          msg: _quantity.toString(),
        );
        setState(() {});
      },
      child: normalChildButton(
        _quantity.toString(),
      ),
    );
  }

  Widget normalChildButton(String _name) => SizedBox(
        width: 93,
        height: 30,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Text(_name == null ? '' : _name,
                      overflow: TextOverflow.ellipsis)),
              const SizedBox(
                width: 12,
                height: 17,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

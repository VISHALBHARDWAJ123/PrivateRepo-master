import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
// import 'package:untitled2/AppPages/NewSubCategoryPage/ModelClass/NewSubCatProductModel.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/utils/build_config.dart';

class SubCatNew extends StatefulWidget {
  SubCatNew({Key? key, required this.catId, required this.title})
      : super(key: key);
  final String catId;
  final title;

  @override
  _SubCatNewState createState() => _SubCatNewState();
}

class _SubCatNewState extends State<SubCatNew> {
  List<dynamic> myList = [];
  var customerId;
  late bool isSubCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("SubCatNew");
    print('${widget.catId}');
    getSubCategories(widget.catId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getSubCategories(widget.catId),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SafeArea(
                  top: true,
                  child: Scaffold(
                      appBar: new AppBar(
                        toolbarHeight: 18.w,
                        backgroundColor: ConstantsVar.appColor,
                        centerTitle: true,
                        // leading: Icon(Icons.arrow_back_ios),
                        title: InkWell(
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => MyHomePage(pageIndex: 0,)),
                              (route) => false),
                          child: Image.asset(
                            'MyAssets/logo.png',
                            width: 15.w,
                            height: 15.w,
                          ),
                        ),
                      ),
                      body: Container(
                          child: Center(
                        child: SpinKitRipple(color: Colors.red, size: 90),
                      ))));
            default:
              if (snapshot.hasError) {
                return SafeArea(
                  top: true,
                  child: Scaffold(
                    body: Container(
                      child: Center(
                        child: AutoSizeText(
                          snapshot.error.toString(),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                myList = snapshot.data;

                return SafeArea(
                  top: true,
                  child: Scaffold(
                    appBar: new AppBar(
                      toolbarHeight: 18.w,
                      backgroundColor: ConstantsVar.appColor,
                      centerTitle: true,
                      // leading: Icon(Icons.arrow_back_ios),
                      title: InkWell(
                        onTap: () => Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MyHomePage(pageIndex: 0,)),
                            (route) => false),
                        child: Image.asset(
                          'MyAssets/logo.png',
                          width: 15.w,
                          height: 15.w,
                        ),
                      ),
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey.shade200,
                          padding: EdgeInsets.all(2.h),
                          child: Center(
                            child: AutoSizeText(
                              widget.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 6.w),
                              softWrap: true,
                            ),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: myList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(8.0),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, int index) {
                            isSubCategory = myList[index]['IsSubcategory'];
                            return InkWell(
                              onTap: () {
                                print('${myList[index]['Id']}');
                                String id = myList[index]['Id'].toString();
                                isSubCategory == true
                                    ? Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                        return SubCatNew(
                                            catId: id,
                                            title: myList[index]['Name']);
                                      }))
                                    : Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                        return ProductList(
                                          categoryId: myList[index]['Id'],
                                          title: myList[index]['Name'],
                                        );
                                      }));
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Container(
                                    // padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Card(
                                                  elevation: 8,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: myList[index]
                                                          ['PictureUrl'],
                                                      fit: BoxFit.fill,
                                                      width: 33.w,
                                                      height: 16.h,
                                                      placeholder:
                                                          (context, reason) {
                                                        return Center(
                                                          child: SpinKitRipple(
                                                            color: Colors.red,
                                                            size: 90,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ))),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.all(2.w),
                                            height: 18.h,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: AutoSizeText(
                                                    myList[index]['Name'],
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        height: 1.1,
                                                        fontSize: 5.w,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ))
                      ],
                    ),
                  ),
                );
              }
          }
        });
  }

  Future getSubCategories(String catId) async {
    final uri = Uri.parse(
        BuildConfig.base_url+'apis/GetSubCategories?categoryid=$catId');
    try {
      var response = await http.get(uri);
      print(json.decode(response.body));
      return json.decode(response.body)['ResponseData'];
    } on Exception catch (e) {
    ConstantsVar.excecptionMessage(e);
    }
  }
}

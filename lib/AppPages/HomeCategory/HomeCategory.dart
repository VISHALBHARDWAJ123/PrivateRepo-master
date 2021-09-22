import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/NewSCategoryPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

class HomeCategory extends StatefulWidget {
  const HomeCategory({Key? key}) : super(key: key);

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ConstantsVar.subscription = ConstantsVar.connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          // ApiCalls.homeScreenProduct(context);
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            toolbarHeight: 18.w,
            backgroundColor: ConstantsVar.appColor,
            // leading: IconButton(
            //     onPressed: () => Navigator.pushAndRemoveUntil(context,
            //             CupertinoPageRoute(builder: (context) {
            //           return MyHomePage();
            //         }), (route) => false),
            //     icon: Icon(Icons.arrow_back)),
            title: InkWell(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => MyApp()),
                  (route) => false),
              child: Image.asset(
                'MyAssets/logo.png',
                width: 15.w,
                height: 15.w,
              ),
            ),
          ),
          body: FutureBuilder<dynamic>(
            future: ApiCalls.getCategory(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                var result = snapshot.data;
                List<dynamic> resultList = result;
                resultList
                  ..sort(
                      (a, b) => a['DisplayOrder'].compareTo(b['DisplayOrder']));
                // List<dynamic> subList = result['sbc'];
                // subList..sort((a, b) => a['DisplayOrder'].compareTo(b['DisplayOrder']));
                return FlutterSizer(
                    builder: (context, orientation, deviceType) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100.w,
                          color: Colors.grey.shade200,
                          padding: EdgeInsets.all(2.h),
                          child: Center(
                            child: Text(
                              'SHOP BY CATEGORY',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 6.w),
                              softWrap: true,
                            ),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: resultList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(1.h, 0, 1.h, 2.h),
                              child: Container(
                                // color: Colors.amberAccent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        //TopLevel Category Details
                                        print('${resultList[index]['id']}');
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        color:
                                            Color.fromARGB(255, 199, 198, 198),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(
                                            top: 2.0, bottom: 2.0),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 8.0, bottom: 8.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                            top: BorderSide(
                                                width: .3, color: Colors.white),
                                            bottom: BorderSide(
                                                width: .3, color: Colors.white),
                                          )),
                                          child: Center(
                                            child: Text(
                                                resultList[index]['name'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .06)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          resultList[index]['sbc'].length,
                                      itemBuilder: (context, minindex) {
                                        var imageUrl = resultList[index]['sbc']
                                            [minindex]!['ImageUrl'];
                                        var name = resultList[index]['sbc']
                                            [minindex]!['Name'];
                                        // resultList[index]['sbc']
                                        //   ..sort((a, b) => a['DisplayOrder']
                                        //       .compareTo(b['DisplayOrder']));
                                        bool isSubCategory = resultList[index]
                                            ['sbc'][minindex]['IsSubCategory'];
                                        return InkWell(
                                          onTap: () {
                                            if (isSubCategory == true) {
                                              var id =
                                                  '${resultList[index]['sbc'][minindex]['Id']}';

                                              print(id);

                                              var title = resultList[index]
                                                  ['sbc'][minindex]['Name'];
                                              Navigator.push(context,
                                                  CupertinoPageRoute(
                                                      builder: (context) {
                                                return SubCatNew(
                                                    catId: id, title: title);
                                              }));
                                            } else {
                                              var id =
                                                  '${resultList[index]['sbc'][minindex]['Id']}';
                                              var title = resultList[index]
                                                  ['sbc'][minindex]['Name'];
                                              Navigator.push(context,
                                                  CupertinoPageRoute(
                                                      builder: (context) {
                                                return ProductList(
                                                    categoryId: id,
                                                    title: title);
                                              }));
                                            }
                                          },
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 12.0,
                                              ),
                                              child: Container(
                                                // padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Card(
                                                              elevation: 12,
                                                              shadowColor:
                                                                  Colors.grey,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      imageUrl,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 33.w,
                                                                  height: 16.h,
                                                                  placeholder:
                                                                      (context,
                                                                          reason) {
                                                                    return Center(
                                                                      child:
                                                                          SpinKitRipple(
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            90,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ))),
                                                    Expanded(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        padding:
                                                            EdgeInsets.all(2.w),
                                                        height: 18.h,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child: Text(
                                                                name,
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    height: 1.1,
                                                                    fontSize:
                                                                        5.w,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
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
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ))
                      ]);
                });
              } else {
                return Container(
                  child: Center(
                    child: SpinKitRipple(
                      size: 90,
                      color: Colors.red,
                    ),
                  ),
                );
              }
            },
          )),
    );
  }
}

import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/NewSCategoryPage.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

class HomeCategory extends StatefulWidget {
  const HomeCategory({Key? key}) : super(key: key);

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  TextEditingController _searchController = TextEditingController();
  var _focusNode = FocusNode();

  var isVisible = false;
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  Color btnColor = Colors.black;

  var _suggestController = ScrollController();
  List<String> searchSuggestions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
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
            body: ListView(
              padding: EdgeInsets.only(
                bottom: 16.h,
              ),
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  color: ConstantsVar.appColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: RawAutocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == null ||
                              textEditingValue.text == '' ||
                              textEditingValue.text.length < 3) {
                            return const Iterable<String>.empty();
                          }
                          return searchSuggestions.where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          debugPrint('$selection selected');
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          _searchController = textEditingController;
                          _focusNode = focusNode;
                          // FocusScopeNode currentFocus = FocusScopeNode.of(context);
                          return TextFormField(
                            autocorrect: true,
                            enableSuggestions: true,
                            onFieldSubmitted: (val) {
                              focusNode.unfocus();
                              if (currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (mounted)
                                setState(() {
                                  var value = _searchController.text;
                                  Navigator.of(context)
                                      .push(
                                        CupertinoPageRoute(
                                          builder: (context) => SearchPage(
                                            isScreen: true,
                                            keyword: value,
                                          ),
                                        ),
                                      )
                                      .then((value) => setState(() {
                                            _searchController.clear();
                                          }));
                                });

                              print('Pressed via keypad');
                            },
                            textInputAction: isVisible
                                ? TextInputAction.done
                                : TextInputAction.search,
                            // keyboardType: TextInputType.,
                            keyboardAppearance: Brightness.light,
                            // autofocus: true,
                            onChanged: (_) => setState(() {
                              btnColor = ConstantsVar.appColor;
                            }),
                            controller: _searchController,
                            style:
                                TextStyle(color: Colors.black, fontSize: 5.w),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 10),
                              hintText: 'Search here',
                              labelStyle:
                                  TextStyle(fontSize: 7.w, color: Colors.grey),
                              suffixIcon: InkWell(
                                onTap: () async {
                                  focusNode.unfocus();

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  if (mounted)
                                    setState(() {
                                      var value = _searchController.text;
                                      Navigator.of(context)
                                          .push(
                                            CupertinoPageRoute(
                                              builder: (context) => SearchPage(
                                                isScreen: true,
                                                keyword: value,
                                              ),
                                            ),
                                          )
                                          .then((value) => setState(() {
                                                _searchController.clear();
                                              }));
                                    });
                                },
                                child: Icon(Icons.search_sharp),
                              ),
                            ),
                            focusNode: _focusNode,
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              right: 10,
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Material(
                                child: Card(
                                  child: Container(
                                    height: 178,
                                    child: Scrollbar(
                                      controller: _suggestController,
                                      thickness: 5,
                                      isAlwaysShown: true,
                                      child: ListView.builder(
                                        // padding: EdgeInsets.all(8.0),
                                        itemCount: options.length + 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index >= options.length) {
                                            return Align(
                                              alignment: Alignment.bottomCenter,
                                              child: TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                    color:
                                                        ConstantsVar.appColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _searchController.clear();
                                                },
                                              ),
                                            );
                                          }
                                          final String option =
                                              options.elementAt(index);
                                          return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                              },
                                              child: Container(
                                                height: 5.2.h,
                                                width: 95.w,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100.w,
                                                      child: AutoSizeText(
                                                        '  ' + option,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          wordSpacing: 2,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100.w,
                                                      child: Divider(
                                                        thickness: 1,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )

                                              // ListTile(
                                              //   title: Text(option),
                                              //   subtitle: Container(
                                              //     width: 100.w,
                                              //     child: Divider(
                                              //       thickness: 1,
                                              //       color:
                                              //           ConstantsVar.appColor,
                                              //     ),
                                              //   ),
                                              // ),
                                              );
                                        },
                                      ),
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
                ),
                Container(
                  height: 100.h,
                  child: FutureBuilder<dynamic>(
                    future: ApiCalls.getCategory(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        var result = snapshot.data;
                        List<dynamic> resultList = result;
                        resultList
                          ..sort((a, b) =>
                              a['DisplayOrder'].compareTo(b['DisplayOrder']));

                        return FlutterSizer(
                            builder: (context, orientation, deviceType) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 100.w,
                                  color: Colors.grey.shade200,
                                  padding: EdgeInsets.all(2.h),
                                  child: Center(
                                    child: AutoSizeText(
                                      'SHOP BY CATEGORY',
                                      style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(1.0, 1.2),
                                              blurRadius: 3.0,
                                              color: Colors.grey.shade300,
                                            ),
                                            Shadow(
                                              offset: Offset(1.0, 1.2),
                                              blurRadius: 8.0,
                                              color: Colors.grey.shade300,
                                            ),
                                          ],
                                          fontSize: 5.w,
                                          fontWeight: FontWeight.bold),
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: ListView.builder(
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  itemCount: resultList.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index >= resultList.length) {
                                      return Container(
                                        height: 35.h,
                                      );
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            1.h, 0, 1.h, 2.h),
                                        child: Container(
                                          // color: Colors.amberAccent,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  //TopLevel Category Details
                                                  print(
                                                      '${resultList[index]['id']}');
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 8),
                                                  color: Color.fromARGB(
                                                      255, 199, 198, 198),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.only(
                                                      top: 2.0, bottom: 2.0),
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 8.0, bottom: 8.0),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                      top: BorderSide(
                                                          width: .3,
                                                          color: Colors.white),
                                                      bottom: BorderSide(
                                                          width: .3,
                                                          color: Colors.white),
                                                    )),
                                                    child: Center(
                                                      child: AutoSizeText(
                                                        resultList[index]
                                                                ['name']
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: Offset(
                                                                  1.0, 1.2),
                                                              blurRadius: 3.0,
                                                              color: Colors.grey
                                                                  .shade300,
                                                            ),
                                                            Shadow(
                                                              offset: Offset(
                                                                  1.0, 1.2),
                                                              blurRadius: 8.0,
                                                              color: Colors.grey
                                                                  .shade300,
                                                            ),
                                                          ],
                                                          fontSize: 5.w,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                padding: EdgeInsets.only(),
                                                itemCount: resultList[index]
                                                        ['sbc']
                                                    .length,
                                                itemBuilder:
                                                    (context, minindex) {
                                                  var imageUrl = resultList[
                                                          index]['sbc']
                                                      [minindex]!['ImageUrl'];
                                                  var name = resultList[index]
                                                          ['sbc']
                                                      [minindex]!['Name'];
                                                  // resultList[index]['sbc']
                                                  //   ..sort((a, b) => a['DisplayOrder']
                                                  //       .compareTo(b['DisplayOrder']));
                                                  bool isSubCategory =
                                                      resultList[index]['sbc']
                                                              [minindex]
                                                          ['IsSubCategory'];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 12.0,
                                                    ),
                                                    child: OpenContainer(
                                                      closedElevation: 0,
                                                      openElevation: 0,
                                                      // padding: EdgeInsets.all(8.0),
                                                      openBuilder: (BuildContext
                                                              context,
                                                          void Function(
                                                                  {Object?
                                                                      returnValue})
                                                              action) {
                                                        if (isSubCategory ==
                                                            true) {
                                                          var id =
                                                              '${resultList[index]['sbc'][minindex]['Id']}';

                                                          print(
                                                              'SubCategory id>>>>>>' +
                                                                  id.toString());

                                                          var title =
                                                              resultList[index][
                                                                          'sbc']
                                                                      [minindex]
                                                                  ['Name'];

                                                          return SubCatNew(
                                                              catId: id,
                                                              title: title);
                                                        } else {
                                                          var id =
                                                              '${resultList[index]['sbc'][minindex]['Id']}';
                                                          var title =
                                                              resultList[index][
                                                                          'sbc']
                                                                      [minindex]
                                                                  ['Name'];

                                                          return ProductList(
                                                              categoryId: id,
                                                              title: title);
                                                        }
                                                      },
                                                      closedBuilder:
                                                          (BuildContext context,
                                                              void Function()
                                                                  action) {
                                                        return Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  //color: const Color(0xFF66BB6A),
                                                                  // boxShadow: [
                                                                  //   BoxShadow(
                                                                  //     color: Colors
                                                                  //         .grey
                                                                  //         .shade400,
                                                                  //     blurRadius:
                                                                  //         0,
                                                                  //     offset:
                                                                  //         Offset(
                                                                  //             1,
                                                                  //             1),
                                                                  //   ),
                                                                  // ],
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        imageUrl,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: 33.w,
                                                                    height:
                                                                        33.w,
                                                                    placeholder:
                                                                        (context,
                                                                            reason) {
                                                                      return Center(
                                                                        child:
                                                                            SpinKitRipple(
                                                                          color:
                                                                              Colors.red,
                                                                          size:
                                                                              90,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                )),
                                                            Expanded(
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2
                                                                            .w),
                                                                height: 18.h,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
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
                                                                      child:
                                                                          AutoSizeText(
                                                                        name
                                                                            .toString()
                                                                            .toUpperCase(),
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: TextStyle(
                                                                            height:
                                                                                1.1,
                                                                            fontSize:
                                                                                5.w,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
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
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        String listString = ConstantsVar.prefs.getString('searchList')!;
        // print(listString);
        List<dynamic> testingList = jsonDecode(listString);
        searchSuggestions = testingList.cast<String>();
        print(searchSuggestions.length.toString());
      });
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';

// import 'package:untitled2/AppPages/NewSubCategoryPage/ModelClass/NewSubCatProductModel.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
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

  bool isShown = false;

  TextEditingController _searchController = TextEditingController();
  var _focusNode = FocusNode();

  var isVisible = false;

  Color btnColor = Colors.black;

  var _suggestController = ScrollController();

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

  List<String> searchSuggestions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("SubCatNew Screen is Here");
    initSharedPrefs();
    print('${widget.catId}');
    getSubCategories(widget.catId);
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
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
                    builder: (context) => MyHomePage(
                          pageIndex: 0,
                        )),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
        ),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            Platform.isIOS?checkBackSwipe(details):print('Android Here');
          },
          onTap: () {
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                                          enableCategory: false,
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
                          style: TextStyle(color: Colors.black, fontSize: 5.w),
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
                                              enableCategory: false,
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
                                                  color: ConstantsVar.appColor,
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
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      SearchPage(
                                                    keyword: option,
                                                    isScreen: true,
                                                    enableCategory: false,
                                                  ),
                                                ),
                                              ).then((value) => setState(() {
                                                    _searchController.clear();
                                                  }));
                                            },
                                            child: Container(
                                              height: 5.2.h,
                                              width: 95.w,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
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
                                                      color:
                                                          Colors.grey.shade400,
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
                    future: getSubCategories(widget.catId),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container(
                              child: Center(
                            child: SpinKitRipple(color: Colors.red, size: 90),
                          ));
                        default:
                          if (snapshot.hasError) {
                            return Container(
                                child: Center(
                              child: AutoSizeText(
                                snapshot.error.toString(),
                              ),
                            ));
                          } else {
                            myList = snapshot.data;

                            return SubCatWidget(
                              title: widget.title,
                              myList: myList,
                            );
                          }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getSubCategories(String catId) async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetSubCategories?categoryid=$catId&CustId=${ConstantsVar.prefs.getString('guestCustomerID')}');
    print(uri);
    try {
      var response = await http.get(
        uri,
        headers: ApiCalls.header,
      );
      print(json.decode(response.body));
      return json.decode(response.body)['ResponseData'];
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  checkBackSwipe(DragUpdateDetails details) {
    if (details.delta.direction <= 0 ) {
      Navigator.pop(context);
    }
  }
}

class SubCatWidget extends StatefulWidget {
  SubCatWidget({
    Key? key,
    required this.title,
    required this.myList,
  }) : super(key: key);
  final title;
  List<dynamic> myList;

  @override
  _SubCatWidgetState createState() => _SubCatWidgetState();
}

class _SubCatWidgetState extends State<SubCatWidget> {
  bool? isSubCategory;

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade200,
          padding: EdgeInsets.all(2.h),
          child: Center(
            child: AutoSizeText(
              widget.title.toString().toUpperCase(),
              style: TextStyle(shadows: <Shadow>[
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
              ], fontSize: 5.w, fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: widget.myList.length,
          shrinkWrap: false,
          padding: EdgeInsets.only(bottom: 220),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: OpenContainer(
                closedElevation: 2,
                openElevation: 0,
                middleColor: Colors.white,
                transitionType: _transitionType,
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  isSubCategory = widget.myList[index]['IsSubcategory'] as bool;

                  String id = widget.myList[index]['Id'].toString();
                  print(isSubCategory);
                  print('isSubCategory id' + id);
                  print('${widget.myList[index]['Id']}');
                  if (isSubCategory == true) {
                    print('I am going to Subcategory Page');
                    return SubCatNew(
                        catId: id, title: widget.myList[index]['Name']);
                  } else {
                    print('I am going to Product Page');
                    return ProductList(
                      categoryId: widget.myList[index]['Id'],
                      title: widget.myList[index]['Name'],
                    );
                  }
                },
                closedBuilder: (BuildContext context, void Function() action) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.myList[index]['PictureUrl'],
                              fit: BoxFit.fill,
                              width: 33.w,
                              height: 33.w,
                              placeholder: (context, reason) {
                                return Center(
                                  child: SpinKitRipple(
                                    color: Colors.red,
                                    size: 90,
                                  ),
                                );
                              },
                            ),
                          )),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(2.w),
                          height: 18.h,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: AutoSizeText(
                                  widget.myList[index]['Name']
                                      .toString()
                                      .toUpperCase(),
                                  // maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
        )),
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/PojoClass/GridViewModel.dart';
import 'package:untitled2/PojoClass/itemGridModel.dart';
import 'package:untitled2/Widgets/widgets/GridWidgets/horizontalListView.dart';

class HomeScreen extends StatefulWidget {
  List<GridPojo> mList;
  List<GridViewModel> mList1;

  @override
  _HomeScreenState createState() => _HomeScreenState();

  HomeScreen(this.mList, this.mList1);
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> HorizontalimageSliders = ConstantsVar.mList1
        .map((item) => AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          ConstantsVar.productID = 1021;
                        });
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return StreamProductClass(
                        //     productId: ConstantsVar.productID,
                        //   );
                        // }));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(item.images),
                            Text(
                              '${item.discount}',
                              style: TextStyle(color: Colors.lightGreenAccent),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Text('${item.type}')),
                          ],
                        ),
                      ),
                    )),
              ),
            ))
        .toList();

    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      // reverse: true,
      // scrollDirection: Axis.vertical,
      children: [
        myHorizontalImages(context),
        Container(
          height: 150,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: HorizontalimageSliders,
          ),
        ),
        customContainer(context),
      ],
    );
  }
}

Widget customContainer(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(width: 20, color: Color.fromARGB(255, 164, 0, 0))),
    constraints:
        BoxConstraints.tight(Size(MediaQuery.of(context).size.width, 400)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Card(
                  child: CachedNetworkImage(
                    imageUrl: ConstantsVar.netImage1,
                    placeholder: (context, reason) {
                      return CupertinoActivityIndicator();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: CachedNetworkImage(
                    imageUrl: ConstantsVar.netImage2,
                    placeholder: (context, reason) {
                      return CupertinoActivityIndicator();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Card(
                  child: CachedNetworkImage(
                    imageUrl: ConstantsVar.netImage3,
                    placeholder: (context, reason) {
                      return CupertinoActivityIndicator();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: CachedNetworkImage(
                    imageUrl: ConstantsVar.netImage4,
                    placeholder: (context, reason) {
                      return CupertinoActivityIndicator();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

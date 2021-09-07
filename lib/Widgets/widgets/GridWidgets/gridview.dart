import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/AppPages/ProductDetail/ProductScreen.dart';
import 'package:untitled2/PojoClass/GridViewModel.dart';

Widget myGridView(List<GridViewModel> images, BuildContext context) {
  return Container(
    constraints:
        BoxConstraints.tight(Size(MediaQuery.of(context).size.width, 170)),
    // fit: FlexFit.tight,
    child: Align(
      alignment: Alignment.topCenter,
      child: GridView.count(
          shrinkWrap: true,
          // crossAxisSpacing: 1,
          childAspectRatio: 1 / 1,
          crossAxisCount: 3,
          children: List.generate(
              images.length, (index) => pickImage(index, images, context))),
    ),
  );
}

pickImage(int index, List<GridViewModel> images, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ProductDe();
      }));
    },
    child: Card(
      shape: RoundedRectangleBorder(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(images[index].images),
          Text(
            '${images[index].discount}',
            style: TextStyle(color: Colors.lightGreenAccent),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Text('${images[index].type}')),
        ],
      ),
    ),
  );
}

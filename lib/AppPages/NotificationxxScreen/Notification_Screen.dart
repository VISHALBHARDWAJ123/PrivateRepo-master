import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

class NotificationClass extends StatefulWidget {
  const NotificationClass({Key? key}) : super(key: key);

  @override
  State<NotificationClass> createState() => _NotificationClassState();
}

class _NotificationClassState extends State<NotificationClass> {
  List<NotificationClass> myNotifications = [];
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('UserNotifications').snapshots();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
            appBar: new AppBar(
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              title: InkWell(
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              ),
            ),
            body: StreamBuilder(
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SpinKitRipple(
                      color: Colors.red,
                      size: 90,
                    ),
                  );
                } else {
                  if (snapshot.data!.docs.length == 0 ||
                      snapshot.data!.docs == null) {
                    return Center(
                      child: Text('No New Notifications'),
                    );
                  } else {
                    return Container(
                      width: 100.w,
                      height: 100.h,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return buildListTile(snapshot.data!.docs[index]);
                        },
                      ),
                    );
                  }
                }
              },
              stream: _stream,
            )));
  }

  Card buildListTile(DocumentSnapshot doc) => Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Image.asset('MyAssets/logo.png'),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              doc['Title'],
              style: TextStyle(
                fontSize: 4.5.w,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          subtitle: Padding(
            child: Text(
              doc['Desc'],
            ),
            padding: const EdgeInsets.symmetric(vertical: 5.0),
          ),
          trailing: Text(doc['Time'] == null ? '' : doc['Time']),
        ),
      );
}

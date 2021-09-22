import 'dart:convert';
import 'dart:ui';
import 'package:loader_overlay/loader_overlay.dart';

// import 'package:custom_dialog_flutter_demo/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

class ContactUS extends StatefulWidget {
  final id;
  final name;
  final desc;

  // final Route route;

  const ContactUS({
    Key? key,
    required this.id,
    required this.name,
    required this.desc,
  }) : super(key: key);

  @override
  _ContactUSState createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> with InputValidationMixin {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController emailBody = TextEditingController();
  var _userName;
  var _email;
  var apiToken;

  bool selected = true;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
    getUserCreds().then((value) => setState(() {
          name.text = _userName;
          email.text = _email;
          String body = 'Name: ' +
              widget.name +
              '\n' '\n' +
              'SKU: ' +
              widget.id.toString() +
              '\n' '\n' +
              'Short Descritption: ' +
              widget.desc +
              '\n' +
              '\n';
          emailBody.text = body;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: new AppBar(
          toolbarHeight: 18.w,
          centerTitle: true,
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyApp(),
                ),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: contentBox(context),
        ),
      ),
    );
  }

  Widget contentBox(context) {
    return Container(
      width: 100.w,
      height: 100.h,
      // padding: EdgeInsets.only(top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8,
              ),
              child: Container(
                width: 100.w,
                child: Center(
                  child: Text(
                    'Contact Us'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 6.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                // padding: EdgeInsets.all(10),
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(
                      'YOUR NAME:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 4.w,
                      ),
                    ),
                    subtitle: TextFormField(
                      validator: (firstName) {
                        if (isFirstName(firstName!))
                          return null;
                        else
                          return 'Enter your Name.';
                      },
                      maxLines: 1,
                      controller: name,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  addVerticalSpace(10),
                  ListTile(
                    title: Text(
                      'YOUR EMAIL:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 4.w,
                      ),
                    ),
                    subtitle: TextFormField(
                      validator: (email) {
                        if (isEmailValid(email!))
                          return null;
                        else
                          return 'Enter a valid email address';
                      },
                      maxLines: 1,
                      // maxLength: 20,
                      controller: email,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  addVerticalSpace(10),
                  ListTile(
                    title: Text(
                      'ENQUIRY:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 4.w,
                      ),
                    ),
                    subtitle: TextFormField(
                      maxLines: 12,
                      // maxLength: ,
                      controller: emailBody,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Container(height: 2,child: Divider(color: Colors.black,))
                ],
              ),
            ),
          ),
          InkWell(
              onTap: () async {
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();
                  sendEnquiry().then((value) => Navigator.pop(context));
                }else{}
              },
              child: Container(
                color: ConstantsVar.appColor,
                height: 15.w,
                width: 100.w,
                child: Center(
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(
                      fontSize: 5.4.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Future sendEnquiry() async {
    // final header = {"content-type": 'application/json'};
    Map<String, dynamic> body = {};
    // var apiToken;
    context.loaderOverlay.show(
        widget: SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));
    setState(() {
      // apiToken = '${ConstantsVar.apiTokken}';
      print(apiToken);
      final contactUsBody = {
        'Email': email.text.toString(),
        'Subject': emailBody.text.toString(),
        'SubjectEnabled': false,
        'FullName': name.text.toString(),
        'SuccessfullySent': false,
        'Result': null,
        'DisplayCaptcha': false,
        'CustomProperties': {}
      };
      print(json.encode(contactUsBody));

      body = {
        'apiToken': apiToken,
        'contactUsModel': json.encode(contactUsBody)
      };
    });
    // String url = ;
    final uri =
        Uri.parse(BuildConfig.base_url + 'customer/SendContactUsEnquiry');
    print(uri);
    try {
      var response = await post(uri, body: body);

      print('${jsonDecode(response.body)}');
      showDialog(
          builder: (context) {
            return CustomDialogBox(
              descriptions: jsonDecode(response.body),
              text: 'You will hear from us soon.',
              img: '',
              isOkay: false,
            );
          },
          context: context);
      context.loaderOverlay.hide();
    } on Exception catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: 'In Progress',
        toastLength: Toast.LENGTH_LONG,
      );
      context.loaderOverlay.hide();
    }
  }

  Future init() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  Future getUserCreds() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    _userName = ConstantsVar.prefs.getString('userName') != null
        ? ConstantsVar.prefs.getString('userName')
        : '';
    _email = ConstantsVar.prefs.getString('email') != null
        ? ConstantsVar.prefs.getString('email')
        : '';
    apiToken = ConstantsVar.apiTokken;
  }
}

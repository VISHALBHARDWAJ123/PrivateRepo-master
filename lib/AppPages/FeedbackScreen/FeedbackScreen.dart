import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({Key? key}) : super(key: key);

  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  @override
  Widget build(BuildContext context) {
    double value = 1;
    double initialValue = 1;
    return SafeArea(
      top: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            feedbackBanner(context),
            Expanded(
              flex: 8,
              child: ListView(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      child: Text(
                        'SUBMIT YOUR VALUABLE REVIEW',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: RatingBarWidget(
                      size: 42,
                      spacing: 20,
                      rating: initialValue,
                      allowHalfRating: true,
                      onRatingChanged: (aRating) {
                        value = aRating;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Review',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: AppTextField(
                            textStyle: TextStyle(fontSize: 18),
                            minLines: 10,
                            maxLength: 1000,
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              counterText: '',
                              // contentPadding: EdgeInsets.all(50),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide: new BorderSide(
                                    color: Colors.teal, width: 8),
                              ),
                              hintText: '',
                            ),
                            textFieldType: TextFieldType.ADDRESS,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                print('Tap found on submit button with rating $value');
                Fluttertoast.showToast(msg: 'Thanks for your Feedback');
                Navigator.pop(context);
              },
              child: Container(
                color: ConstantsVar.appColor,
                padding: EdgeInsets.all(18),
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text(
                  'SUBMIT',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget feedbackBanner(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.all(13.0),
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('MyAssets/top-background.png'),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
            alignment: Alignment.center,
            child: InkWell(
              radius: 48,
              onTap: () {
                print('Tap found on back button');
              },
              child: Icon(
                Icons.navigate_before,
                size: 48,
                color: Colors.white,
              ),
            )),
        Expanded(
          child: Text(
            'FEEDBACK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

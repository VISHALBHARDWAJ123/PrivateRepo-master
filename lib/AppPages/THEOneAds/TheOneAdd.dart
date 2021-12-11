import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:play_kit/play_kit.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

class AdsDialog extends StatefulWidget {
  const AdsDialog({
    Key? key,
    required this.responseHtml,
  }) : super(key: key);
  final String responseHtml;

  @override
  _AdsDialogState createState() => _AdsDialogState();
}

class _AdsDialogState extends State<AdsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(vertical: 50, horizontal: 5),
      child: Container(
        color: Colors.transparent,
        width: 100.w,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 2.h,
              ),
              child: Card(
                elevation:2,
                child: HtmlWidget(
                  widget.responseHtml.replaceAll('\\', ''),
                ),
              ),
            ),
            Positioned(
              top: 1,
              right: .01,
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  child: InkWell(
                    child: Icon(
                      Icons.close,
                      color: ConstantsVar.appColor,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

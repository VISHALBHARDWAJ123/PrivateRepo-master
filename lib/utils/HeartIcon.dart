import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeartIcon {
  HeartIcon._();

  static const _kFontFamYoutube = 'Youtube';

  // static const String? _kFontPkg = null;

  static const _kFontFam = 'HeartIcon';
  static const _kFontFamheart = 'MyHeartIcon';
  static const _kFontFam_Facebook = 'Facebook';
  static const _kFontFamlog = 'MyFlutterApp';
  static const _kFontFamRemove = 'Remove';
  static const String? _kFontPkg = null;
  static const _kFontFamAddress = 'Address';
  static const _kFontFamOrder = 'Orders';
  static const _kFontFamChangePassword = 'ChangePassword';
  static const _kFontFamSearch = 'SearchFilter';

  static const IconData password = IconData(0xe800, fontFamily: _kFontFamChangePassword, fontPackage: _kFontPkg);
  static const IconData order =
      IconData(0xe800, fontFamily: _kFontFamOrder, fontPackage: _kFontPkg);
  static const IconData address =
      IconData(0xe800, fontFamily: _kFontFamAddress, fontPackage: _kFontPkg);
  static const _kFontFamArrow = 'Forward_arrow';
  static const IconData right_arrow =
      IconData(0xe800, fontFamily: _kFontFamArrow, fontPackage: _kFontPkg);
  static const IconData youtube =
      IconData(0xf167, fontFamily: _kFontFamYoutube, fontPackage: _kFontPkg);

  static const IconData user =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData heart =
      IconData(0xe801, fontFamily: _kFontFamheart, fontPackage: _kFontPkg);
  static const IconData logout =
      IconData(0xe802, fontFamily: _kFontFamlog, fontPackage: _kFontPkg);

  static const IconData facebook =
      IconData(0xe800, fontFamily: _kFontFam_Facebook);
  static const IconData instagram =
      IconData(0xe801, fontFamily: _kFontFam_Facebook);
  static const IconData pinterest =
      IconData(0xe802, fontFamily: _kFontFam_Facebook);

  static const IconData cross =
      IconData(0xe870, fontFamily: _kFontFamRemove, fontPackage: _kFontPkg);

  static const IconData searchFilter = IconData(0xf1de, fontFamily: _kFontFamSearch, );
}

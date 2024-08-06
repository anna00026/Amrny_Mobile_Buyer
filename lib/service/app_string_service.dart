import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/view/utils/app_strings_en.dart';
import 'package:qixer/view/utils/app_strings_ar.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStringService with ChangeNotifier {
  bool isloading = false;

  Map tStrings = {};

  var languageDropdownList = ['English', 'Arabic'];
  var localeList = ['en', 'ar'];
  var currentLanguage = 'English';

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  fetchTranslatedStrings(BuildContext context, {bool doNotLoad = false}) async {
    //if already loaded. no need to load again
    // var connection = await checkConnection();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (doNotLoad) {
      final strings = prefs.getString('translated_string');
      tStrings = jsonDecode(strings ?? 'null');
      return;
    }
    tStrings = currentLanguage == 'English' ? appStringsEn : appStringsAr;
    // if (connection) {

    //   // setLoadingTrue();

    //   // var data = jsonEncode({
    //   //   "strings": jsonEncode(currentLanguage == 'English' ? appStrings : appStringsAr),
    //   // });

    //   // var header = {
    //   //   //if header type is application/json then the data should be in jsonEncode method
    //   //   // "Accept": "application/json",
    //   //   "Content-Type": "application/json",
    //   //   // "Authorization": "Bearer $token",
    //   // };

    //   // log(jsonEncode(currentLanguage == 'English' ? appStrings : appStringsAr).toString());
    //   // var response = await http.post(Uri.parse('$baseApi/translate-string'),
    //   //     headers: header, body: data);

    //   // try {
    //   //   if (response.statusCode == 201) {
    //   //     debugPrint(response.body.toString());
    //   //     tStrings = jsonDecode(response.body)['strings'];
    //   //     prefs.setString('translated_string', jsonEncode(tStrings));
    //   //     notifyListeners();
    //   //   } else {
    //   //     print('error fetching translations ${response.body}');
    //   //   }
    //   // } catch (e) {
    //   //   debugPrint(e.toString());
    //   // }
    // }
  }

  getString(String staticString) {
    try {
      if (tStrings.containsKey(staticString)) {
        return tStrings[staticString];
      } else {
        return staticString;
      }
    } catch (e) {
      debugPrint(e.toString());
      return staticString;
    }
  }

  loadInitialLanguage(BuildContext context) async {
    await getCurrentLangauge();
    String locale = currentLanguage == 'English' ? 'en' : 'ar';
    String direction = currentLanguage == 'English' ? 'ltr' : 'rtl';
    fetchTranslatedStrings(context);
    await Provider.of<RtlService>(context, listen: false)
        .changeDirection(direction, locale);
  }

  getCurrentLangauge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLanguage = prefs.getString('language') ?? 'English';
    notifyListeners();
  }

  setCurrentLangauge(BuildContext context, String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLanguage = language.isEmpty ? 'English' : language;
    prefs.setString('language', currentLanguage);
    String locale = currentLanguage == 'English' ? 'en' : 'ar';
    String direction = currentLanguage == 'English' ? 'ltr' : 'rtl';
    fetchTranslatedStrings(context);
    await Provider.of<RtlService>(context, listen: false)
        .changeDirection(direction, locale);
    notifyListeners();
  }
}

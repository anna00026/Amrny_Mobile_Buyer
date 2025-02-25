import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amrny/helper/extension/string_extension.dart';
import 'package:amrny/service/auth_services/signup_service.dart';
import 'package:amrny/service/common_service.dart';
import 'package:amrny/view/utils/constant_colors.dart';
import 'package:amrny/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassService with ChangeNotifier {
  bool isloading = false;

  String? otpNumber;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  changePassword(
      currentPass, newPass, repeatNewPass, BuildContext context) async {
    if (newPass != repeatNewPass) {
      OthersHelper().showToast(
          'Make sure you repeated new password correctly', Colors.black);
      return;
    }

    //check internet connection
    var connection = await checkConnection();
    if (connection) {
      setLoadingTrue();
      if (baseApi.toLowerCase().contains("amrny.com")) {
        await Future.delayed(const Duration(seconds: 2));
        "This feature is turned off for demo app".showToast();
        setLoadingFalse();
        return;
      }
      //internet connection is on
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      var data = {'current_password': currentPass, 'new_password': newPass};

      setLoadingTrue();
      if (baseApi == 'https://amrny.com/api/v1') {
        await Future.delayed(const Duration(seconds: 1));
        OthersHelper()
            .showToast('This feature is turned off in test mode', Colors.black);
        setLoadingFalse();
        return;
      }
      var response = await http.post(Uri.parse('$baseApi/user/change-password'),
          headers: header, body: data);

      if (response.statusCode == 201) {
        OthersHelper().showToast("Password changed successfully", Colors.black);
        setLoadingFalse();

        // LoginService().saveDetails(email ?? '', newPass, token ?? '');

        Navigator.pop(context);
      } else {
        print(response.body);
        try {
          SignupService().showError(jsonDecode(response.body)['error']);
        } catch (e) {
          OthersHelper().showToast(jsonDecode(response.body)['message'],
              ConstantColors().warningColor);
        }
        setLoadingFalse();
      }
    }
  }
}

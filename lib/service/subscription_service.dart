import 'dart:convert';

import 'package:amrny/model/subscription_info_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:amrny/model/my_orders_list_model.dart';
import 'package:amrny/service/common_service.dart';
import 'package:amrny/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService with ChangeNotifier {
  SubscriptionInfoModel? subscription;

  bool isLoading = false;
  bool isLoadingNextPage = false;

  setLoadingTrue() {
    isLoading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isLoading = false;
    notifyListeners();
  }

  fetchSubscription() async {
    //get user id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var connection = await checkConnection();
    if (connection) {
      setLoadingTrue();
      print(token);
      print('$baseApi/user/buyer/subscription');
      //if connection is ok
      var response = await http
          .get(Uri.parse('$baseApi/user/buyer/subscription'), headers: header);

      if (response.statusCode == 201 &&
          jsonDecode(response.body)['subscription'].isNotEmpty) {
        print(response.body);
        subscription = SubscriptionInfoModel.fromJson(jsonDecode(response.body));
        print(subscription);
        
        isLoading = false;
        notifyListeners();
        setLoadingFalse();
      } else {
        print(response.body);
        //Something went wrong
        isLoading = false;
        notifyListeners();
        setLoadingFalse();
      }
    }
  }

}

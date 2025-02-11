import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:amrny/service/book_confirmation_service.dart';
import 'package:amrny/service/common_service.dart';
import 'package:amrny/view/utils/others_helper.dart';

class CouponService with ChangeNotifier {
  double couponDiscount = 0;

  var appliedCoupon;

  bool isloading = false;

  bool isFetchedCoupon = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  setCouponDefault() {
    couponDiscount = 0;
    appliedCoupon = '';
    notifyListeners();
  }

  setIsFetchedCoupon(bool val) {
    isFetchedCoupon = val;
    notifyListeners();
  }


  Future<bool> getCouponDiscount(
      couponCode, totalAmount, sellerId, BuildContext context) async {
    var connection = await checkConnection();
    setIsFetchedCoupon(false);
    if (connection) {
      if (couponCode == appliedCoupon) {
        OthersHelper()
            .showToast('You already applied this coupon', Colors.black);
        return false;
      }
      setLoadingTrue();
      var data = jsonEncode({
        'coupon_code': couponCode,
        'total_amount': totalAmount,
        'seller_id': sellerId
      });
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json"
      };

      var response = await http.post(
          Uri.parse('$baseApi/service-list/coupon-apply'),
          body: data,
          headers: header);

      if (response.statusCode == 201) {
        couponDiscount = jsonDecode(response.body)['coupon_amount'];
        appliedCoupon = couponCode;
        print('coupon amount is $couponDiscount');
        setIsFetchedCoupon(true);
        Provider.of<BookConfirmationService>(context, listen: false)
            .caculateTotalAfterCouponApplied(couponDiscount);

        setLoadingFalse();
        notifyListeners();
        return true;
      } else {
        //something went wrong
        print(response.body);
        setLoadingFalse();
        OthersHelper().showToast('Please enter a valid coupon', Colors.black);
        return false;
      }
    } else {
      //internet off
      return false;
    }
  }
}

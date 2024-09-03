import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/booking_services/coupon_service.dart';
import 'package:amrny/service/booking_services/personalization_service.dart';

class BookConfirmationService with ChangeNotifier {
  bool isPanelOpened = false;

  double totalPriceAfterAllcalculation = 0.0;
  var subTotalAfterAllCalculation = 0.0;
  double totalPriceOnlineServiceAfterAllCalculation = 0.0;
  var subTotalOnlineServiceAfterAllCalculation = 0.0;

  var taxPrice;
  var taxPriceOnline;
  var taxPercentage;

  setTotalOnlineService(v) {
    totalPriceOnlineServiceAfterAllCalculation = v;
    notifyListeners();
  }

  setTotalOfflineService(v) {
    totalPriceAfterAllcalculation = v;
    notifyListeners();
  }

  setPanelOpenedTrue() {
    isPanelOpened = true;
    notifyListeners();
  }

  setPanelOpenedFalse() {
    isPanelOpened = false;
    notifyListeners();
  }

  includedTotalPrice(List includedList) {
    var total = 0.0;
    for (int i = 0; i < includedList.length; i++) {
      total = total + (includedList[i]['price'] * includedList[i]['qty']);
    }
    return total;
  }

  extrasTotalPrice(List extrasList) {
    var total = 0.0;
    for (int i = 0; i < extrasList.length; i++) {
      if (extrasList[i]['selected'] == true) {
        total = total + (extrasList[i]['price'] * extrasList[i]['qty']);
      }
    }
    return total;
  }

  calculateSubtotal(List includedList, List extrasList) {
    var includedTotal = 0.0;
    var extraTotal = 0.0;
    includedTotal = includedTotalPrice(includedList);
    extraTotal = extrasTotalPrice(extrasList);
    subTotalAfterAllCalculation = includedTotal + extraTotal;

    return subTotalAfterAllCalculation;
  }

  calculateSubtotalForOnline(List extrasList) {
    var extraTotal = 0.0;

    extraTotal = extrasTotalPrice(extrasList);
    subTotalOnlineServiceAfterAllCalculation = extraTotal;
    return extraTotal;
  }

  calculateTax(
    taxPercent,
    List includedList,
    List extrasList,
    discount
  ) {
    taxPercentage = taxPercent;
    var subTotal = calculateSubtotal(includedList, extrasList);
    subTotal = subTotal - discount;
    taxPrice = (subTotal * (taxPercent / (100 + taxPercent)) ?? 0);

    return taxPrice;
  }

  calculateTotal(context, taxPercent, List includedList, List extrasList) {
    taxPercentage = taxPercent;
    var subTotal = calculateSubtotal(includedList, extrasList);
    var discount = Provider.of<CouponService>(context, listen: false).couponDiscount;
    subTotal = subTotal - discount;
    var tax = calculateTax(taxPercent, includedList, extrasList, discount);

    totalPriceAfterAllcalculation = subTotal - tax;
    Future.delayed(const Duration(microseconds: 500), () {
      notifyListeners();
    });
  }

  calculateTotalOnlineService(
      taxPercent, List includedList, List extrasList, BuildContext context) {
    taxPercentage = taxPercent;
    var subTotal = calculateSubtotal(includedList, extrasList);
    var discount = Provider.of<CouponService>(context, listen: false).couponDiscount;
    subTotal = subTotal - discount;
    var tax = calculateTax(taxPercent, includedList, extrasList, discount);
    totalPriceOnlineServiceAfterAllCalculation = subTotal -
        tax +
        Provider.of<PersonalizationService>(context, listen: false)
            .defaultprice;
    Future.delayed(const Duration(microseconds: 500), () {
      notifyListeners();
    });
  }

  caculateTotalAfterCouponApplied(couponDiscount) {
    totalPriceAfterAllcalculation = subTotalAfterAllCalculation - couponDiscount;
    taxPrice = subTotalAfterAllCalculation * (taxPercentage / (100 * taxPercentage));
    totalPriceAfterAllcalculation =
        subTotalAfterAllCalculation - taxPrice;
    totalPriceOnlineServiceAfterAllCalculation =
        totalPriceOnlineServiceAfterAllCalculation - couponDiscount;
    notifyListeners();
  }
}

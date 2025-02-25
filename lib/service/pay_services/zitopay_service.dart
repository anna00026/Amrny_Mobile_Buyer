// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/book_confirmation_service.dart';
import 'package:amrny/service/booking_services/personalization_service.dart';
import 'package:amrny/service/booking_services/place_order_service.dart';
import 'package:amrny/service/jobs_service/job_request_service.dart';
import 'package:amrny/service/order_details_service.dart';
import 'package:amrny/service/payment_gateway_list_service.dart';
import 'package:amrny/service/wallet_service.dart';
import 'package:amrny/view/payments/zitopay_payment_page.dart';

class ZitopayService {
  payByZitopay(BuildContext context,
      {bool isFromOrderExtraAccept = false,
      bool isFromWalletDeposite = false,
      bool isFromHireJob = false}) {
    //========>
    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    var amount;

    if (isFromOrderExtraAccept == true) {
      amount = Provider.of<OrderDetailsService>(context, listen: false)
          .selectedExtraPrice;
    } else if (isFromWalletDeposite) {
      amount = Provider.of<WalletService>(context, listen: false).amountToAdd;
    } else if (isFromHireJob) {
      amount = Provider.of<JobRequestService>(context, listen: false)
          .selectedJobPrice;
    } else {
      var bcProvider =
          Provider.of<BookConfirmationService>(context, listen: false);
      var pProvider =
          Provider.of<PersonalizationService>(context, listen: false);

      if (pProvider.isOnline == 0) {
        amount = bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(2);
      } else {
        amount = bcProvider.totalPriceOnlineServiceAfterAllCalculation
            .toStringAsFixed(2);
      }
    }
    var userName =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .zitopayUserName;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ZitopayPaymentPage(
          amount: amount,
          userName: userName,
          isFromOrderExtraAccept: isFromOrderExtraAccept,
          isFromWalletDeposite: isFromWalletDeposite,
          isFromHireJob: isFromHireJob,
        ),
      ),
    );
  }
}

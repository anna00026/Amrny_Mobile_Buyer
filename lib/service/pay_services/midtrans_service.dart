// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/book_confirmation_service.dart';
import 'package:amrny/service/booking_services/book_service.dart';
import 'package:amrny/service/booking_services/personalization_service.dart';
import 'package:amrny/service/booking_services/place_order_service.dart';
import 'package:amrny/service/jobs_service/job_request_service.dart';
import 'package:amrny/service/order_details_service.dart';
import 'package:amrny/service/profile_service.dart';
import 'package:amrny/service/wallet_service.dart';
import 'package:amrny/view/payments/midtrans_payment.dart';

class MidtransService {
  payByMidtrans(BuildContext context,
      {bool isFromOrderExtraAccept = false,
      bool isFromWalletDeposite = false,
      bool isFromHireJob = false}) {
    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    var amount;
    String name;
    String phone;
    String email;

    name = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .name ??
        'test';
    phone = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .phone ??
        '111111111';
    email = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .email ??
        'test@test.com';
    if (isFromOrderExtraAccept == true) {
      Provider.of<PlaceOrderService>(context, listen: false).setLoadingTrue();

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
      var bookProvider = Provider.of<BookService>(context, listen: false);

      name = bookProvider.name ?? '';
      phone = bookProvider.phone ?? '';
      email = bookProvider.email ?? '';

      if (pProvider.isOnline == 0) {
        amount = bcProvider.totalPriceAfterAllcalculation.round().toString();
      } else {
        amount = bcProvider.totalPriceOnlineServiceAfterAllCalculation
            .toStringAsFixed(2);
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MidtransPayment(
          amount: amount,
          name: name,
          phone: phone,
          email: email,
          isFromOrderExtraAccept: isFromOrderExtraAccept,
          isFromWalletDeposite: isFromOrderExtraAccept,
          isFromHireJob: isFromHireJob,
        ),
      ),
    );
  }
}

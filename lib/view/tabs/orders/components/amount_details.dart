import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny/helper/extension/string_extension.dart';
import 'package:amrny/service/app_string_service.dart';
import 'package:amrny/service/book_confirmation_service.dart';
import 'package:amrny/service/booking_services/book_service.dart';
import 'package:amrny/service/booking_services/personalization_service.dart';
import 'package:amrny/service/booking_services/place_order_service.dart';
import 'package:amrny/service/common_service.dart';
import 'package:amrny/service/order_details_service.dart';
import 'package:amrny/view/booking/booking_helper.dart';
import 'package:amrny/view/booking/payment_choose_page.dart';
import 'package:amrny/view/utils/common_helper.dart';
import 'package:amrny/view/utils/responsive.dart';

class AmountDetails extends StatelessWidget {
  const AmountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, asProvider, child) => Consumer<OrderDetailsService>(
        builder: (context, provider, child) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(9)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonHelper()
                        .titleCommon(asProvider.getString('Amount Details')),
                    const SizedBox(
                      height: 25,
                    ),
                    //Service row

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Package fee'),
                          provider.orderDetails.packageFee.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Extra Service'),
                          provider.orderDetails.extraService.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString(provider.orderDetails.couponCode == 'subscription' ? 'Discount' : 'Coupon'),
                          provider.orderDetails.couponAmount.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Sub total'),
                          provider.orderDetails.subTotal.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Tax'),
                          provider.orderDetails.tax.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Total'),
                          provider.orderDetails.total.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                        'null',
                        asProvider.getString('Payment status'),
                        asProvider
                            .getString(provider.orderDetails.paymentStatus),
                      ),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Payment method'),
                          removeUnderscore(
                              provider.orderDetails.paymentGateway),
                          lastBorder: false),
                    ),

                    if (provider.orderDetails.paymentStatus == 'pending' &&
                        provider.orderDetails.paymentGateway !=
                            "cash_on_delivery" &&
                        provider.orderDetails.paymentGateway !=
                            "manual_payment")
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: CommonHelper()
                            .buttonOrange(lnProvider.getString('Pay now'), () {
                          //At first, set the address details
                          Provider.of<BookService>(context, listen: false)
                              .setDeliveryDetailsBasedOnProfile(context);

                          //set if online or offline
                          var isOnline = provider.orderDetails.isOrderOnline;
                          Provider.of<PersonalizationService>(context,
                                  listen: false)
                              .setOnlineOffline(isOnline);

                          //set total amount
                          var total = double.parse(provider.orderDetails.total
                              .toString()
                              .tryToParse
                              .toString());

                          if (isOnline == 1) {
                            Provider.of<BookConfirmationService>(context,
                                    listen: false)
                                .setTotalOnlineService(total);
                          } else {
                            Provider.of<BookConfirmationService>(context,
                                    listen: false)
                                .setTotalOfflineService(total);
                          }

                          // set order id
                          Provider.of<PlaceOrderService>(context, listen: false)
                              .setOrderId(provider.orderDetails.id);
                          //

                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const PaymentChoosePage(
                                payAgain: true,
                              ),
                            ),
                          );
                        }, paddingVerticle: 16),
                      )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:amrny/service/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/book_confirmation_service.dart';
import 'package:amrny/service/booking_services/book_service.dart';
import 'package:amrny/service/booking_services/coupon_service.dart';
import 'package:amrny/service/booking_services/personalization_service.dart';
import 'package:amrny/view/booking/booking_helper.dart';
import 'package:amrny/view/booking/payment_choose_page.dart';
import 'package:amrny/view/utils/common_helper.dart';
import 'package:amrny/view/utils/constant_styles.dart';
import 'package:amrny/view/utils/responsive.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../utils/constant_colors.dart';

class OrderDetailsPanel extends StatefulWidget {
  const OrderDetailsPanel({super.key, this.onTapTopHeader});
  final VoidCallback? onTapTopHeader;

  @override
  State<OrderDetailsPanel> createState() => _OrderDetailsPanelState();
}

class _OrderDetailsPanelState extends State<OrderDetailsPanel>
    with TickerProviderStateMixin {
  ConstantColors cc = ConstantColors();
  FocusNode couponFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  TextEditingController couponController = TextEditingController();

  bool loadingFirstTime = true;

  Widget _getTopTitleWidget(BookConfirmationService bcProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 17, bottom: 6),
      child: InkWell(
        onTap: widget.onTapTopHeader,
        child: Column(
          children: [
            bcProvider.isPanelOpened == false
                ? Text(
                    lnProvider.getString('Swipe up for details'),
                    style: TextStyle(
                      color: cc.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : Text(
                    lnProvider.getString('Collapse details'),
                    style: TextStyle(
                      color: cc.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
            bcProvider.isPanelOpened == false
                ? Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: cc.primaryColor,
                  )
                : Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: cc.primaryColor,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _getAppointmentPackageWidget(
      BookConfirmationService bcProvider, PersonalizationService psProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonHelper()
            .labelCommon(lnProvider.getString('Appointment package service')),
        const SizedBox(
          height: 5,
        ),

        //Service included list =============>
        for (int i = 0; i < psProvider.includedList.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: BookingHelper().detailsPanelRow(
                psProvider.includedList[i]['title'],
                psProvider.includedList[i]['qty'],
                psProvider.includedList[i]['price'].toString()),
          ),

        Container(
          margin: const EdgeInsets.only(top: 3, bottom: 15),
          child: CommonHelper().dividerCommon(),
        ),
        //Package fee
        BookingHelper().detailsPanelRow('Package Fee', 0,
            bcProvider.includedTotalPrice(psProvider.includedList).toString()),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget _getDiscountWidget(
      BookConfirmationService bcProvider,
      SubscriptionService subsProvider,
      CouponService couponService,
      PersonalizationService pProvider) {
    if (subsProvider.subscription != null) {
      bcProvider.discount = bcProvider.calculateSubscriptionDiscount(
          pProvider.includedList,
          pProvider.extrasList,
          subsProvider.subscription!.subscriptionInfo.discount ?? 0);
      return BookingHelper().detailsPanelRow(
          'Subscription', 0, bcProvider.discount.toStringAsFixed(2),
          isDeductValue: true);
    } else if (couponService.isFetchedCoupon) {
      //Coupon ===>
      bcProvider.discount = couponService.couponDiscount;
      return BookingHelper().detailsPanelRow(
          'Coupon', 0, couponService.couponDiscount.toStringAsFixed(2),
          isDeductValue: true);
    } else {
      return Container();
    }
  }

  Widget _getServiceListWidget(BookConfirmationService bcProvider,
      SubscriptionService subsProvider, CouponService couponService) {
    return Consumer<PersonalizationService>(
      builder: (context, pProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // icludes list ======>
          pProvider.isOnline == 0
              ? _getAppointmentPackageWidget(bcProvider, pProvider)
              : Container(),

          //Extra service =============>

          CommonHelper().labelCommon(lnProvider.getString('Extra service')),
          const SizedBox(
            height: 5,
          ),
          for (int i = 0; i < pProvider.extrasList.length; i++)
            pProvider.extrasList[i]['selected'] == true
                ? Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: BookingHelper().detailsPanelRow(
                        pProvider.extrasList[i]['title'],
                        pProvider.extrasList[i]['qty'],
                        pProvider.extrasList[i]['price'].toString()),
                  )
                : Container(),

          //==================>
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 15),
            child: CommonHelper().dividerCommon(),
          ),

          //total of extras
          BookingHelper().detailsPanelRow('Extra Service Fee', 0,
              bcProvider.extrasTotalPrice(pProvider.extrasList).toString()),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            child: CommonHelper().dividerCommon(),
          ),

          //Discount
          _getDiscountWidget(
              bcProvider, subsProvider, couponService, pProvider),

          if (couponService.isFetchedCoupon ||
              subsProvider.subscription != null)
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 12),
              child: CommonHelper().dividerCommon(),
            ),

          //Sub total and tax ============>
          //Sub total
          pProvider.isOnline == 0
              ? Column(
                  children: [
                    BookingHelper().detailsPanelRow(
                        'Subtotal',
                        0,
                        bcProvider
                            .calculateSubtotal(
                                pProvider.includedList, pProvider.extrasList)
                            .toStringAsFixed(2)),
                  ],
                )
              : Container(),

          if (pProvider.isOnline == 0)
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              child: CommonHelper().dividerCommon(),
            ),
          //tax
          BookingHelper().detailsPanelRow(
              lnProvider.getString('Tax') + '(+) ${pProvider.tax}%',
              0,
              bcProvider
                  .calculateTax(pProvider.tax, pProvider.includedList,
                      pProvider.extrasList)
                  .toStringAsFixed(2)),

          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 12),
            child: CommonHelper().dividerCommon(),
          ),
        ],
      ),
    );
  }

  Widget _getCouponCodeWidget(
      BookConfirmationService bcProvider, CouponService couponProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBox20(),
        CommonHelper().labelCommon("Coupon code"),
        Row(
          children: [
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      // color: const Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: couponController,
                    style: const TextStyle(fontSize: 14),
                    focusNode: couponFocus,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ConstantColors().greyFive),
                            borderRadius: BorderRadius.circular(7)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ConstantColors().primaryColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ConstantColors().warningColor)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ConstantColors().primaryColor)),
                        hintText: lnProvider.getString('Enter coupon code'),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 18)),
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              width: 100,
              child: CommonHelper().buttonOrange(lnProvider.getString('Apply'),
                  () {
                if (couponController.text.isNotEmpty) {
                  if (couponProvider.isloading == false) {
                    // couponController.clear();
                    couponProvider.getCouponDiscount(
                        couponController.text,
                        //total amount
                        bcProvider.basePrice,
                        //seller id
                        Provider.of<BookService>(context, listen: false)
                            .sellerId,
                        //context
                        context);
                  }
                }
              }, isloading: couponProvider.isloading == false ? false : true),
            )
          ],
        ),
      ],
    );
  }

  Widget _getOrderDetailWidget(
      BookConfirmationService bcProvider, SubscriptionService subsProvider) {
    return Expanded(
      child: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: SingleChildScrollView(
          physics: physicsCommon,
          controller: _scrollController,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: CommonHelper().dividerCommon(),
                  ),

                  //service list ===================>
                  bcProvider.isPanelOpened == true
                      ? Consumer<CouponService>(
                          builder: (context, couponService, child) =>
                              _getServiceListWidget(
                                  bcProvider, subsProvider, couponService))
                      : Container(),

                  //total ===>

                  Consumer<PersonalizationService>(
                    builder: (context, pProvider, child) => BookingHelper()
                        .detailsPanelRow(
                            'Total',
                            0,
                            pProvider.isOnline == 0
                                ? bcProvider
                                    .calculateSubtotal(pProvider.includedList,
                                        pProvider.extrasList)
                                    .toStringAsFixed(2)
                                : bcProvider
                                    .calculateSubtotalForOnline(
                                        pProvider.extrasList)
                                    .toStringAsFixed(2)),
                  ),

                  if (bcProvider.isPanelOpened == true &&
                      subsProvider.subscription == null)
                    Consumer<CouponService>(
                      builder: (context, couponProvider, child) =>
                          _getCouponCodeWidget(bcProvider, couponProvider),
                    ),

                  //Buttons
                  const SizedBox(
                    height: 20,
                  ),
                  //TODO uncomment this to make the panel work again
                  Row(
                    children: [
                      // widget.panelController.isPanelClosed
                      //     ? Expanded(
                      //         child: CommonHelper().borderButtonOrange(
                      //             'Apply coupon', () {
                      //           widget.panelController.open();
                      //           couponFocus.requestFocus();
                      //           Future.delayed(
                      //               const Duration(milliseconds: 900),
                      //               () {
                      //             _scrollController.animateTo(
                      //               355,
                      //               duration: const Duration(
                      //                   milliseconds: 600),
                      //               curve: Curves.fastOutSlowIn,
                      //             );
                      //           });
                      //         }),
                      //       )
                      //     : Container(),
                      // widget.panelController.isPanelClosed
                      //     ? const SizedBox(
                      //         width: 20,
                      //       )
                      //     : Container(),
                      Expanded(
                        child: CommonHelper().buttonOrange(
                            lnProvider.getString('Proceed to payment'), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const PaymentChoosePage(),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 105,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    PersonalizationService psProvider =
        Provider.of<PersonalizationService>(context, listen: false);
    BookConfirmationService bcProvider =
        Provider.of<BookConfirmationService>(context, listen: false);
    Provider.of<CouponService>(context, listen: false).isFetchedCoupon = false;
    Provider.of<CouponService>(context, listen: false).couponDiscount = 0;
    Provider.of<CouponService>(context, listen: false).appliedCoupon = "";
    
    bcProvider.calculateBasePrice(
        psProvider.includedList, psProvider.extrasList);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionService>(
      builder: (context, subsProvider, child) =>
          Consumer<BookConfirmationService>(
        builder: (context, bcProvider, child) {
          return Column(
            children: [
              _getTopTitleWidget(bcProvider),
              _getOrderDetailWidget(bcProvider, subsProvider)
            ],
          );
        },
      ),
    );
  }
}

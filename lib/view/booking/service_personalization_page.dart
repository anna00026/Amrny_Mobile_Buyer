import 'package:amrny/service/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/app_string_service.dart';
import 'package:amrny/service/booking_services/book_service.dart';
import 'package:amrny/service/booking_services/personalization_service.dart';
import 'package:amrny/service/booking_services/shedule_service.dart';
import 'package:amrny/service/common_service.dart';
import 'package:amrny/view/booking/components/extras.dart';
import 'package:amrny/view/booking/components/task_options.dart';
import 'package:amrny/view/booking/delivery_address_page.dart.dart';
import 'package:amrny/view/booking/service_schedule_page.dart';
import 'package:amrny/view/utils/common_helper.dart';
import 'package:amrny/view/utils/constant_colors.dart';
import 'package:amrny/view/utils/constant_styles.dart';
import 'package:amrny/view/utils/others_helper.dart';
import 'package:amrny/view/utils/responsive.dart';

import '../../service/book_steps_service.dart';
import 'booking_helper.dart';
import 'components/included.dart';
import 'components/steps.dart';

class ServicePersonalizationPage extends StatefulWidget {
  const ServicePersonalizationPage({
    super.key,
  });

  @override
  _ServicePersonalizationPageState createState() =>
      _ServicePersonalizationPageState();
}

class _ServicePersonalizationPageState
    extends State<ServicePersonalizationPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _getPersonalizationWidget(
      PersonalizationService provider, AppStringService asProvider) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          provider.isOnline == 0 ? Steps(cc: cc) : Container(),

          provider.serviceExtraData.service.isServiceOnline != 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonHelper().titleCommon(
                        '${asProvider.getString('What is included')}:'),
                    const SizedBox(
                      height: 20,
                    ),
                    Included(
                      cc: cc,
                      data: provider.includedList,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : Container(),

          provider.extrasList.isNotEmpty
              ? Extras(
                  cc: cc,
                  additionalServices: provider.extrasList,
                  serviceBenefits:
                      provider.serviceExtraData.service.serviceBenifit,
                  asProvider: asProvider,
                )
              : Container(),

          // button ==================>
          const SizedBox(
            height: 27,
          ),

          provider.optionsList.isNotEmpty
              ? TaskOptions(
                  cc: cc,
                  taskOptions: provider.optionsList,
                  asProvider: asProvider,
                )
              : Container(),

          // CommonHelper().buttonOrange("Next", () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute<void>(
          //       builder: (BuildContext context) =>
          //           const ServiceSchedulePage(),
          //     ),
          //   );
          // }),

          const SizedBox(
            height: 147,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return WillPopScope(
      onWillPop: () {
        // BookStepsService().decreaseStep(context);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarForBookingPages(
            lnProvider.getString('Personalize'), context,
            isPersonalizatioPage: true, extraFunction: () {
          //Whatever quanity or other extra user has selected.. set the totalprice to the default service price again
          Provider.of<BookService>(context, listen: false).setTotalPrice(
              Provider.of<PersonalizationService>(context, listen: false)
                  .defaultprice);

          //set default steps to 1 again
        }),
        body: SingleChildScrollView(
          physics: physicsCommon,
          child: Consumer<AppStringService>(
            builder: (context, asProvider, child) =>
                Consumer<PersonalizationService>(
              builder: (context, provider, child) =>
                  Consumer<SubscriptionService>(
                builder: (context, discountProvider, child) =>
                    (provider.isloading == false &&
                            discountProvider.isLoading == false)
                        ? provider.serviceExtraData != 'error'
                            ? _getPersonalizationWidget(provider, asProvider)
                            : Text(
                                asProvider.getString('Something went wrong'),
                              )
                        : Container(
                            height: MediaQuery.of(context).size.height - 250,
                            alignment: Alignment.center,
                            child: OthersHelper().showLoading(cc.primaryColor),
                          ),
              ),
            ),
          ),
        ),
        bottomSheet: Consumer<AppStringService>(
          builder: (context, asProvider, child) => Consumer<BookService>(
            builder: (context, provider, child) =>
                Consumer<PersonalizationService>(
              builder: (context, personalizationProvider, child) => Container(
                height: 162,
                padding: EdgeInsets.only(
                    left: screenPadding, top: 30, right: screenPadding),
                decoration: BookingHelper().bottomSheetDecoration(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookingHelper().detailsPanelRow(
                          asProvider.getString('Total'),
                          0,
                          '${provider.totalPrice}'),
                      const SizedBox(
                        height: 23,
                      ),
                      CommonHelper().buttonOrange(asProvider.getString('Next'),
                          () {
                        if (personalizationProvider.isloading == false) {
                          if (personalizationProvider.isOnline == 1) {
                            //if it is an online service no need to show service schedule and choose location page

                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: const DeliveryAddressPage()));
                            BookStepsService().onNext(context);
                          } else {
                            //increase page steps by one
                            BookStepsService().onNext(context);
                            //fetch shedule
                            Provider.of<SheduleService>(context, listen: false)
                                .fetchShedule(provider.sellerId,
                                    firstThreeLetter(DateTime.now(), null));

                            //go to shedule page
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: const ServiceSchedulePage()));
                          }
                        }
                      }),
                      const SizedBox(
                        height: 24,
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

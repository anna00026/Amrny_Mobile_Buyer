import 'package:amrny/service/common_service.dart';
import 'package:amrny/service/subscription_service.dart';
import 'package:amrny/view/booking/booking_helper.dart';
import 'package:amrny/view/utils/others_helper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny/view/utils/common_helper.dart';
import 'package:amrny/view/utils/constant_colors.dart';
import 'package:amrny/view/utils/constant_styles.dart';
import 'package:amrny/view/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDiscountPage extends StatefulWidget {
  const ServiceDiscountPage({super.key});

  @override
  ServiceDiscountPageState createState() => ServiceDiscountPageState();
}

class ServiceDiscountPageState extends State<ServiceDiscountPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<SubscriptionService>(context, listen: false).isLoading = true;
    Provider.of<SubscriptionService>(context, listen: false)
        .fetchSubscription();
  }

  ConstantColors cc = ConstantColors();

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget getNonSubscriptionPage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenPadding, vertical: 10),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height - 120,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: lnProvider.getString('To get discount click '),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            TextSpan(
              text: lnProvider.getString('here'),
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL('https://amrny.com/buyer/subscription-buyer');
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget getDetailItem(String title, String text, {bool lastBorder = true}) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 150,
              child: Row(children: [
                SizedBox(
                  width: 135,
                  child: AutoSizeText(
                    title,
                    maxLines: 2,
                    style: TextStyle(
                      color: cc.greyFour,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ]),
            ),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: cc.greyFour,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
        lastBorder == true
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                child: CommonHelper().dividerCommon(),
              )
            : Container()
      ],
    );
  }

  Widget getDetailPage(SubscriptionService provider) {
    if (provider.subscription == null) {
      return getNonSubscriptionPage();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenPadding, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHelper().titleCommon(lnProvider.getString('Active Discounts')),
          const SizedBox(height: 25),
          Container(
            child: getDetailItem(lnProvider.getString('Rate of Discount'),
                '${provider.subscription!.subscriptionInfo.discount.toString()}%'),
          ),
          const SizedBox(height: 10),
          Container(
            child: getDetailItem(lnProvider.getString('Available Till'),
                formatDate(provider.subscription!.subscriptionInfo.expireDate)),
          ),
          const SizedBox(height: 25),
          CommonHelper().titleCommon(lnProvider.getString('Payment Details')),
          const SizedBox(height: 25),
          Container(
            child: getDetailItem(lnProvider.getString('Payment Gateway'),
                '${removeUnderscore(provider.subscription!.subscriptionInfo.paymentGateway ?? "---")}'),
          ),
          const SizedBox(height: 10),
          Container(
            child: getDetailItem(lnProvider.getString('Payment Status'),
                provider.subscription!.subscriptionInfo.paymentStatus ?? ''),
          ),
        ],
      ),
    );
  }

  Widget getTotalPage(SubscriptionService provider) {
    if (provider.isLoading) {
      return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height - 120,
        child: OthersHelper().showLoading(cc.primaryColor),
      );
    } else {
      return getDetailPage(provider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonHelper().appbarCommon('Service Discount Status', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: cc.bgColor,
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<SubscriptionService>(
          builder: (context, provider, child) => getTotalPage(provider),
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/rtl_service.dart';
import 'package:amrny/view/utils/constant_colors.dart';
import 'package:amrny/view/utils/responsive.dart';

import '../utils/common_helper.dart';

class BookingHelper {
  ConstantColors cc = ConstantColors();

  bottomSheetDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 8,
          blurRadius: 17,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
    );
  }

  rowLeftRight(String iconLink, String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //icon
        Row(children: [
          SvgPicture.asset(
            iconLink,
            height: 19,
          ),
          const SizedBox(
            width: 7,
          ),
          Text(
            title,
            style: TextStyle(
              color: cc.greyFour,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          )
        ]),

        Text(
          text,
          style: TextStyle(
            color: cc.greyFour,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  bdetailsContainer(String iconLink, String title, String text) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      BookingHelper().rowLeftRight(iconLink, title, ''),
      const SizedBox(
        height: 10,
      ),
      Text(
        text,
        style: TextStyle(
          color: cc.greyFour,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      )
    ]);
  }

  bRow(String icon, String title, String text, {bool lastBorder = true}) {
    return Column(
      children: [
        Row(
          children: [
            //icon
            SizedBox(
              width: 125,
              child: Row(children: [
                icon != 'null'
                    ? Row(
                        children: [
                          SvgPicture.asset(
                            icon,
                            height: 19,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  width: 99,
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

  detailsPanelRow(String title, int quantity, String price, {isDeductValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            lnProvider.getString(title),
            style: TextStyle(
              color: cc.greyFour,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        quantity != 0
            ? Expanded(
                flex: 1,
                child: Text(
                  'x$quantity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cc.greyFour,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ))
            : Container(),
        Consumer<RtlService>(
          builder: (context, rtlP, child) => Expanded(
            flex: 1,
            child: Text(
              rtlP.currencyDirection == 'left'
                  ? "${isDeductValue ? '-' : ''}${rtlP.currency}$price"
                  : "$price${rtlP.currency}${isDeductValue ? '-' : ''}",
              textAlign:
                  rtlP.direction == 'ltr' ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                color: cc.greyFour,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }

  colorCapsule(String title, String capsuleText, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: cc.greyFour,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 11),
          decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(4)),
          child: Text(
            capsuleText,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        )
      ],
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/app_string_service.dart';
import 'package:amrny/view/utils/common_helper.dart';
import 'package:amrny/view/utils/others_helper.dart';
import 'package:amrny/view/utils/responsive.dart';

class LanguageDropdownHelper {
  //language dropdown
  languageDropdown(cc, BuildContext context) {
    Provider.of<AppStringService>(context, listen: false).getCurrentLangauge();
    return Consumer<AppStringService>(
      builder: (context, provider, child) =>
          provider.languageDropdownList.isNotEmpty
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 99,
                      child: AutoSizeText(
                        provider.getString("Language"),
                        maxLines: 2,
                        style: TextStyle(
                          color: cc.greyFour,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: cc.greyFive),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            // menuMaxHeight: 200,
                            isExpanded: true,
                            value: provider.currentLanguage,
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                color: cc.greyFour),
                            iconSize: 26,
                            elevation: 17,
                            style: TextStyle(color: cc.greyFour),
                            onChanged: (newValue) {
                              //setting the id of selected value
                              provider.setCurrentLangauge(context, newValue!);
                            },
                            items: provider.languageDropdownList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  lnProvider.getString(value),
                                  style: TextStyle(
                                      color: cc.greyPrimary.withOpacity(.8)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [OthersHelper().showLoading(cc.primaryColor)],
                ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/app_string_service.dart';
import 'package:amrny/service/common_service.dart';
import 'package:amrny/service/home_services/top_rated_services_service.dart';
import 'package:amrny/service/service_details_service.dart';
import 'package:amrny/view/home/components/section_title.dart';
import 'package:amrny/view/home/components/service_card.dart';
import 'package:amrny/view/home/top_all_service_page.dart';
import 'package:amrny/view/services/service_details_page.dart';
import 'package:amrny/view/utils/constant_colors.dart';
import 'package:amrny/view/utils/others_helper.dart';

class TopRatedServices extends StatelessWidget {
  const TopRatedServices({
    super.key,
    required this.cc,
    required this.asProvider,
  });
  final ConstantColors cc;
  final asProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, asProvider, child) =>
          Consumer<TopRatedServicesSerivce>(
        builder: (context, provider, child) => provider.topServiceMap.isNotEmpty
            ? provider.topServiceMap[0] != 'error'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      SectionTitle(
                        cc: cc,
                        title: asProvider.getString('Top booked services'),
                        pressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const TopAllServicePage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 194,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          children: [
                            for (var service in provider.topServiceMap)
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const ServiceDetailsPage(),
                                    ),
                                  );
                                  Provider.of<ServiceDetailsService>(context,
                                          listen: false)
                                      .fetchServiceDetails(
                                          service['serviceId']);
                                },
                                child: ServiceCard(
                                  cc: cc,
                                  imageLink: service['image'] ?? placeHolderUrl,
                                  rating: twoDouble(service['rating']),
                                  title: asProvider.currentLanguage == 'English' ? service['title'] : service['title_ar'],
                                  sellerName: service['sellerName'],
                                  price: service['price'],
                                  buttonText: 'Book Now',
                                  width: MediaQuery.of(context).size.width - 85,
                                  marginRight: 17.0,
                                  pressed: () {
                                    provider.saveOrUnsave(
                                        service['serviceId'],
                                        service['title'],
                                        service['image'],
                                        service['price'],
                                        service['sellerName'],
                                        twoDouble(service['rating']),
                                        provider.topServiceMap.indexOf(service),
                                        context,
                                        service['sellerId']);
                                  },
                                  isSaved:
                                      service['isSaved'] == true ? true : false,
                                  serviceId: service['serviceId'],
                                  sellerId: service['sellerId'],
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  )
                : Text(asProvider.getString('Something went wrong'))
            : Container(),
      ),
    );
  }
}

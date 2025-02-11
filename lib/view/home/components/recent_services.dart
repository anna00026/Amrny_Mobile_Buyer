import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/all_services_service.dart';
import 'package:amrny/service/common_service.dart';
import 'package:amrny/service/home_services/recent_services_service.dart';
import 'package:amrny/service/service_details_service.dart';
import 'package:amrny/view/home/components/section_title.dart';
import 'package:amrny/view/home/components/service_card.dart';
import 'package:amrny/view/services/all_services_page.dart';
import 'package:amrny/view/services/service_details_page.dart';
import 'package:amrny/view/utils/constant_colors.dart';
import 'package:amrny/view/utils/others_helper.dart';

class RecentServices extends StatelessWidget {
  const RecentServices({
    super.key,
    required this.cc,
    required this.asProvider,
  });
  final ConstantColors cc;
  final asProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentServicesService>(
      builder: (context, provider, child) => provider.hasService != false
          ? provider.recentServiceMap.isNotEmpty
              ? provider.recentServiceMap[0] != 'error'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Consumer<AllServicesService>(
                          builder: (context, allServiceProvider, child) =>
                              SectionTitle(
                            cc: cc,
                            title: asProvider.getString('Recently listed'),
                            pressed: () {
                              //when user clicks on recent see all. set sort by dropdown to latest
                              allServiceProvider
                                  .setSortbyValue('Latest Service');
                              allServiceProvider
                                  .setSelectedSortbyId('latest_service');

                              //fetch service
                              allServiceProvider.setEverythingToDefault();
                              // allServiceProvider.fetchServiceByFilter(context);

                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const AllServicePage(),
                                ),
                              );
                            },
                          ),
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
                              for (var service in provider.recentServiceMap)
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
                                    imageLink:
                                        service['image'] ?? placeHolderUrl,
                                    rating: twoDouble(service['rating']),
                                    title:
                                        asProvider.currentLanguage == 'English'
                                            ? service['title']
                                            : service['title_ar'],
                                    sellerName: service['sellerName'],
                                    price: service['price'],
                                    buttonText: 'Book Now',
                                    width:
                                        MediaQuery.of(context).size.width - 85,
                                    marginRight: 17.0,
                                    pressed: () {
                                      // print(
                                      //     'service id is ${service['serviceId']}');
                                      provider.saveOrUnsave(
                                          service['serviceId'],
                                          asProvider.currentLanguage == 'English' ? service['title'] : service['title_ar'],
                                          service['image'],
                                          service['price'],
                                          service['sellerName'],
                                          twoDouble(service['rating']),
                                          provider.recentServiceMap
                                              .indexOf(service),
                                          context,
                                          service['sellerId']);
                                    },
                                    isSaved: service['isSaved'] == true
                                        ? true
                                        : false,
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
              : Container()
          : Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 35),
              child: Text(
                  asProvider.getString('No service available in your area')),
            ),
    );
  }
}

class SaveItemModel {
  late int serviceId;
  late int sellerId;
  late String title;
  late String titleAr;
  late String image;
  late var price;
  late String sellerName;
  late double rating;

  itemMap() {
    // ignore: unused_local_variable, prefer_collection_literals
    var mapping = Map<String, dynamic>();
    mapping['serviceId'] = serviceId;
    mapping['title'] = title;
    mapping['title_ar'] = titleAr;
    mapping['image'] = image;
    mapping['price'] = price;
    mapping['sellerName'] = sellerName;
    mapping['rating'] = rating;
    mapping['sellerId'] = sellerId;
    return mapping;
  }
}

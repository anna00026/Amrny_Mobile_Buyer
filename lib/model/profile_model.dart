// To parse this JSON data, do
//
//     final myordersListModel = profileModel(jsonString);

import 'dart:convert';

ProfileModel profileModel(String str) =>
    ProfileModel.fromJson(json.decode(str));

String myordersListModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.userDetails,
    this.pendingOrder,
    this.activeOrder,
    this.completeOrder,
    this.totalOrder,
  });

  UserDetails userDetails;
  int? pendingOrder;
  int? activeOrder;
  int? completeOrder;
  int? totalOrder;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        userDetails: UserDetails.fromJson(json["user_details"]),
        pendingOrder: json["pending_order"],
        activeOrder: json["active_order"],
        completeOrder: json["complete_order"],
        totalOrder: json["total_order"],
      );

  Map<String, dynamic> toJson() => {
        "user_details": userDetails.toJson(),
        "pending_order": pendingOrder,
        "active_order": activeOrder,
        "complete_order": completeOrder,
        "total_order": totalOrder,
      };
}

class UserDetails {
  UserDetails(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.about,
      this.googleId,
      this.facebookId,
      this.countryId,
      this.serviceCity,
      this.serviceArea,
      this.postCode,
      this.image,
      this.countryCode,
      required this.country,
      required this.city,
      required this.area,
      this.taxNumber,
      this.fbUrl,
      this.twUrl,
      this.goUrl,
      this.liUrl,
      this.yoUrl,
      this.inUrl,
      this.drUrl,
      this.twiUrl,
      this.piUrl,
      this.reUrl});

  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  dynamic about;
  int? countryId;
  dynamic googleId;
  dynamic facebookId;
  String? serviceCity;
  String? serviceArea;
  String? postCode;
  String? image;
  String? countryCode;
  Country? country;
  City? city;
  Area? area;

  String? taxNumber;

  String? fbUrl;
  String? twUrl;
  String? goUrl;
  String? liUrl;
  String? yoUrl;
  String? inUrl;
  String? drUrl;
  String? twiUrl;
  String? piUrl;
  String? reUrl;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        about: json["about"],
        countryId: json["country_id"],
        serviceCity: json["service_city"],
        serviceArea: json["service_area"],
        googleId: json["google_id"],
        facebookId: json["facebook_id"],
        postCode: json["post_code"],
        image: json["image"],
        countryCode: json["country_code"],
        country: Country.fromJson(json["country"]),
        city: City.fromJson(json["city"]),
        area: Area.fromJson(json["area"]),
        taxNumber: json['tax_number'],
        fbUrl: json['fb_url'],
        twUrl: json['tw_url'],
        goUrl: json['go_url'],
        liUrl: json['li_url'],
        yoUrl: json['yo_url'],
        inUrl: json['in_url'],
        drUrl: json['dr_url'],
        twiUrl: json['twi_url'],
        piUrl: json['pi_url'],
        reUrl: json['re_url'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "about": about,
        "country_id": countryId,
        "service_city": serviceCity,
        "service_area": serviceArea,
        "post_code": postCode,
        "image": image,
        "country_code": countryCode,
        "country": country?.toJson(),
        "city": city?.toJson(),
        "area": area?.toJson(),
        'tax_number': taxNumber,
        'fb_url': fbUrl,
        'tw_url': twUrl,
        'go_url': goUrl,
        'li_url': liUrl,
        'yo_url': yoUrl,
        'in_url': inUrl,
        'dr_url': drUrl,
        'twi_url': twiUrl,
        'pi_url': piUrl,
        're_url': reUrl,
      };
}

class Area {
  Area({
    this.id,
    this.serviceArea,
    this.serviceCityId,
    this.countryId,
    this.status,
  });

  int? id;
  String? serviceArea;
  int? serviceCityId;
  int? countryId;
  int? status;

  factory Area.fromJson(Map<String?, dynamic>? json) => Area(
        id: json?["id"],
        serviceArea: json?["service_area"],
        serviceCityId: json?["service_city_id"],
        countryId: json?["country_id"],
        status: json?["status"],
      );

  Map<String?, dynamic>? toJson() => {
        "id": id,
        "service_area": serviceArea,
        "service_city_id": serviceCityId,
        "country_id": countryId,
        "status": status,
      };
}

class City {
  City({
    this.id,
    this.serviceCity,
    this.countryId,
    this.status,
  });

  int? id;
  String? serviceCity;
  int? countryId;
  int? status;

  factory City.fromJson(Map<String?, dynamic>? json) => City(
        id: json?["id"],
        serviceCity: json?["service_city"],
        countryId: json?["country_id"],
        status: json?["status"],
      );

  Map<String?, dynamic>? toJson() => {
        "id": id,
        "service_city": serviceCity,
        "country_id": countryId,
        "status": status,
      };
}

class Country {
  Country({
    this.id,
    this.country,
    this.status,
  });

  int? id;
  String? country;
  int? status;

  factory Country.fromJson(Map<String?, dynamic>? json) => Country(
        id: json?["id"],
        country: json?["country"],
        status: json?["status"],
      );

  Map<String?, dynamic>? toJson() => {
        "id": id,
        "country": country,
        "status": status,
      };
}

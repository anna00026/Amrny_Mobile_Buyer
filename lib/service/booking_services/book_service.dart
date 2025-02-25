import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/profile_service.dart';
import 'package:amrny/view/utils/others_helper.dart';

class BookService with ChangeNotifier {
  int? serviceId;
  String? serviceTitle;
  String? serviceImage;
  int totalPrice = 0;
  int? sellerId;

  String selectedPayment = 'manual_payment';

  //address variables
  String? name;
  String? email;
  String? phone;
  String? postCode;
  String? address;
  String? orderNote;

  //selected shedule variables
  String? selectedDateAndMonth;
  DateTime? selectedDate;
  String? selectedTime;
  String? weekDay;

  setData(id, title, newPrice, sellerNewId, {image}) {
    serviceId = id;
    serviceTitle = title;
    serviceImage = image ?? placeHolderUrl;
    totalPrice = newPrice.round();
    sellerId = sellerNewId;
    notifyListeners();
  }

  setSelectedPayment(String value) {
    selectedPayment = value;
    print('selected payment $selectedPayment');
    notifyListeners();
  }

  setAddress(
      newName, newEmail, newPhone, newPostCode, newAddress, newOrderNote) {
    name = newName;
    email = newEmail;
    phone = newPhone;
    postCode = newPostCode;
    address = newAddress;
    orderNote = newOrderNote;
    notifyListeners();
  }

  setDeliveryDetailsBasedOnProfile(BuildContext context) {
    name = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .name ??
        'test';
    phone = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .phone ??
        '111111111';
    email = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .email ??
        'test@test.com';
    notifyListeners();
  }

  setDateTime(dateandMonth, time, newWeekday, {date}) {
    selectedDateAndMonth = dateandMonth;
    selectedTime = time;
    weekDay = newWeekday;
    selectedDate = date;
    notifyListeners();
  }

  setTotalPrice(newPrice) {
    totalPrice = newPrice;
    notifyListeners();
  }

  defaultTotalPrice() {
    totalPrice = 0;
    notifyListeners();
  }
}

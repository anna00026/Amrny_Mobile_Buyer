import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:amrny/service/all_services_service.dart';
import 'package:amrny/service/jobs_service/my_jobs_service.dart';
import 'package:amrny/service/profile_service.dart';
import 'package:amrny/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dropdowns_services/area_dropdown_service.dart';
import '../dropdowns_services/country_dropdown_service.dart';
import '../dropdowns_services/state_dropdown_services.dart';

class CreateJobService with ChangeNotifier {
  bool isLoading = false;

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  var pickedImage;

  final ImagePicker _picker = ImagePicker();

  Future pickAddressImage(BuildContext context) async {
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    notifyListeners();
  }

  Future<bool> createJob(BuildContext context,
      {required title,
      required titleAr,
      required desc,
      required onlineOrOffline,
      required price,
      required deadline}) async {
    var selectedCategoryId =
        Provider.of<AllServicesService>(context, listen: false)
            .selectedCategoryId;

    var selectedSubCategoryId =
        Provider.of<AllServicesService>(context, listen: false)
            .selectedSubcatId;
    String? selectedCountryId = defaultCountryId;
    var selectedStateId =
        Provider.of<ProfileService>(context, listen: false)
            .profileDetails.userDetails.city.id;

    if (pickedImage == null) {
      OthersHelper()
          .showSnackBar(context, 'You must select an image', Colors.red);
      return false;
    }

    if (selectedCategoryId == 0 || selectedSubCategoryId == 0) {
      OthersHelper().showSnackBar(
          context, 'You must select category & subcategory', Colors.red);
      return false;
    }

    var isOnline = onlineOrOffline == 0 ? 0 : 1;

    setLoadingStatus(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    FormData formData;
    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";

    formData = FormData.fromMap({
      'category': selectedCategoryId,
      'subcategory': selectedSubCategoryId,
      'country_id': selectedCountryId,
      'city_id': selectedStateId,
      'title': title,
      'title_ar': titleAr,
      'description': desc,
      'is_job_online': isOnline,
      'price': price,
      'dead_line': deadline,
      'image': await MultipartFile.fromFile(pickedImage.path,
          filename: 'campaing${pickedImage.path}.jpg'),
    });

    var response = await dio.post(
      '$baseApi/user/job/add-job',
      data: formData,
      options: Options(
        validateStatus: (status) {
          return true;
        },
      ),
    );

    setLoadingStatus(false);
    final data = response.data;

    if (response.statusCode == 201 && data.containsKey('msg')) {
      OthersHelper().showToast('Job posted successfully', Colors.black);

      Provider.of<MyJobsService>(context, listen: false).setDefault();

      Provider.of<MyJobsService>(context, listen: false).fetchMyJobs(context);

      Navigator.pop(context);

      return true;
    } else {
      print(response.data);
      OthersHelper().showToast('Something went wrong', Colors.black);
      return false;
    }
  }
}

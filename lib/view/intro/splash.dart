import 'package:flutter/material.dart';
import 'package:qixer/helper/extension/context_extension.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/view/auth/login/login.dart';
import 'package:qixer/view/home/landing_page.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:qixer/view/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'introduction_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      screenSizeAndPlatform(context);
    });
    // runAtstart(context);
    // SplashService().loginOrGoHome(context);
    //run when app starts
  }

  startInitialization(BuildContext context) async {
    await runAtstart(context);
    initializeLNProvider(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();    
    String? token = prefs.getString('token');
    if (token == null) {
      //that means user is opening the app for the first time.. so , show the intro
      Future.delayed(const Duration(microseconds: 2), () {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LoginPage(),
          ),
        );
      });
      return;
    } else {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LandingPage(),
          ),
        );
    }
    context.toUntilPage(const LandingPage());
  }

  @override
  Widget build(BuildContext context) {
    startInitialization(context);
    return Scaffold(
        backgroundColor: cc.primaryColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cc.primaryColor,
          ),
          // color: ConstantColors().primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fitHeight)),
              ),
              const SizedBox(height: 24),
              OthersHelper().showLoading(Colors.white),
              const SizedBox(height: 24),
            ],
          ),
        ));
  }
}

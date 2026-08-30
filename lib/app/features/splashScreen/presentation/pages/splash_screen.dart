import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constant/appImage.dart';
import '../../../../core/themes/app_colors.dart';
import '../controller/splashController.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: GetBuilder<SplashController>(builder: (controller) {
        return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Padding(
              padding: EdgeInsets.fromLTRB(100, 278, 100, 0),
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.08),
                      blurRadius: 25,
                      spreadRadius: -5,
                      offset: Offset(0, 20),
                    ),
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.04),
                      blurRadius: 10,
                      spreadRadius: -6,
                      offset: Offset(0, 8),
                    ),
                  ],
                  image: DecorationImage(image: AssetImage(AppImage.splashScreen), fit: BoxFit.cover)
                )
              )),
              SizedBox(height: 28),
              Padding(
              padding: EdgeInsets.fromLTRB(135,0,135,0),
              child: Text(
                "NewsFlow".toUpperCase(),
              style: TextStyle(
                color: Color(0xFF000666), 
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),),),

              Padding(
              padding: EdgeInsets.fromLTRB(0,201.5,0,0),
              child:SizedBox(
                child: Column(
                  children: [

                    Padding(
                      padding: EdgeInsets.fromLTRB(70,0,70,10),
                      child: Obx((){
                        return LinearProgressIndicator(
                      value: controller.progress.value,
                      color: Color(0xFF000666),
                    );
                      }),),
                    SizedBox(height: 10),

                    Text(
                  "high - signal journalism".toUpperCase(),
                  style: TextStyle(
                    color: Color(0xFF454652), 
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2.0,
                    height: 25/16
                  ),
                )
                  ],
                )
              )
              
              ),
            ],
          ),
        );
      },));
  }
}
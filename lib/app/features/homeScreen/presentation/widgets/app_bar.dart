import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/appPageName.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onProfileTap;
  final Function()? onSearchTap;

  const Appbar({super.key, this.onProfileTap, this.onSearchTap});

  @override
  Size get preferredSize => Size(Get.width, 56);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      width: Get.width,
      margin: const EdgeInsets.only(top: 40),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
              child: Text(
                'NewsFlow',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xFF1A237E),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Newsreader',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(onPressed: onSearchTap, icon: const Icon(Icons.search)),
                IconButton(
                  onPressed: () => Get.toNamed(AppPageName.bookmarks),
                  icon: const Icon(Icons.bookmark_outline, color: Color(0xFF1A237E)),
                ),
                // const SizedBox(width: 8),
                // GestureDetector(
                //   onTap: onProfileTap,
                //   child: Container(
                //     width: 32,
                //     height: 32,
                //     padding: const EdgeInsets.all(8),
                //     decoration: BoxDecoration(
                //       color: const Color(0xFF1A237E),
                //       borderRadius: BorderRadius.circular(100),
                //     ),
                //     child: SvgPicture.asset(AppImage.profile),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
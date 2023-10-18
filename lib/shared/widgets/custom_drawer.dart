import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: AssetImage(
                  "assets/pictures/drawer_pg.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            accountName: TextWidget(
                text: 'Name Name',
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                maxline: 1),
            accountEmail: TextWidget(
                text: 'test@gmail.com',
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.start,
                maxline: 1),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/pictures/logo.png"),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: AppColors.primaryDark,
            ),
            title: const TextWidget(
                text: 'Home',
                color: AppColors.blackDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                maxline: 1),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.account_box,
              color: AppColors.primaryDark,
            ),
            title: const TextWidget(
                text: 'Profile',
                color: AppColors.blackDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                maxline: 1),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.language_rounded,
              color: AppColors.primaryDark,
            ),
            title: const TextWidget(
                text: 'App Language',
                color: AppColors.blackDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                maxline: 1),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppColors.primaryDark,
            ),
            title: const TextWidget(
                text: 'Logout',
                color: AppColors.blackDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                maxline: 1),
            onTap: () {},
          )
        ],
      ),
    );
  }
}

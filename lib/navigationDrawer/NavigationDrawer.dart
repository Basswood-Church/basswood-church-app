import 'package:BasswoodChurch/widgets/createDrawerBodyItem.dart';
import 'package:BasswoodChurch/widgets/createDrawerHeader.dart';
import 'package:BasswoodChurch/widgets/youngReadersStatefulWidget.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isSelected = false;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          createDrawerBodyItem(
            icon: Icons.home,
            text: 'Home',
            //  onTap: () =>
            //      Navigator.pushReplacementNamed(context, pageRoutes.home),
          ),
          createDrawerBodyItem(
            icon: Icons.account_circle,
            text: 'Profile',
            //  onTap: () =>
            //      Navigator.pushReplacementNamed(context, pageRoutes.profile),
          ),
          Divider(),
          createDrawerBodyItem(
            icon: Icons.notifications_active,
            text: 'Notifications',
            //  onTap: () =>
            //      Navigator.pushReplacementNamed(context, pageRoutes.notification),
          ),
          const YoungReadersStatefulWidget(),
          ListTile(
            title: Text('App version 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

import 'package:app/utils/app_routes.dart';
import 'package:app/utils/push_page.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final pushPage = new Navigation();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Welcome'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Store'),
            onTap: () => pushPage.pushRepace(context, AppRoutes.Home),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () => pushPage.pushRepace(context, AppRoutes.Orders_Screem),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Products'),
            onTap: () => pushPage.pushRepace(context, AppRoutes.ProductScreen),
          )
        ],
      ),
    );
  }
}

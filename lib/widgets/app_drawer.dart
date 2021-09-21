import 'package:app/provider/auth.dart';
import 'package:app/utils/app_routes.dart';
import 'package:app/utils/push_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final pushPage = new Navigation();
  bool exit = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Welcome'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('Store'),
                onTap: () =>
                    pushPage.pushRepace(context, AppRoutes.ProductOverview),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Orders'),
                onTap: () =>
                    pushPage.pushRepace(context, AppRoutes.Orders_Screem),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Products'),
                onTap: () =>
                    pushPage.pushRepace(context, AppRoutes.ProductScreen),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Exit'),
                onTap: () {
                  setState(() {
                    exit = false;
                  });
                  Future.delayed(Duration(seconds: 5), () {
                    Provider.of<Auth>(context, listen: false).logout();
                  });
                },
              )
            ],
          ),
          exit
              ? Container()
              : Container(
                  color: const Color(0xFFfffffff).withOpacity(0.5),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text("Exiting..."),
                        SizedBox(
                          height: 20,
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

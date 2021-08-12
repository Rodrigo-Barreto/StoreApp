import 'package:app/provider/orders.dart';
import 'package:app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/order_item.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).loaderOrdens(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orders, child) {
                return ListView.builder(
                  itemCount: orders.orders.length,
                  itemBuilder: (ctx, item) => OrderItem(
                    orders.orders[item],
                  ),
                );
              },
            );
          }
        },
      ),

      //_isLoading
      // ? Center(
      // child: CircularProgressIndicator(),
      // )
      // : ListView.builder(
      //  itemCount: orders.orders.length,
      //  itemBuilder: (ctx, item) => OrderItem(
      //  orders.orders[item],
      // ),
      // ),
    );
  }
}

import 'package:app/provider/orders.dart';
import 'package:app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/order_item.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  bool _isLoading = true;
  void initState() {
    Provider.of<Orders>(context, listen: false).loaderOrdens().then(
      (_) {
        setState(
          () {
            _isLoading = false;
          },
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orders.orders.length,
              itemBuilder: (ctx, item) => OrderItem(
                orders.orders[item],
              ),
            ),
    );
  }
}

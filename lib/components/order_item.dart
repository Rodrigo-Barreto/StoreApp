import 'dart:ui';

import 'package:app/models/order.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _openContainer = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              ' R\$ ${widget.order.amount.toString()}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _openContainer = !_openContainer;
                });
              },
            ),
          ),
          if (_openContainer)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: (widget.order.products.length * 35.0) + 1,
              child: ListView(
                children: widget.order.products.map((item) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${item.quantity}x  R\$ ${item.price}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}

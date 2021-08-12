import 'package:app/provider/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/cart_item.dart';
import '../provider/orders.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final cartItems = cart.item.values.toList();
    final Orders orders = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Shopping Cart"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete), onPressed: () => cart.clearCart())
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      cart.totalAmount.toStringAsFixed(2),
                      style: TextStyle(color: Colors.white),
                    ),
                    avatar: Text(
                      'R\$',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  OrderButton(cart: cart, orders: orders)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, item) => CartItemWidget(
                      cartItem: cartItems[item],
                    )),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    @required this.orders,
  }) : super(key: key);

  final Cart cart;
  final Orders orders;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading?  Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    ) : TextButton(
      onPressed: widget.cart.totalAmount == 0
          ? null
          : () async {
            setState(() {
              _isLoading =true;
            });
             await widget.orders.addOrder(widget.cart);
              setState(() {
              _isLoading =false;
            });
              widget.cart.clearCart();
            },
      child: Text(' PURCHASE'),
    );
  }
}

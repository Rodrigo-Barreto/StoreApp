import 'package:app/models/product.dart';
import 'package:app/provider/products.dart';
import 'package:app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/push_page.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({this.product});

  final Navigation navigation = Navigation();

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                navigation.pushPage(
                    context, AppRoutes.ProductFormScreen, product);
              },
              color: Colors.green,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Delete Product"),
                    content: Text('He is sure ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Yes'),
                      )
                    ],
                  ),
                ).then((value) async {
                  try {
                    if (value) {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(product.id);
                    }
                  } catch (error) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Http error'),
                      ),
                    );
                  }
                });
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}

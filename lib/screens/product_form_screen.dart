import 'package:app/models/product.dart';
import 'package:app/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  void updateImageUrl() {
    if (validationImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final productModal = ModalRoute.of(context).settings.arguments as Product;

      if (productModal != null) {
        _formData['id'] = productModal.id;
        _formData['title'] = productModal.title;
        _formData['description'] = productModal.description;
        _formData['price'] = productModal.price;
        _formData['url'] = productModal.imageUrl;
        _imageUrlController.text = productModal.imageUrl;
      } else {
        _formData['price'] = '';
      }
    }
  }

  bool validationImageUrl(String url) {
    bool isHttp = url.toLowerCase().startsWith('http://');
    bool isHttps = url.toLowerCase().startsWith('https://');
    bool isPng = url.toLowerCase().endsWith('png');
    bool isJpg = url.toLowerCase().endsWith('jpg');
    bool isJpeg = url.toLowerCase().endsWith('jpeg');

    return (isHttp || isHttps) && (isPng || isJpg || isJpeg);
  }

  void initState() {
    super.initState();
    _imageFocusNode.addListener(updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.removeListener(updateImageUrl);
    _imageFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    final productModal = ModalRoute.of(context).settings.arguments as Product;
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }
    _form.currentState.save();

    final Product newProduct = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      imageUrl: _formData['url'],
    );
    final products = Provider.of<Products>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    try {
      if (_formData['id'] == null) {
        await products.addProduct(newProduct);
      } else {
        await products.updateProduct(newProduct);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Error"),
          content: Text(
            'Inespered Error',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ok'),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Form"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) => _formData['title'] = value,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Insert one valid Title ';
                          }

                          if (value.trim().length <= 3) {
                            return 'Insert one valid Title bigger of 3 characters  ';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price'].toString(),
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        focusNode: _priceFocusNode,
                        onSaved: (value) =>
                            _formData['price'] = double.parse(value),
                        validator: (value) {
                          var newPrice = double.tryParse(value);
                          bool isEmpety = value.trim().isEmpty;
                          bool isInvalid = newPrice == null || newPrice <= 0;
                          if (isEmpety || isInvalid) {
                            return 'Insert one valid Price ';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                          initialValue: _formData['description'],
                          decoration:
                              InputDecoration(labelText: 'Description '),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          onSaved: (value) => _formData['description'] = value,
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Insert one valid Description ';
                            }

                            if (value.trim().length <= 10) {
                              return 'Insert one valid Title bigger of 10 characters  ';
                            }

                            return null;
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'URL for Image'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageFocusNode,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) => _formData['url'] = value,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Insert one  Url ';
                                }

                                if (!validationImageUrl(value)) {
                                  return 'Insert one valid Url';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8, left: 10),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? Text('Put Url')
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}

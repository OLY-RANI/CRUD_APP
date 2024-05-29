import 'dart:convert';

import 'package:crud_app/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key, required this.product});

  final Product product;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _productCodeTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.productName!;
    _unitPriceTEController.text = widget.product.unitPrice!;
    _quantityTEController.text = widget.product.quantity!;
    _totalPriceTEController.text = widget.product.totalPrice!;
    _imageTEController.text = widget.product.image!;
    _productCodeTEController.text = widget.product.productCode!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameTEController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your product name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _unitPriceTEController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Unit Price',
                    labelText: 'Unit Price',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your Unit Price';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _quantityTEController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Quantity',
                    labelText: 'Quantity',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your Quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _totalPriceTEController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Total Price',
                    labelText: 'Total Price',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your Total Price';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _imageTEController,
                  decoration: InputDecoration(
                    hintText: 'Image',
                    labelText: 'Image',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your Image';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _productCodeTEController,
                  decoration: InputDecoration(
                    hintText: 'Product Code',
                    labelText: 'Product Code',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your product code';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: _updateProductInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProduct();
                      }
                    },
                    child: const Text('Update'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct() async {
    _updateProductInProgress = true;
    setState(() {});

    Map<String, String> inputData = {
      "Img": _imageTEController.text,
      "ProductCode": _productCodeTEController.text,
      "ProductName": _nameTEController.text,
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalPriceTEController.text,
      "UnitPrice": _unitPriceTEController.text
    };

    String updateProductUrl =
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}';

    Uri uri = Uri.parse(updateProductUrl);

    Response response = await post(uri,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(inputData));
    /* Response response = await post(uri,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(inputData));*/

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product has been updated')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update product failed! Try again.')),
      );
    }
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _unitPriceTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();
    super.dispose();
  }
}

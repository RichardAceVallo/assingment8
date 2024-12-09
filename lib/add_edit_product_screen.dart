import 'package:assignment8/database_helper.dart';
import 'package:flutter/material.dart';

class AddEditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _sku, _name, _description, _manufacturer;
  late double _price, _discountedPrice;
  late int _quantity;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _sku = widget.product!['sku'];
      _name = widget.product!['name'];
      _description = widget.product!['description'];
      _price = widget.product!['price'];
      _discountedPrice = widget.product!['discountedPrice'];
      _quantity = widget.product!['quantity'];
      _manufacturer = widget.product!['manufacturer'];
    } else {
      _sku = _name = _description = _manufacturer = '';
      _price = _discountedPrice = 0.0;
      _quantity = 0;
    }
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final product = {
        'id': widget.product?['id'],
        'sku': _sku,
        'name': _name,
        'description': _description,
        'price': _price,
        'discountedPrice': _discountedPrice,
        'quantity': _quantity,
        'manufacturer': _manufacturer,
      };

      if (widget.product == null) {
        await _dbHelper.insertProduct(product);
      } else {
        await _dbHelper.updateProduct(product);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _sku,
                decoration: const InputDecoration(labelText: 'SKU'),
                validator: (value) => value!.isEmpty ? 'Enter SKU' : null,
                onSaved: (value) => _sku = value!,
              ),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter Name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter Price' : null,
                onSaved: (value) => _price = double.parse(value!),
              ),
              TextFormField(
                initialValue: _discountedPrice.toString(),
                decoration:
                    const InputDecoration(labelText: 'Discounted Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _discountedPrice = double.parse(value!),
              ),
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter Quantity' : null,
                onSaved: (value) => _quantity = int.parse(value!),
              ),
              TextFormField(
                initialValue: _manufacturer,
                decoration: const InputDecoration(labelText: 'Manufacturer'),
                onSaved: (value) => _manufacturer = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(
                    widget.product == null ? 'Add Product' : 'Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

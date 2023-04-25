import 'package:flutter/material.dart';
import 'package:productos_app/providers/product_from_provider.dart';
import 'package:productos_app/widgets/product_img.dart';
import 'package:productos_app/providers/product_list_provider.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productListProvider = Provider.of<ProductListProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFromProvider(productListProvider.selectedProduct),
      child: _ProductScreenBody(productListProvider: productListProvider),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    super.key,
    required this.productListProvider,
  });

  final ProductListProvider productListProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            children: [
              ProductImg(
                url: productListProvider.selectedProduct.imagen,
              ),
              Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Colors.white,
                      ))),
              Positioned(
                  top: 60,
                  right: 30,
                  child: IconButton(
                      onPressed: () {
                        //TODO: poner camara o galeria
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Colors.white,
                      )))
            ],
          ),
          const _ProductFrom()
        ],
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Todo: Guardar producto
          },
          child: const Icon(Icons.save_outlined)),
    );
  }
}

class _ProductFrom extends StatelessWidget {
  const _ProductFrom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productFrom = Provider.of<ProductFromProvider>(context).product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          decoration: _buildBoxDecoration(),
          child: Form(
            child: Column(children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: productFrom.nombre,
                onChanged: (value) => productFrom.nombre = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                },
                decoration: const InputDecoration(
                    hintText: 'nombre del producto', labelText: 'nombre'),
              ),
              const SizedBox(height: 30),
              TextFormField(
                  initialValue: '${productFrom.precio}',
                  onChanged: (value) {
                    if (double.tryParse(value) == null) {
                      productFrom.precio = 0;
                    } else {
                      productFrom.precio = double.parse(value);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Precio del producto', labelText: 'precio')),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                value: true,
                title: const Text('Disponible'),
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
            ]),
          )),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]);
}

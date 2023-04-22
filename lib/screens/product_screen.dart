import 'package:flutter/material.dart';
import 'package:productos_app/widgets/product_img.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            children: [
              const ProductImg(),
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
                decoration: const InputDecoration(
                    hintText: 'nombre del producto', labelText: 'nombre'),
              ),
              const SizedBox(height: 30),
              TextFormField(
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

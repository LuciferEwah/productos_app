import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/plan_list_provider.dart';
import '../providers/product_list_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productListProvider = Provider.of<ProductListProvider>(context);
    final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
    final planListProvider = Provider.of<PlanListProvider>(context);
    final plans = planListProvider.plans;
    if (productListProvider.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        leading: ValueListenableBuilder<int>(
          valueListenable: currentIndex,
          builder: (BuildContext context, int index, Widget? child) {
            if (index == 0) {
              return IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, 'admin');
                },
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.admin_panel_settings_rounded),
                onPressed: () {
                  Navigator.pushNamed(context, 'suscripciones');
                },
              );
            }
          },
        ),
        title: ValueListenableBuilder<int>(
          valueListenable: currentIndex,
          builder: (BuildContext context, int index, Widget? child) {
            return Text(index == 0 ? 'Productos' : 'Planes');
          },
        ),
        centerTitle: true,
        actions: [
          ValueListenableBuilder<int>(
            valueListenable: currentIndex,
            builder: (BuildContext context, int index, Widget? child) {
              if (index == 0) {
                return ButtonShoping(
                    productList: productListProvider.productsForCard,
                    productListProvider: productListProvider);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, index, _) {
          return IndexedStack(
            index: index,
            children: [
              ListView.builder(
                itemCount: productListProvider.products.length,
                itemBuilder: (context, i) => GestureDetector(
                  child: ProductCard(
                      product: productListProvider.products[i],
                      productListProvider: productListProvider),
                  onTap: () {
                    productListProvider.selectedProduct =
                        productListProvider.products[i].copy();
                    Navigator.pushNamed(context, 'producto');
                    
                  },
                ),
              ),
              PlanScreen(),
            ],
          );
        },
      ),
      floatingActionButton: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, index, _) {
          return Stack(
            children: [
              Positioned(
                left: 40,
                bottom: 16,
                child: index == 1
                    ? FloatingActionButton(
                        onPressed: () async {
                          
                          await planListProvider.newPlan(
                            nombre: '',
                            precioMensual: 0,
                            duracionMeses: 0,
                            renovacionAutomatica: 0,
                          );

                          
                        },
                        child: const Icon(Icons
                            .add_box_outlined), 
                      )//TODO: QUE EL BOTON NO TIRE PARA ATRAS
                    : const SizedBox.shrink(),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: index == 0
                    ? FloatingActionButton(
                        child: const Icon(Icons.add),
                        onPressed: () async {
                          productListProvider.newProduct(
                              nombre: '', precio: 0.0, stock: 0);
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomNavigatorBar(currentIndex: currentIndex),
    );
  }
}

class ButtonShoping extends StatelessWidget {
  const ButtonShoping({
    super.key,
    required this.productList,
    required this.productListProvider,
  });

  final List<ProductModel> productList;
  final ProductListProvider productListProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, 'carrito');
          },
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              productListProvider.productsForCard.length.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

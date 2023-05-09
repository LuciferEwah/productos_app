import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/plan_list_provider.dart';
import '../providers/product_list_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final productListProvider = Provider.of<ProductListProvider>(context);
    final PageController pageController = PageController();
    final planListProvider = Provider.of<PlanListProvider>(context);
    final plans = planListProvider.plans;
    if (productListProvider.isLoading) return const LoadingScreen();

    pageController.addListener(() {
      setState(() {
        currentIndex = pageController.page!.round();
      });
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            currentIndex == 0
                ? Icons.admin_panel_settings_outlined
                : Icons.admin_panel_settings_rounded,
          ),
          onPressed: () {
            print('boton');
            Navigator.pushNamed(
                context, currentIndex == 0 ? 'admin' : 'admin_sub');
          },
        ),
        title: Text(currentIndex == 0 ? 'Productos' : 'Planes'),
        centerTitle: true,
        actions: [
          if (currentIndex == 0)
            ButtonShoping(
              productList: productListProvider.productsForCard,
              productListProvider: productListProvider,
            ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
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
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                productListProvider.newProduct(
                    nombre: '', precio: 0.0, stock: 0);
              },
            )
          : FloatingActionButton(
              onPressed: () async {
                await planListProvider.newPlan(
                  nombre: '',
                  precioMensual: 0,
                  duracionMeses: 0,
                  renovacionAutomatica: 0,
                );
              },
              child: const Icon(Icons.add_box_outlined),
            ),
      bottomNavigationBar: CustomNavigatorBar(
          currentIndex: currentIndex, pageController: pageController),
    );
  }
}

class ButtonShoping extends StatelessWidget {
  const ButtonShoping({
    Key? key,
    required this.productList,
    required this.productListProvider,
  }) : super(key: key);

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

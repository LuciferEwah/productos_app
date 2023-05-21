import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import 'package:productos_app/providers/provider.dart';
import 'package:productos_app/services/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  late Future<ConnectivityResult> _connectivityResult;
  @override
  void initState() {
    //TODO: ESTO ES DE PRUEBA, ELIMINAR CUANDO NO SE OCUPE
    super.initState();
    _connectivityResult = Connectivity().checkConnectivity();
    _connectivityResult.then((result) {
      if (result == ConnectivityResult.none) {
        // No hay conexión a internet
        print('No estás conectado a internet');
      } else {
        // Hay conexión a internet
        print('Estás conectado a internet');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productListProvider = Provider.of<ProductListProvider>(context);
    final PageController pageController = PageController();
    final planListProvider = Provider.of<PlanListProvider>(context);
    final productsService = ProductsService();
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
          const PlanScreen(),
        ],
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                productListProvider.newProduct(
                    nombre: '', precio: 0.0, stock: 0);
                // Llamada a la función para sincronizar los productos con Firebase
                productsService.syncProductsToFirebase();
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

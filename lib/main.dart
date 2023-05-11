import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';
import 'providers/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => ProductListProvider()),
        ChangeNotifierProvider(create: (_) => UserListProvider()),
        ChangeNotifierProvider(create: (_) => PlanListProvider()),
        ChangeNotifierProvider(create: (_) => SuscriptionListProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'login': (_) => const LoginScreen(),
        'home': (_) => const HomeScreen(),
        'producto': (_) => const ProductScreen(),
        'register': (_) => const RegisterScreen(),
        'carrito': (_) => const ShoppingScreen(),
        'admin': (_) => const UserListPage(),
        'suscripciones': (_) => const SubscriptionsScreen(),
        'plan': (_) => const PlanScreen(),
        'admin_sub': (_) => const AdminSubScreen(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[400],
          appBarTheme: AppBarTheme(elevation: 0, color: Colors.orange[700]),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.orange[700], elevation: 0)),
    );
  }
}

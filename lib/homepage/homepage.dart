import 'package:flutter/material.dart';
import 'package:shopping_mall_project/data/models/product_entity.dart';
import 'package:shopping_mall_project/homepage/app_title.dart';
import 'package:shopping_mall_project/presentation/screens/product_create_page.dart';
import 'package:shopping_mall_project/presentation/screens/product_detail_page.dart';
import 'package:shopping_mall_project/presentation/screens/product_list_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  final List<ProductEntity> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShopTitle(),
        shape: const Border(bottom: BorderSide(color: Colors.black, width: 1)),
      ),
      body: ProductList(
        products: products,
        onItemTap: (product) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: product),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.push<ProductEntity>(
            context,
            MaterialPageRoute(builder: (context) => ProductCreatePage()),
          );

          if (result == null) return;

          setState(() {
            products.add(result);
          });
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }
}

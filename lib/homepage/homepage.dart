import 'package:flutter/material.dart';
import 'package:shopping_mall_project/data/models/product_entity.dart';
import 'package:shopping_mall_project/homepage/app_title.dart';
import 'package:shopping_mall_project/presentation/screens/product_create_page.dart';
import 'package:shopping_mall_project/presentation/screens/product_detail_page.dart';
import 'package:shopping_mall_project/presentation/screens/product_list_page.dart';
import 'package:shopping_mall_project/presentation/screens/product_shopping_cart.dart'; // ✅ 추가

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  final List<ProductEntity> products = [];
  final List<ProductEntity> cart = [];

  void addtoCart(ProductEntity product, int quantity) {
    setState(() {
      for (int i = 0; i < quantity; i++) {
        cart.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ShopTitle(),
        shape: const Border(bottom: BorderSide(color: Colors.black, width: 1)),

        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Text(
                        cart.length.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShoppingCart(cart: cart), // ✅ 같은 리스트 전달
                ),
              ).then((_) {
                // ✅ 장바구니에서 삭제 후 돌아왔을 때 홈 화면도 새로고침
                setState(() {});
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: ProductList(
        products: products,
        onItemTap: (product) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                product: product,
                onAddToCart: addtoCart,
                cart: cart,
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.push<ProductEntity>(
            context,
            MaterialPageRoute(builder: (_) => ProductCreatePage()),
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


// import 'package:flutter/material.dart';
// import 'package:shopping_mall_project/data/models/product_entity.dart';
// import 'package:shopping_mall_project/homepage/app_title.dart';
// import 'package:shopping_mall_project/presentation/screens/product_create_page.dart';
// import 'package:shopping_mall_project/presentation/screens/product_detail_page.dart';
// import 'package:shopping_mall_project/presentation/screens/product_list_page.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomePageState();
// }

// class _HomePageState extends State<Homepage> {
//   final List<ProductEntity> products = [];
//   final List<ProductEntity> cart=[];

//   void addtoCart(ProductEntity product, int quantity){
//     setState(() {
//       for (int i =0; i < quantity; i++){
//       cart.add(product);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: ShopTitle(),
//         shape: const Border(bottom: BorderSide(color: Colors.black, width: 1)),
//       ),
//       body: ProductList(
//         products: products,
//         onItemTap: (product) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ProductDetailPage(
//                 product: product,
//                 onAddToCart: addtoCart,
//                 cart: cart,
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         shape: const CircleBorder(),
//         onPressed: () async {
//           final result = await Navigator.push<ProductEntity>(
//             context,
//             MaterialPageRoute(builder: (context) => ProductCreatePage()),
//           );

//           if (result == null) return;

//           setState(() {
//             products.add(result);
//           });
//         },
//         backgroundColor: Colors.lightBlueAccent,
//         child: const Icon(Icons.add, color: Colors.white, size: 24),
//       ),
//     );
//   }
// }

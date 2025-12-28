import 'package:flutter/material.dart';
import 'package:shopping_mall_project/data/models/product_entity.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.products,
  });

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('상품을 등록해주세요'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      itemCount: products.length,
      separatorBuilder: (_, __) => const Divider(
        height: 32,
        thickness: 1,
        color: Colors.black,
      ),
      itemBuilder: (context, index) {
        final p = products[index];
        return ProductListTile(product: p);
      },
    );
  }
}

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 110,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(28),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: const Text(
            '이미지',
            style: TextStyle(color: Colors.black38),
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  product.description.isEmpty ? '상품 설명글' : product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        Padding(
          padding: const EdgeInsets.only(top: 110),
          child: Text(
            '${product.price}원',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

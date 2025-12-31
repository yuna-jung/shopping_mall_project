import 'package:flutter/material.dart';
import 'package:shopping_mall_project/data/models/product_entity.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.products,
    required this.onItemTap,
  });

  final List<ProductEntity> products;
  final void Function(ProductEntity product) onItemTap;

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
        return ProductListTile(
          product: p,
          onTap: () => onItemTap(p),
        );
      },
    );
  }
}

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductEntity product;
  final VoidCallback onTap;

    String formatPrice(int price){
    final formatter = NumberFormat('#,###');
    return '${formatter.format(price)}원';
  }

  Widget _buildProductImage(ProductEntity product) {
  // 1) 로컬 이미지가 있으면 파일로 표시
  if (product.imagePath != null && product.imagePath!.isNotEmpty) {
    final file = File(product.imagePath!);
    return Image.file(file, fit: BoxFit.cover);
  }

  // 2) 네트워크 이미지가 있으면 네트워크로 표시
  if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
    return Image.network(product.imageUrl!, fit: BoxFit.cover);
  }

  // 3) 아무것도 없으면 placeholder
  return const Center(
    child: Text('이미지', style: TextStyle(color: Colors.black38)),
  );
}
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: _buildProductImage(product),
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
                formatPrice(product.price),
                // '${product.price}원',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
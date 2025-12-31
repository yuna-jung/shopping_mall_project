import 'package:flutter/material.dart';
import 'package:shopping_mall_project/data/models/product_entity.dart';
import 'dart:io';
import 'package:shopping_mall_project/homepage/app_title.dart';
import 'package:shopping_mall_project/presentation/screens/product_shopping_cart.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductEntity product;

  final void Function(ProductEntity product, int quantity) onAddToCart;
  final List<ProductEntity>cart;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.cart,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  int get totalPrice => widget.product.price * quantity;

  String formatPrice(int price) {
    if (price == 0) return '무료';
    final priceString = price.toString();
    final formatted = priceString.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '$formatted원';
  }

  Widget _buildProductImage() {
    final imagePath = widget.product.imagePath;
    final imageUrl = widget.product.imageUrl;

    if (imagePath != null && imagePath.isNotEmpty) {
      return Image.file(
        File(imagePath),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 250,
          color: Colors.grey,
          alignment: Alignment.center,
          child: const Icon(Icons.error),
        ),
      );
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 250,
          color: Colors.grey,
          alignment: Alignment.center,
          child: const Icon(Icons.error),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Text('이미지 없음'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ShopTitle()),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildProductImage(),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formatPrice(widget.product.price),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    '상품설명\n',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.product.description.isEmpty
                        ? '상품 설명이 없습니다.'
                        : widget.product.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          _bottomPurchaseSection(),
        ],
      ),
    );
  }

  Widget _bottomPurchaseSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  if (quantity > 1) quantity--;
                }),
                icon: const Icon(Icons.remove),
              ),
              Text(quantity.toString()),
              IconButton(
                onPressed: () => setState(() {
                  if (quantity < 100) quantity++;
                }),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  const Text('총가격',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    formatPrice(totalPrice),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => _confirmPurchase(context),
            child: const Text('구매'),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => _producthold(context), 
            child: const Text('담기'),
          ),
        ],
      ),
    );
  }

  void _confirmPurchase(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('${widget.product.name}을(를) $quantity개 구매하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('구매가 완료되었습니다.')),
              );
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _producthold(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        content: Text('${widget.product.name}가 장바구니에 담겼습니다.'),
        actions: [          
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              widget.onAddToCart(widget.product,quantity);
              Navigator.pop(dialogContext);
              Navigator.push(
                parentContext,
                MaterialPageRoute(
                  builder: (_) => ShoppingCart(cart: widget.cart),
                ),
              );
              ScaffoldMessenger.of(parentContext).showSnackBar(
                const SnackBar(content: Text('장바구니에 담겼습니다.')),
              );
            },
            child: const Text('장바구니로 이동'),
          ),
        ],
      ),
    );
  }
}
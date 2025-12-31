import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shopping_mall_project/data/models/product_entity.dart';
import 'package:shopping_mall_project/homepage/app_title.dart';

class ShoppingCart extends StatefulWidget {
  final List<ProductEntity> cart;
  const ShoppingCart({super.key, required this.cart});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  late List<int> quantities;

  @override
  void initState() {
    super.initState();
    // 초기 장바구니 리스트의 길이에 맞춰 수량 리스트 생성
    quantities = List.filled(widget.cart.length, 1);
  }

  // 금액 포맷 함수
  String formatPrice(int price) {
    final s = price.toString();
    final formatted = s.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => ',',
    );
    return '$formatted원';
  }

  // 총 결제 금액 계산
  int get totalPrice {
    int sum = 0;
    for (int i = 0; i < widget.cart.length; i++) {
      sum += widget.cart[i].price * quantities[i];
    }
    return sum;
  }

  // 아이템 삭제 함수 (setState를 통해 화면 즉시 갱신)
  void _removeItem(int index) {
    setState(() {
      widget.cart.removeAt(index);      // 실제 상품 데이터 삭제
      quantities.removeAt(index);      // 해당 상품의 수량 데이터 삭제
    });
  }

  void _inc(int index) {
    setState(() {
      if (quantities[index] < 100) quantities[index]++;
    });
  }

  void _dec(int index) {
    setState(() {
      if (quantities[index] > 1) quantities[index]--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ [수정] build 내부에 있던 quantities 재초기화 로직을 완전히 제거했습니다.
    // 해당 로직이 있으면 삭제 버튼을 눌러도 화면이 갱신되지 않는 문제가 발생합니다.

    if (widget.cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const ShopTitle()),
        body: const Center(child: Text('장바구니가 비었습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const ShopTitle()),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
        itemCount: widget.cart.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 32, thickness: 1, color: Colors.black),
        itemBuilder: (context, index) {
          final p = widget.cart[index];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _productThumb(p),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        _qtyButton(icon: Icons.remove, onTap: () => _dec(index)),
                        const SizedBox(width: 6),
                        Container(
                          width: 48,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            quantities[index].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _qtyButton(icon: Icons.add, onTap: () => _inc(index)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => _removeItem(index), // 즉시 삭제 작동
                    icon: const Icon(Icons.close),
                    splashRadius: 18,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    formatPrice(p.price * quantities[index]),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('총 결제 금액: ${formatPrice(totalPrice)}')),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                '구매하기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 썸네일 이미지 표시 위젯
  Widget _productThumb(ProductEntity p) {
    final imagePath = p.imagePath;
    final imageUrl = p.imageUrl;
    Widget child;

    if (imagePath != null && imagePath.isNotEmpty) {
      child = Image.file(File(imagePath), fit: BoxFit.cover);
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      child = Image.network(imageUrl, fit: BoxFit.cover);
    } else {
      child = Container(
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: const Text('이미지'),
      );
    }

    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: child,
      ),
    );
  }

  // 수량 조절 버튼 위젯
  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      width: 36,
      height: 36,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
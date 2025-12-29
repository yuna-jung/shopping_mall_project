import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  int get totalPrice => widget.product['price'] * quantity;

  String formatPrice(int price) {
    if (price == 0) return '무료';

    final priceString = price.toString();
    final formatted = priceString.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '$formatted원';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CASE SHOP')),
      body: Column(
        children: [
          /// 🔹 스크롤 영역
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 상품 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product['imageUrl'],
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 50),

                  /// 🔸 상품명 + 가격 (같은 줄)
                  Row(
                    children: [
                      Text(
                        widget.product['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formatPrice(widget.product['price']),
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

                  /// 상품 설명
                  Text(
                    widget.product['description'] ?? '상품 설명이 없습니다.',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 하단 구매 영역
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                /// 수량 + 총가격
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      onPressed: () {
                        if (quantity < 100) {
                          setState(() => quantity++);
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 12),

                    //const Spacer(),
                    Column(
                      children: [
                        const Text(
                          '총가격',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
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

                /// 구매하기 버튼
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // 직사각형
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                              '${widget.product['name']}을(를) '
                              '$quantity개 구매하시겠습니까?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: const Text('구매완료'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('확인'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('구매하기'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

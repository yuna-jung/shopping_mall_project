import 'package:flutter/material.dart';
import 'package:shopping_mall_project/homepage/app_title.dart';
import 'package:shopping_mall_project/data/models/product_entity.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProductCreatePage extends StatefulWidget {
  @override
  State<ProductCreatePage> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: ShopTitle(),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          shape: const Border(
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: _selectedImage == null
                          ? const Center(
                              child: Text(
                                '이미지를 선택하세요',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 상품명 입력
                  Row(
                    children: [
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '상품 등록',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 상품 가격 입력
                  Row(
                    children: [
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '상품 가격',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('원'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 설명글 입력
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _descController,
                      maxLines: 9,
                      decoration: const InputDecoration(
                        hintText: '설명글을 작성하세요',
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 등록 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        final name = _nameController.text.trim();
                        final priceText = _priceController.text.trim();
                        final desc = _descController.text.trim();

                        if (name.isEmpty || priceText.isEmpty) return;

                        final price = int.tryParse(priceText);
                        if (price == null) return;

                        final product = ProductEntity(
                          name: name,
                          price: price,
                          description: desc,
                          imagePath: _selectedImage?.path,
                          imageUrl: null,
                        );
                        Navigator.pop(context, product);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                      child: const Text(
                        '등록하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

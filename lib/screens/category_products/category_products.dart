import 'package:bar_on_wheels/widgets/titles/top_title.dart';
import 'package:flutter/material.dart';

import '../../constants/routes.dart';
import '../../firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:bar_on_wheels/models/category_model/category_model.dart';
import '../../models/product_model/product_model.dart';
import '../product_details/product_detail.dart';

class CategoryProducts extends StatefulWidget {
  final CategoryModel categoryModel;
  const CategoryProducts({super.key, required this.categoryModel});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  List<ProductModel> productList = [];
  bool isLoading = false;
  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });

    productList = await FirebaseFirestoreHelper.instance
        .getCategoryViewProduct(widget.categoryModel.id);
    productList.shuffle();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  Row(
                    children: [
                      const BackButton(),
                      TopTitle(title: widget.categoryModel.name, subtitle: ""),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: productList.length,
                        primary: false,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          ProductModel singleProduct = productList[index];
                          // print(singleProduct.ml);

                          return productList.isEmpty
                              ? const Center(
                                  child: Text("There are no products"),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Image.network(
                                        singleProduct.image,
                                        width: 80,
                                        height: 80,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          singleProduct.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "£ ${singleProduct.price}",
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      SizedBox(
                                        height: 45,
                                        width: 135,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Routes.instance.push(
                                              ProductDetail(
                                                  singleProduct: singleProduct),
                                              context,
                                            );
                                          },
                                          child: const Text(
                                            "View Product",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        }),
                  )
                ],
              ),
            ),
    );
  }
}

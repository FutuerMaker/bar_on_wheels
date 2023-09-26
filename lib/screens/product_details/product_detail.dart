import 'package:bar_on_wheels/constants/constants.dart';
import 'package:bar_on_wheels/constants/routes.dart';
import 'package:bar_on_wheels/screens/cart_screen/cart_screen.dart';
import 'package:bar_on_wheels/screens/checkout_screen/checkout_screen.dart';
import 'package:bar_on_wheels/screens/favourite_screen/favourite_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model/product_model.dart';
import '../../providers/app_provider.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetail({super.key, required this.singleProduct});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Routes.instance.push(const CartScreen(), context);
            },
            icon: const Icon(
              Icons.shopping_basket_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              Routes.instance.push(const FavouriteScreen(), context);
            },
            icon: const Icon(
              Icons.favorite_outline,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Image.network(
              widget.singleProduct.image,
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: MediaQuery.sizeOf(context).width,
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.singleProduct.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.singleProduct.isFavourite =
                                !widget.singleProduct.isFavourite;
                          });
                          if (widget.singleProduct.isFavourite) {
                            appProvider
                                .addFavouriteProduct(widget.singleProduct);
                          } else {
                            appProvider
                                .removeFavouriteProduct(widget.singleProduct);
                          }
                        },
                        icon: Icon(
                          appProvider.getFavouriteProductList
                                  .contains(widget.singleProduct.isFavourite)
                              ? Icons.favorite_sharp
                              : Icons.favorite_border,
                          color: widget.singleProduct.isFavourite
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(widget.singleProduct.description),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (qty > 0) {
                            setState(() {
                              qty--;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle,
                        ),
                      ),
                      Text(qty.toString()),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            qty++;
                          });
                        },
                        icon: const Icon(Icons.add_circle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 45,
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  child: OutlinedButton(
                    onPressed: () {
                      ProductModel productModel =
                          widget.singleProduct.copyWith(qty: qty);
                      appProvider.addCartProduct(productModel);
                      showMessage("Product added to cart");
                    },
                    child: const Text(
                      "Add to Cart",
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.05,
                ),
                SizedBox(
                  height: 45,
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  child: ElevatedButton(
                    onPressed: () {
                      ProductModel productModel =
                          widget.singleProduct.copyWith(qty: qty);
                      appProvider.addCartProduct(productModel);
                      Routes.instance.push(
                          Checkout(
                            singleProduct: productModel,
                          ),
                          context);
                    },
                    child: const Text(
                      "Buy Now",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}

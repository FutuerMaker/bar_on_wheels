import 'package:bar_on_wheels/constants/constants.dart';
import 'package:bar_on_wheels/constants/routes.dart';
import 'package:bar_on_wheels/screens/cart_items_checkout/cart_item_checkout.dart';
import 'package:bar_on_wheels/screens/cart_screen/widget/cart_item.dart';
import 'package:bar_on_wheels/screens/home/home.dart';
import 'package:bar_on_wheels/screens/product_details/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';
import '../../widgets/btns/primary_btn.dart';
import '../favourite_screen/favourite_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total ",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "£${appProvider.totalPrice().toString()}",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              PrimaryButton(
                title: "Checkout",
                onPress: () {
                  appProvider.clearBuyProduct();
                  appProvider.addBuyProductCartList();
                  appProvider.clearCart();
                  if (appProvider.getBuyProductList.isEmpty) {
                    showMessage("Cart is Empty");
                  } else {
                    Routes.instance.push(const CartItemCheckout(), context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        // backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Your Cart",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                Routes.instance.push(
                  const FavouriteScreen(),
                  context,
                );
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
      body: appProvider.getCartProductList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No products added to your cart"),
                  const SizedBox(
                    height: 24,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Routes.instance.pushAndRemoveUntil(
                            widget: const Home(), context: context);
                      },
                      child: const Text("Add Products Now"))
                ],
              ),
            )
          : ListView.builder(
              itemCount: appProvider.getCartProductList.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Routes.instance.push(
                        ProductDetail(
                          singleProduct: appProvider.getCartProductList[index],
                        ),
                        context);
                  },
                  child: CartItem(
                    singleProduct: appProvider.getCartProductList[index],
                  ),
                );
              }),
    );
  }
}

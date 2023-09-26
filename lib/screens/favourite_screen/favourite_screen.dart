import 'package:bar_on_wheels/screens/favourite_screen/widget/favourite_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/routes.dart';
import '../../providers/app_provider.dart';
import '../cart_screen/cart_screen.dart';
import '../home/home.dart';
import '../product_details/product_detail.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "My Favourites",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                Routes.instance.push(const CartScreen(), context);
              },
              icon: const Icon(
                Icons.shopping_basket_outlined,
              ),
            )
          ],
        ),
      ),
      body: appProvider.getFavouriteProductList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have favuorites"),
                  const SizedBox(
                    height: 24,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Routes.instance.pushAndRemoveUntil(
                            widget: const Home(), context: context);
                      },
                      child: const Text("Find them NOW"))
                ],
              ),
            )
          : ListView.builder(
              itemCount: appProvider.getFavouriteProductList.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Routes.instance.push(
                        ProductDetail(
                          singleProduct:
                              appProvider.getFavouriteProductList[index],
                        ),
                        context);
                  },
                  child: FavouriteCard(
                    singleProduct: appProvider.getFavouriteProductList[index],
                  ),
                );
              }),
    );
  }
}

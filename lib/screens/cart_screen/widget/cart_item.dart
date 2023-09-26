import 'package:bar_on_wheels/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product_model/product_model.dart';
import '../../../providers/app_provider.dart';

class CartItem extends StatefulWidget {
  final ProductModel singleProduct;
  const CartItem({super.key, required this.singleProduct});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int qty = 1;
  @override
  void initState() {
    qty = widget.singleProduct.qty ?? 1;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              color: Colors.grey.shade100,
              border: Border.all(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
            child: Image.network(
              widget.singleProduct.image,
              width: MediaQuery.sizeOf(context).width * 0.3,
              height: MediaQuery.sizeOf(context).height * 0.17,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 12.0, top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              widget.singleProduct.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      Text("£${widget.singleProduct.price.toString()}"),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 6, bottom: 4),
                  child: Text("widget.singleProduct.ml.toString()"),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.singleProduct.isFavourite =
                              !widget.singleProduct.isFavourite;
                        });

                        if (widget.singleProduct.isFavourite) {
                          appProvider.addFavouriteProduct(widget.singleProduct);
                        } else {
                          appProvider
                              .removeFavouriteProduct(widget.singleProduct);
                        }
                      },
                      icon: Icon(
                        appProvider.getFavouriteProductList
                                .contains(widget.singleProduct.isFavourite)
                            ? Icons.favorite_outline
                            : Icons.favorite,
                        color: widget.singleProduct.isFavourite
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (qty >= 1) {
                              setState(() {
                                qty--;
                              });

                              if (qty == 0) {
                                AppProvider appProvider =
                                    Provider.of<AppProvider>(context,
                                        listen: false);
                                appProvider
                                    .removeCartProduct(widget.singleProduct);
                                showMessage("Product Removed from the cart");
                              }
                            }
                            appProvider.updateQty(widget.singleProduct, qty);
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
                            appProvider.updateQty(widget.singleProduct, qty);
                          },
                          icon: const Icon(Icons.add_circle),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        AppProvider appProvider =
                            Provider.of<AppProvider>(context, listen: false);
                        appProvider.removeCartProduct(widget.singleProduct);
                        showMessage("Product Removed from the cart");
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

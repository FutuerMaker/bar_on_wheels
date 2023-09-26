import 'package:bar_on_wheels/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product_model/product_model.dart';
import '../../../providers/app_provider.dart';

class FavouriteCard extends StatefulWidget {
  final ProductModel singleProduct;
  const FavouriteCard({super.key, required this.singleProduct});

  @override
  State<FavouriteCard> createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<FavouriteCard> {
  @override
  Widget build(BuildContext context) {
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
              height: MediaQuery.sizeOf(context).height * .17,
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
                // const SizedBox(
                //   height: 6,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          ProductModel productModel =
                              widget.singleProduct.copyWith(qty: 1);
                          AppProvider appProvider =
                              Provider.of<AppProvider>(context, listen: false);
                          appProvider.addCartProduct(productModel);
                          showMessage("Product added to cart");
                        },
                        child: const Text(
                          "Add to Cart",
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.singleProduct.isFavourite =
                              !widget.singleProduct.isFavourite;
                        });
                        if (!widget.singleProduct.isFavourite) {
                          AppProvider appProvider =
                              Provider.of<AppProvider>(context, listen: false);
                          appProvider
                              .removeFavouriteProduct(widget.singleProduct);
                          showMessage(
                              "${widget.singleProduct.name} removed from Favourites");
                        }
                      },
                      icon: Icon(
                        widget.singleProduct.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.singleProduct.isFavourite
                            ? Colors.red
                            : Colors.black,
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

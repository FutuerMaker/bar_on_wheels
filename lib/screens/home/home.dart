import 'package:bar_on_wheels/constants/routes.dart';
import 'package:bar_on_wheels/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:bar_on_wheels/models/category_model/category_model.dart';
import 'package:bar_on_wheels/screens/category_products/category_products.dart';
import 'package:bar_on_wheels/screens/favourite_screen/favourite_screen.dart';
import 'package:bar_on_wheels/screens/product_details/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model/product_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/titles/top_title.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categoriesList = [];
  List<ProductModel> productList = [];
  bool isLoading = false;

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getCategoryList();
    super.initState();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestoreHelper.instance.updateTokenFromFirebase();

    categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
    categoriesList.shuffle();
    productList = await FirebaseFirestoreHelper.instance.getBestProducts();
    productList.shuffle();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList = [];
  void searchProducts(String value) {
    searchList = productList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TopTitle(title: "BOW", subtitle: ""),
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
                            TextFormField(
                              controller: search,
                              onChanged: (String value) {
                                searchProducts(value);
                              },
                              decoration: const InputDecoration(
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            const Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categoriesList
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Routes.instance.push(
                                        CategoryProducts(categoryModel: e),
                                        context,
                                      );
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image.network(e.image),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      !isSearched()
                          ? const Padding(
                              padding: EdgeInsets.only(top: 12.0, left: 12.0),
                              child: Text(
                                "Best Products",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : SizedBox.fromSize(),
                      const SizedBox(
                        height: 12,
                      ),
                      search.text.isNotEmpty && searchList.isEmpty
                          ? const Center(
                              child: Text("No Products found"),
                            )
                          : searchList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: GridView.builder(
                                      padding: EdgeInsets.only(bottom: 50),
                                      shrinkWrap: true,
                                      itemCount: searchList.length,
                                      primary: false,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 20,
                                        crossAxisSpacing: 20,
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemBuilder: (context, index) {
                                        ProductModel singleProduct =
                                            searchList[index];
                                        // print(singleProduct.ml);

                                        return productList.isEmpty
                                            ? const Center(
                                                child: Text(
                                                    "There are no products"),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0),
                                                      child: Text(
                                                        singleProduct.name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                                singleProduct:
                                                                    singleProduct),
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
                              : productList.isEmpty
                                  ? const Center(
                                      child: Text("Best Product is empty"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: GridView.builder(
                                          padding: EdgeInsets.only(bottom: 50),
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
                                            ProductModel singleProduct =
                                                productList[index];
                                            // print(singleProduct.ml);

                                            return productList.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                        "There are no products"),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
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
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: Text(
                                                            singleProduct.name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                              Routes.instance
                                                                  .push(
                                                                ProductDetail(
                                                                    singleProduct:
                                                                        singleProduct),
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
                                    ),
                      const SizedBox(
                        height: 12.0,
                      ),
                    ]),
              ));
  }

  bool isSearched() {
    if (search.text.isNotEmpty && searchList.isEmpty) {
      return true;
    } else if (search.text.isEmpty && searchList.isNotEmpty) {
      return false;
    } else if (searchList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
// List<String> categoryList = [
//   "https://cdn.picpng.com/alcohol/alcohol-booze-bottle-cartoon-42114.png",
//   "https://images.vexels.com/media/users/3/189391/isolated/lists/e4513d512d0eaf8d1081f490b693ac36-wine-bottle-glass-icon-stroke.png",
//   "https://cdn.picpng.com/alcohol/alcohol-booze-bottle-cartoon-42114.png",
//   "https://images.vexels.com/media/users/3/189391/isolated/lists/e4513d512d0eaf8d1081f490b693ac36-wine-bottle-glass-icon-stroke.png",
// ];

// List<ProductModel> bestProducts = [
//   ProductModel(
//     image:
//         "https://cdn.picpng.com/alcohol/alcohol-booze-bottle-cartoon-42114.png",
//     id: "1",
//     name: "Products 1",
//     price: 9.99,
//     ml: 75,
//     description: "nrksjt bkrtjgnlw oelng kjngoiq34ng hng4",
//     isFavourite: false,
//   ),
//   ProductModel(
//     image:
//         "https://images.vexels.com/media/users/3/189391/isolated/lists/e4513d512d0eaf8d1081f490b693ac36-wine-bottle-glass-icon-stroke.png",
//     id: "2",
//     name: "Products 2",
//     price: 9.99,
//     ml: 75,
//     description: "nrksjt bkrtjgnlw oelng kjngoiq34ng hng4",
//     isFavourite: false,
//   ),
//   ProductModel(
//     image:
//         "https://cdn.picpng.com/alcohol/alcohol-booze-bottle-cartoon-42114.png",
//     id: "3",
//     name: "Products 3",
//     price: 9.99,
//     ml: 75,
//     description: "nrksjt bkrtjgnlw oelng kjngoiq34ng hng4",
//     isFavourite: false,
//   ),
//   ProductModel(
//     image:
//         "https://images.vexels.com/media/users/3/189391/isolated/lists/e4513d512d0eaf8d1081f490b693ac36-wine-bottle-glass-icon-stroke.png",
//     id: "4",
//     name: "Products 4",
//     price: 9.99,
//     ml: 75,
//     description: "nrksjt bkrtjgnlw oelng kjngoiq34ng hng4",
//     isFavourite: false,
//   ),
//   ProductModel(
//     image:
//         "https://cdn.picpng.com/alcohol/alcohol-booze-bottle-cartoon-42114.png",
//     id: "5",
//     name: "Products 5",
//     price: 10.34,
//     ml: 75,
//     description: "nrksjt bkrtjgnlw oelng kjngoiq34ng hng4",
//     isFavourite: false,
//   ),
//   ProductModel(
//     image:
//         "https://images.vexels.com/media/users/3/189391/isolated/lists/e4513d512d0eaf8d1081f490b693ac36-wine-bottle-glass-icon-stroke.png",
//     id: "2",
//     name: "Products 6",
//     price: 4.99,
//     ml: 75,
//     description: "nrksjt bkrtjgnlw oelng kjngoiq34ng hng4",
//     isFavourite: false,
//   ),
// ];

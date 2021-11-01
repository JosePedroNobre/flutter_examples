import 'package:customer/constants/shadows.dart';
import 'package:customer/constants/styles.dart';
import 'package:customer/network/model/product.dart';
import 'package:customer/network/model/sub_category.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:customer/network/model/category.dart' as C;

class StoreInfoScreen extends StatefulWidget {
  StoreInfoScreen({Key key}) : super(key: key);

  @override
  _StoreInfoScreenState createState() => _StoreInfoScreenState();
}

class _StoreInfoScreenState extends State<StoreInfoScreen> {
  bool isSearchBarActive = false;
  TextEditingController searchBarController = TextEditingController();
  C.Category selectedCategory = C.Category.FEATURED;
  SubCategory selectedSubCategory;
  List<SubCategory> subCategories = [
    SubCategory(
        category: C.Category.BREAKFAST,
        name: "Sub Category 1",
        image:
            "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg",
        products: [
          Product(
            name: "Cheese burger",
            description: "Yummy cheese burger!",
            category: C.Category.BREAKFAST,
            isRecommended: true,
            price: "4,50€",
            image:
                "https://upload.wikimedia.org/wikipedia/commons/1/11/Cheeseburger.png",
          ),
          Product(
            name: "Pizza",
            description: "Yummy Pizza!",
            category: C.Category.BREAKFAST,
            isRecommended: true,
            price: "11,50€",
            image: "https://pngimg.com/uploads/pizza/pizza_PNG43985.png",
          ),
        ]),
    SubCategory(
        category: C.Category.LUNCH,
        name: "Sub Category 1",
        image:
            "https://simply-delicious-food.com/wp-content/uploads/2018/07/mexican-lunch-bowls-3.jpg",
        products: [
          Product(
            name: "Cheese burger",
            description: "Yummy cheese burger!",
            category: C.Category.LUNCH,
            isRecommended: true,
            price: "4,50€",
            image:
                "https://upload.wikimedia.org/wikipedia/commons/1/11/Cheeseburger.png",
          ),
        ]),
    SubCategory(
        category: C.Category.LUNCH,
        name: "Sub Category 1",
        image:
            "https://simply-delicious-food.com/wp-content/uploads/2018/07/mexican-lunch-bowls-3.jpg",
        products: [
          Product(
            name: "Cheese burger",
            description: "Yummy cheese burger!",
            category: C.Category.LUNCH,
            isRecommended: true,
            price: "4,50€",
            image:
                "https://upload.wikimedia.org/wikipedia/commons/1/11/Cheeseburger.png",
          ),
        ]),
    SubCategory(
        category: C.Category.LUNCH,
        name: "Sub Category 1",
        image:
            "https://simply-delicious-food.com/wp-content/uploads/2018/07/mexican-lunch-bowls-3.jpg",
        products: [
          Product(
            name: "Cheese burger",
            description: "Yummy cheese burger!",
            category: C.Category.LUNCH,
            isRecommended: true,
            price: "4,50€",
            image:
                "https://upload.wikimedia.org/wikipedia/commons/1/11/Cheeseburger.png",
          ),
        ]),
    SubCategory(
        category: C.Category.LUNCH,
        name: "Sub Category 1",
        image:
            "https://simply-delicious-food.com/wp-content/uploads/2018/07/mexican-lunch-bowls-3.jpg",
        products: [
          Product(
            name: "Cheese burger",
            description: "Yummy cheese burger!",
            category: C.Category.LUNCH,
            isRecommended: true,
            price: "4,50€",
            image:
                "https://upload.wikimedia.org/wikipedia/commons/1/11/Cheeseburger.png",
          ),
        ]),
    SubCategory(
        category: C.Category.LUNCH,
        name: "Sub Category 1",
        image:
            "https://simply-delicious-food.com/wp-content/uploads/2018/07/mexican-lunch-bowls-3.jpg",
        products: [
          Product(
            name: "Cheese burger",
            description: "Yummy cheese burger!",
            category: C.Category.LUNCH,
            isRecommended: true,
            price: "4,50€",
            image:
                "https://upload.wikimedia.org/wikipedia/commons/1/11/Cheeseburger.png",
          ),
        ]),
    SubCategory(
        category: C.Category.LUNCH,
        name: "Sub Category 1",
        image:
            "https://simply-delicious-food.com/wp-content/uploads/2018/07/mexican-lunch-bowls-3.jpg",
        products: [
          Product(
            name: "Cheese burger",
            description: "Yummy cheese burger!",
            category: C.Category.LUNCH,
            isRecommended: true,
            price: "4,50€",
            image:
                "https://upload.wikimedia.org/wikipedia/commons/1/11/Cheeseburger.png",
          ),
        ]),
    SubCategory(
        category: C.Category.LUNCH,
        name: "Sub Category 1",
        image:
            "https://simply-delicious-food.com/wp-content/uploads/2018/07/mexican-lunch-bowls-3.jpg",
        products: [
          Product(
            name: "Cheese burger",
            description: "Yummy cheese burger!",
            category: C.Category.LUNCH,
            isRecommended: true,
            price: "4,50€",
            image:
                "https://upload.wikimedia.org/wikipedia/commons/1/11/Cheeseburger.png",
          ),
        ]),
    SubCategory(
        category: C.Category.DINNER,
        name: "Sub Category 1",
        image:
            "https://cdn.loveandlemons.com/wp-content/uploads/2018/01/lunch-ideas-500x500.jpg",
        products: [
          Product(
            name: "Pizza",
            description: "Yummy Pizza!",
            category: C.Category.DINNER,
            isRecommended: true,
            isOutOfStock: true,
            price: "11,50€",
            image: "https://pngimg.com/uploads/pizza/pizza_PNG43985.png",
          ),
        ]),
    SubCategory(
        category: C.Category.FEATURED,
        name: "Sub Category 1",
        image:
            "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg",
        products: [
          Product(
            name: "Cheese burger",
            description: "Yummy cheese burger!",
            category: C.Category.FEATURED,
            isRecommended: true,
            isOutOfStock: true,
            price: "4,50€",
            image:
                "https://upload.wikimedia.org/wikipedia/commons/1/11/Cheeseburger.png",
          ),
          Product(
            name: "Pizza",
            description: "Yummy Pizza!",
            category: C.Category.FEATURED,
            isRecommended: true,
            price: "11,50€",
            image: "https://pngimg.com/uploads/pizza/pizza_PNG43985.png",
          ),
        ]),
  ];

  @override
  void initState() {
    searchBarController.addListener(() {
      setState(() {
        if (searchBarController.text.isNotEmpty) {
          selectedCategory = null;
          selectedSubCategory = null;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Image.asset(
          "images/labs_logo.png",
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    List<Product> products = selectedSubCategory != null
        ? subCategories
            .where((element) => element.category == selectedCategory)
            .map((e) => e.products)
            .expand((element) => element)
            .toList()
        : subCategories
            .map((e) => e.products)
            .expand((element) => element)
            .where((element) => (element?.name ?? "")
                .toLowerCase()
                .contains(searchBarController.text.toLowerCase()))
            .toList();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _searchBar(),
            _buildCategories(),
            (selectedSubCategory == null) && (selectedCategory != null)
                ? _buildFeatured()
                : _buildProductList(products,
                    subCategoryName: selectedSubCategory?.name),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Color(0XFFF1F3F5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
          controller: searchBarController,
          style: font2(
            size: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Color(0XFFADB5BD),
              size: 24,
            ),
            suffixIcon: Visibility(
              visible: searchBarController.text.isNotEmpty,
              child: InkWell(
                onTap: () => searchBarController.clear(),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
            hintText: "Search for a product...",
            hintStyle: font2(
              size: 16,
              fontWeight: FontWeight.w400,
              color: Color(0XFFADB5BD),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    List<C.Category> categories = C.Category.values;
    return Container(
      height: 31,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 24, right: 24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          C.Category category = categories[index];
          return _categoryChip(category, selectedCategory == category);
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 12);
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _categoryChip(C.Category category, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = category;
          selectedSubCategory = null;
          searchBarController.clear();
          FocusScope.of(context).unfocus();
        });
      },
      child: Container(
        height: 31,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Color(0XFFF1F3F5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(category.icon()),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  category.name(),
                  style: font2(
                    size: 12,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? Colors.white : Color(0XFF4F575E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatured() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 32, bottom: 20),
          child: Text(
            "Recommended products",
            style: font2(
              size: 14,
              fontWeight: FontWeight.w400,
              color: Color(0XFF4F575E),
            ),
          ),
        ),
        _buildRecommendedList(),
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 32, bottom: 20),
          child: Text(
            "Top categories",
            style: font2(
              size: 14,
              fontWeight: FontWeight.w400,
              color: Color(0XFF4F575E),
            ),
          ),
        ),
        _buildSubCategoryList(
          subCategories
              .where((element) => element.category == selectedCategory)
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendedList() {
    List<Product> recommendedProducts = subCategories
        .where((element) => element.category == selectedCategory)
        .map((e) => e.products)
        .expand((element) => element)
        .where((element) => element.isRecommended)
        .toList();
    return Container(
      height: 204,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 24, right: 24),
        itemCount: recommendedProducts.length,
        itemBuilder: (context, index) {
          Product product = recommendedProducts[index];
          return _buildRecommendedProduct(product);
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 12);
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildRecommendedProduct(Product product) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [primaryShadow()],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Image.network(product.image),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Text(
                product.name,
                style: font2(
                  color: Color(0XFF4F575E),
                  size: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                product.price,
                style: font2(
                  color: Color(0XFF4F575E),
                  size: 14,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategoryList(List<SubCategory> subCategories) {
    return Column(
      children: [
        ...subCategories.map((e) => _buildSubCategoryListItem(e)).toList(),
      ],
    );
  }

  Widget _buildSubCategoryListItem(SubCategory subCategory) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedSubCategory = subCategory;
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: NetworkImage(subCategory.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
                child: Text(
              subCategory.name,
              style: font2(
                size: 16,
                fontWeight: FontWeight.w400,
                color: Color(0XFF4F575E),
              ),
            )),
            SizedBox(width: 16),
            Icon(Icons.chevron_right, color: Color(0XFF4F575E)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(List<Product> products, {String subCategoryName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Text(
            subCategoryName != null && subCategoryName.isNotEmpty
                ? products.length > 0
                    ? "${products.length} Results"
                    : "No Results"
                : products.length > 0
                    ? "${products.length} Results at $subCategoryName"
                    : "No Results",
            style: font2(
              size: 12,
              fontWeight: FontWeight.w400,
              color: Color(0XFFADB5BD),
            ),
          ),
        ),
        ...products.map((e) => _buildProductListItem(e)),
      ],
    );
  }

  Widget _buildProductListItem(Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: NetworkImage(product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: font2(
                    size: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF4F575E),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  product.description,
                  style: font2(
                    size: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0XFFADB5BD),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (product.isOutOfStock)
                  Text(
                    "Out of stock",
                    style: font2(
                      size: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFFFB5354),
                    ),
                  ),
                SizedBox(height: 2),
                Text(
                  product.price,
                  style: font2(
                    color: Color(0XFFADB5BD),
                    size: 14,
                    fontWeight: FontWeight.w100,
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

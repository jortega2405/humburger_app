import 'package:bom_hamburguer/helpers/db_helper.dart';
import 'package:bom_hamburguer/models/cart_model.dart';
import 'package:bom_hamburguer/models/item_model.dart';
import 'package:bom_hamburguer/providers/provider.dart';
import 'package:bom_hamburguer/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;


class MenuScreen extends StatelessWidget {
   MenuScreen({super.key,});

  final Set<int> hamburgersAdded = {};
  final Set<int> extrasAdded = {};
  final Set<int> drinksAdded = {};

  @override
  Widget build(BuildContext context) {

    DBHelper dbHelper = DBHelper();
    
    List<Item> products = [
      Item(
        image: 'assets/images/hamburger.png',
        name: 'X Burger',
        price: 5.00,
        type: ItemType.hamburger,
      ),
      Item(
        type: ItemType.hamburger,
        image: 'assets/images/egg.png',
        name: 'X Egg',
        price: 4.50,
      ),
      Item(
        type: ItemType.hamburger,
        image: 'assets/images/bacon.png',
        name: 'X Bacon',
        price: 7.00,
      ),
    ];

  List<Item> extras = [
      Item(
        type: ItemType.extra,
        image: 'assets/images/fries.png',
        name: 'Fries',
        price:  2.00 ,
        
      ),
      Item(
        type: ItemType.drink,
        image: 'assets/images/soft_drink.png',
        name: 'Soft Drink',
        price: 2.50,
      ),
  ];
  
  final cart = Provider.of<CartProvider>(context);
    
  void saveProducts(int index) async{
    final product = products[index];    
    var list = await dbHelper.getCartListByType(product.type.name);
if (list.isNotEmpty) {
      Fluttertoast.showToast(
        msg:"There is an item of this type in the cart already and you can't add more.",
        textColor: Colors.white,
        backgroundColor: Colors.transparent.withOpacity(0.2),
        timeInSecForIosWeb: 5
      );
      return;
    }

    dbHelper.insert(
      Cart(
        id: index.toString(),
        productId: index,
        productName: product.name,
        initialPrice: product.price,
        productPrice: product.price,
        image: product.image,
        type: product.type.name,
      ),
    ).then((value) {
      // agregar el ID del elemento al conjunto correspondiente
      if (product.type == ItemType.hamburger) {
        hamburgersAdded.add(index);
      } else if (product.type == ItemType.extra) {
        extrasAdded.add(index);
      } else if (product.type == ItemType.drink) {
        drinksAdded.add(index);
      }

      cart.addTotalPrice(product.price.toDouble());
      cart.addCounter();
      Fluttertoast.showToast(
        msg:'Product Added to cart',
        textColor: Colors.white,
        backgroundColor: Colors.transparent.withOpacity(0.2),
      );
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }
    
    void saveExtras(int index) async{
      final product = extras[index];
         // ignore: unused_local_variable
    var list = await dbHelper.getCartListByType(product.type.name);
if (list.isNotEmpty) {
      Fluttertoast.showToast(
        msg:"There is an item of this type in the cart already and you can't add more.",
        textColor: Colors.white,
        backgroundColor: Colors.transparent.withOpacity(0.2),
      );
      return;
    }
      dbHelper.insert(
        Cart(
          id: index.toString(),
          productId: index,
          productName: extras[index].name,
          initialPrice: extras[index].price,
          productPrice: extras[index].price,
          image: extras[index].image,
          type: extras[index].type.name,
        ),
      ).then((value) {
        cart.addTotalPrice(extras[index].price.toDouble()); // use extras[index].price instead of products[index].price
        cart.addCounter();
        print('Extra Added to cart');
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: 
          AppBar(
            centerTitle: true,
            title: const Text('Menu'),
            actions: [
              badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                position:  badges.BadgePosition.bottomStart(start: 30, bottom: 30),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartScreen()));
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
            ],
            ),
      body: Column(
        children: [
          const Text(
            'Hamburgers',
            style: TextStyle(
              fontSize: 24
            ),
            textAlign: TextAlign.start,
          ),
          ListView.builder(
           padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
           shrinkWrap: true,
           itemCount: products.length,
           itemBuilder: (context, index) {
           return Card(
             color: Colors.transparent.withOpacity(0.2),
             elevation: 5.0,
             child: Padding(
               padding: const EdgeInsets.all(4.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 mainAxisSize: MainAxisSize.max,
                 children: [
                   Image(
                     height: 80,
                     width: 80,
                     image: AssetImage(products[index].image.toString()),
                   ),
                   SizedBox(
                     width: 130,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const SizedBox(
                           height: 5.0,
                         ),
                         RichText(
                           overflow: TextOverflow.ellipsis,
                           maxLines: 1,
                           text: TextSpan(
                               text: 'Name: ',
                               style: const TextStyle(
                                   color: Color.fromARGB(255, 219, 229, 234),
                                   fontSize: 16.0),
                               children: [
                                 TextSpan(
                                     text:
                                         '${products[index].name.toString()}\n',
                                     style: const TextStyle(
                                         fontWeight: FontWeight.bold)),
                               ]),
                         ),
                         RichText(
                           maxLines: 1,
                           text: TextSpan(
                               text: 'Price: ' r"$",
                               style:const  TextStyle(
                                   color: Color.fromARGB(255, 219, 229, 234),
                                   fontSize: 16.0),
                               children: [
                                 TextSpan(
                                     text:
                                         '${products[index].price.toString()}\n',
                                     style: const TextStyle(
                                         fontWeight: FontWeight.bold)),
                               ]),
                         ),
                       ],
                     ),
                   ),
                   ElevatedButton(
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.blueGrey.shade900),
                       onPressed: () {
                         saveProducts(index);
                       },
                       child: const Icon(Icons.add)),
                 ],
               ),
             ),
           );
           }
          ),
          const Text(
            'Extras',
            style: TextStyle(
              fontSize: 24
            ),
            textAlign: TextAlign.start,
          ),
          ListView.builder(
           padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
           shrinkWrap: true,
           itemCount: extras.length,
           itemBuilder: (context, index) {
           return Card(
             color: Colors.transparent.withOpacity(0.2),
             elevation: 5.0,
             child: Padding(
               padding: const EdgeInsets.all(4.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 mainAxisSize: MainAxisSize.max,
                 children: [
                   Image(
                     height: 80,
                     width: 80,
                     image: AssetImage(extras[index].image.toString()),
                   ),
                   SizedBox(
                     width: 130,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const SizedBox(
                           height: 5.0,
                         ),
                         RichText(
                           overflow: TextOverflow.ellipsis,
                           maxLines: 1,
                           text: TextSpan(
                               text: 'Name: ',
                               style: const TextStyle(
                                   color: Color.fromARGB(255, 219, 229, 234),
                                   fontSize: 16.0),
                               children: [
                                 TextSpan(
                                     text:
                                         '${extras[index].name.toString()}\n',
                                     style: const TextStyle(
                                         fontWeight: FontWeight.bold)),
                               ]),
                         ),
                         RichText(
                           maxLines: 1,
                           text: TextSpan(
                               text: 'Price: ' r"$",
                               style: const TextStyle(
                                   color: Color.fromARGB(255, 219, 229, 234),
                                   fontSize: 16.0),
                               children: [
                                 TextSpan(
                                     text:
                                         '${extras[index].price.toString()}\n',
                                     style: const TextStyle(
                                         fontWeight: FontWeight.bold)),
                               ]),
                         ),
                       ],
                     ),
                   ),
                   ElevatedButton(
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.blueGrey.shade900),
                       onPressed: () {
                         saveExtras(index);
                       },
                       child: const Icon(Icons.add)),
                 ],
               ),
             ),
           );
           }
          ),
        ],
      ),
      ),
    );
  }
}

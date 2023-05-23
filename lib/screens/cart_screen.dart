import 'package:badges/badges.dart' as badges;
import 'package:bom_hamburguer/models/item_model.dart';
import 'package:bom_hamburguer/widgets/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../helpers/db_helper.dart';
import '../providers/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  double total = 0;
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String sign = r"$"; 

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    void _showOrderModal(BuildContext context, double total) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Total to pay: $sign ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _textController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction ,
                            decoration: const InputDecoration(
                              labelText: 'Enter Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Fluttertoast.showToast(msg: 'Order placed successfully', );
                                }
                                _textController.clear();
                                Navigator.pop(context);                       
                              },
                              child: const Text('Place Order'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('My Shopping Cart'),
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
              position: badges.BadgePosition.bottomStart(start: 30, bottom: 30),
              child: IconButton(
                onPressed: () {},
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
            Expanded(
              child: Consumer<CartProvider>(
                builder: (BuildContext context, provider, widget) {
                  if (provider.cart.isEmpty) {
                    return const Center(
                        child: Text(
                      'Your Cart is Empty',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ));
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.cart.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.transparent.withOpacity(0.2),
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Image(
                                    height: 80,
                                    width: 80,
                                    image:
                                        AssetImage(provider.cart[index].image!),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  color: Color.fromARGB(
                                                      255, 219, 229, 234),
                                                  fontSize: 16.0),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '${provider.cart[index].productName!}\n',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ]),
                                        ),
                                        RichText(
                                          maxLines: 1,
                                          text: TextSpan(
                                              text: 'Price: ' r"$",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 219, 229, 234),
                                                  fontSize: 16.0),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '${provider.cart[index].productPrice!}\n',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        dbHelper!.deleteCartItem(
                                            provider.cart[index].id!);
                                        provider.removeItem(
                                            provider.cart[index].id!);
                                        provider.removeCounter();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red.shade800,
                                      )),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            ),
            Consumer<CartProvider>(
              builder: (BuildContext context, value, Widget? child) {

               
              
                final ValueNotifier<Map<String,dynamic> ?> totalPrice = ValueNotifier({});


                double discount = 0;

                var listHamburger =
                    value.cart.where((e) => e.type == ItemType.hamburger.name);

                var listFries =
                    value.cart.where((e) => e.type == ItemType.extra.name);

                var listDrinks =
                    value.cart.where((e) => e.type == ItemType.drink.name);

                if (value.cart.length == 2 &&
                    listHamburger.isNotEmpty &&
                    listFries.isNotEmpty) {
                  discount = 0.1;
                } else if (value.cart.length == 2 &&
                    listHamburger.isNotEmpty &&
                    listDrinks.isNotEmpty) {
                  discount = 0.15;
                } else if (value.cart.length == 3) {
                  discount = 0.3;
                }
                double sum = 0;
                for (var element in value.cart) {
                  sum+= element.productPrice!;
                }
                total = sum - (sum * discount);
                totalPrice.value!['price'] = sum;
                totalPrice.value!['discount'] = sum * discount;
                totalPrice.value!['total'] = total;


                  final cart = Provider.of<CartProvider>(context);
                 // cart.addTotalPrice(total - (total * discount));

                return Column(
                  children: [
                    ValueListenableBuilder<Map<String,dynamic>?>(
                        valueListenable: totalPrice,
                        builder: (context, val, child) {
                          return Column(
                            children: [
                              SubTotalWidget(
                                  title: 'Sub-Total',
                                  value:
                                      r'$' + (val!['price'].toStringAsFixed(2) ?? '0')),
                              SubTotalWidget(
                                title: 'Discount',
                                value: r'$' + (val!['discount'].toStringAsFixed(2) ?? '0'),
                              ),
                              SubTotalWidget(
                                title: 'Total',
                                value: r'$' + (val!['total'].toStringAsFixed(2) ?? '0'),
                              )
                            ],
                          );
                        }),
                  ],
                );
              },
            )
          ],
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            _showOrderModal(context, total);
          },
          child: Container(
            color: Colors.yellow.shade600,
            alignment: Alignment.center,
            height: 50.0,
            child: const Text(
              'Proceed to Pay',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}





import 'dart:ffi';

import 'package:flutter/widgets.dart';

class Cart {
  String? id;
 final int? productId;
 final String? productName;
 final double? initialPrice;
 final double? productPrice;
 final String? image;
 final String? type;

 Cart(  
     {
      required this.id,
     required this.productId,
     required this.productName,
     required this.initialPrice,
     required this.productPrice,
     required this.image,
     required this.type,
     }
 );

 Cart.fromMap(Map<dynamic, dynamic> data)
     : id = data['id'],
       productId = data['productId'],
       productName = data['productName'],
       initialPrice = data['initialPrice'],
       productPrice = data['productPrice'],
       image = data['image'],
       type = data['type'];


 Map<String, dynamic> toMap() {
   return {
     'id': id,
     'productId': productId,
     'productName': productName,
     'initialPrice': initialPrice,
     'productPrice': productPrice,
     'image': image,
     'type': type
   };
 }
}
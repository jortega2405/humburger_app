class Item {
 final String name;
 final double price;
 final String image;
 final ItemType type;

 Item({required this.name, required this.price, required this.image, required this.type});

 Map toJson() {
   return {
     'name': name,
     'price': price,
     'image': image,
     'type': type.toString().split('.').last,
   };
 }
}

enum ItemType {
  drink,
  extra,
  hamburger
}

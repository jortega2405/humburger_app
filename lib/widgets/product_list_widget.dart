
import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  final String name;
  final double price;
  final Function onTap;
  final String leading;

  const ProductListItem({super.key, 
    required this.name,
    required this.price,
    required this.onTap,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(leading),
        radius: 40,

      ),
      title: Text(name),
      subtitle: Text('\$$price'),
      trailing: ElevatedButton(
        onPressed: () {
          onTap();
        },
        child: const Text('Agregar'),
      ),
    );
  }
}
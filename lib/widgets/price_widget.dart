
import 'package:flutter/material.dart';

class SubTotalWidget extends StatelessWidget {
 final String title, value;
 const SubTotalWidget({Key? key, required this.title, required this.value});

 @override
 Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Column(
       children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(
               title,
               style: Theme.of(context).textTheme.titleMedium,
             ),
             Text(
               value.toString(),
               style: Theme.of(context).textTheme.titleSmall,
             ),
           ],
         ),
       ],
     ),
   );
 }
}
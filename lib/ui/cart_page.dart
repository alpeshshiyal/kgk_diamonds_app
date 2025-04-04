import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../model/diamond.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Diamond> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    cartItems = await DatabaseHelper().getCartItems();
    setState(() {});
  }

  Future<void> removeFromCart(String lotId) async {
    await DatabaseHelper().removeDiamond(lotId);
    loadCart();
  }

  Future<Map<String, dynamic>> calculateSummary(List<Diamond> diamonds) async {
    double totalCarat = diamonds.fold(0.0, (sum, d) => sum + (d.carat ?? 0.0));
    double totalPrice = diamonds.fold(0.0, (sum, d) => sum + (d.finalAmount ?? 0.0));
    double avgPrice = diamonds.isNotEmpty ? totalPrice / diamonds.length : 0.0;
    double avgDiscount = diamonds.isNotEmpty
        ? diamonds.fold(0.0, (sum, d) => sum + (d.discount ?? 0.0)) / diamonds.length
        : 0.0;

    return {
      'totalCarat': totalCarat,
      'totalPrice': totalPrice,
      'avgPrice': avgPrice,
      'avgDiscount': avgDiscount,
    };
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Builder(
        builder: (context) {
          if (cartItems.isEmpty) {
            return const Center(child: Text('No any items are added yet in cart !'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final diamond = cartItems[index];
                    return ListTile(
                      title: Text('Lab: ${diamond.lab} - Carat: ${diamond.carat} ct'),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Shape: ${diamond.shape}'),
                                Text('Color: ${diamond.color}'),
                                Text('Clarity: ${diamond.clarity}'),
                                Text('Discount: ${diamond.discount}'),
                              ],
                            ),
                          ),
                          Text('Price: ${diamond.finalAmount}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () => removeFromCart(diamond.lotId!),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FutureBuilder<Map<String, dynamic>>(
                  future: calculateSummary(cartItems),
                  builder: (context, summarySnapshot) {
                    if (!summarySnapshot.hasData) return const SizedBox();
                    final summary = summarySnapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildSummeryRow(
                            title: 'Total Carat:',
                            value: summary['totalCarat'].toStringAsFixed(2),
                          ),
                          buildSummeryRow(
                              title:'Total Price:',
                              value: '\$${summary['totalPrice'].toStringAsFixed(2)}',
                          ),
                          buildSummeryRow(
                              title:'Average Price:',
                              value:'\$${summary['avgPrice'].toStringAsFixed(2)}'
                          ),
                          buildSummeryRow(
                            title:'Average Discount:',
                            value:'${summary['avgDiscount'].toStringAsFixed(2)}%'
                          ),
                        ]
                      )
                    );
                  },
                ),
              ),
              const SizedBox(height: 20,)
            ],
          );
        }
      ),
    );
  }

  Row buildSummeryRow({String? title,String? value}) {
    var titleStyle = const TextStyle(fontWeight: FontWeight.bold);
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Text(title??"",style: titleStyle,),
               Text(value??"",)
              ],
            );
  }
}
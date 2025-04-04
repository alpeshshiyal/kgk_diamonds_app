
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kgk_diamonds_app/ui/cart_page.dart';
import 'package:kgk_diamonds_app/ui/result_page.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import '../bloc/diamond_bloc.dart';
import '../bloc/events.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController labController = TextEditingController(text: "GIA");
  final TextEditingController shapeController = TextEditingController(text: "BR");
  final TextEditingController colorController = TextEditingController(text: "D");
  final TextEditingController clarityController = TextEditingController(text: "VVS1");
  final _minCaratController = TextEditingController(text: "0.1");
  final _maxCaratController = TextEditingController(text: "2.0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KGK Diamonds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(controller: labController, decoration: const InputDecoration(labelText: 'Lab')),
                  TextField(controller: shapeController, decoration: const InputDecoration(labelText: 'Shape')),
                  TextField(controller: colorController, decoration: const InputDecoration(labelText: 'Color')),
                  TextField(controller: clarityController, decoration: const InputDecoration(labelText: 'Clarity')),
                  TextField(
                    controller: _minCaratController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Min Carat'),
                  ),
                  TextField(
                    controller: _maxCaratController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Max Carat'),
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // context.read<DiamondFilterBloc>().add(
                  //     //   ApplyFilterEvent(
                  //     //     lab: labController.text,
                  //     //     shape: shapeController.text,
                  //     //     color: colorController.text,
                  //     //     clarity: clarityController.text,
                  //     //   ),
                  //     // );
                  //     //
                  //     context.read<DiamondFilterBloc>().add(
                  //       ApplyFilterEvent(
                  //         lab: labController.text,
                  //         shape: shapeController.text,
                  //         color: colorController.text,
                  //         clarity: clarityController.text,
                  //       ),
                  //     );
                  //   },
                  //   child: const Text('Search'),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      double? minCarat = double.tryParse(_minCaratController.text);
                      double? maxCarat = double.tryParse(_maxCaratController.text);
                      context.read<DiamondFilterBloc>().applyFilters(
                          minCarat,
                          maxCarat,
                          labController.text,
                          shapeController.text,
                          colorController.text,
                          clarityController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResultPage()),
                      );
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            ),
            BlocBuilder<DiamondFilterBloc, DiamondFilterState>(
              builder: (context, state) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.diamonds.length,
                  itemBuilder: (context, index) {
                    final diamond = state.diamonds[index];
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
                              ],
                            ),
                          ),
                          Text('Price: ${diamond.finalAmount}'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
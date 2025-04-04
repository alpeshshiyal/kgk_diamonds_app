import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_diamonds_app/bloc/events.dart';
import '../bloc/diamond_bloc.dart';
import '../database/database_helper.dart';
import '../utils/show_message.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtered Diamonds'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              context.read<DiamondFilterBloc>().sortDiamonds(value, true);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Price', child: Text('Sort by Price')),
              const PopupMenuItem(value: 'Carat', child: Text('Sort by Carat')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<DiamondFilterBloc, DiamondFilterState>(
        builder: (context, state) {
          var diamonds = state.filteredDiamonds;
          if (diamonds.isEmpty) {
            return const Center(child: Text('No diamonds found. Try adjusting your filters.'));
          }
          debugPrint("result list:${diamonds}");
          return ListView.builder(
            itemCount: diamonds.length,
            itemBuilder: (context, index) {
              final diamond = diamonds[index];
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
                trailing: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () async {
                    await DatabaseHelper().insertDiamond(diamond);
                    SnackBarUtil.showMessage(context, "Added to cart !");
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
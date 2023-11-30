import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_is_good/models/cart.dart';
import 'package:study_is_good/models/catalog.dart';
import 'package:study_is_good/shops/cart_page.dart';

class MyCatalog extends StatelessWidget {
  const MyCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: CustomScrollView(
      //   slivers: [
      //     _MyAppBar(),
      //     const SliverToBoxAdapter(child: SizedBox(height: 12)),
      //     // SliverList(
      //     //   delegate: SliverChildBuilderDelegate(
      //     //           (context, index) => _MyListItem(index)),
      //     // ),
      //     ListView.builder(
      //       itemCount: CatalogModel.itemNames.length,
      //       // prototypeItem: _MyListItem(index),
      //       itemBuilder: (context, index) {
      //         return _MyListItem(index);
      //       },
      //     ),
      //   ],
      // ),
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: [
          IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCart())),
              }
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: CatalogModel.itemNames.length,
        itemBuilder: (context, index) {
          return _MyListItem(index);
        },
      ),
    );

  }
}

class _AddButton extends StatelessWidget {
  final Item item;
  const _AddButton({required this.item});

  @override
  Widget build(BuildContext context) {
    var isInCart = context.select<CartModel, bool>(
      // Here, we are only interested whether [item] is inside the cart.
          (cart) => cart.items.contains(item),
    );

    return TextButton(
      onPressed: isInCart
          ? null
          : () {
        var cart = context.read<CartModel>();
        cart.add(item);
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: isInCart
          ? const Icon(Icons.check, semanticLabel: 'ADDED')
          : const Text('ADD'),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text('Catalog'),
      floating: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCart())),
          }
        ),
      ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;
  const _MyListItem(this.index);

  @override
  Widget build(BuildContext context) {
    var item = context.select<CatalogModel, Item>(
      // Here, we are only interested in the item at [index]. We don't care
      // about any other change.
          (catalog) => catalog.getByPosition(index),
    );
    var textTheme = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                //color: item.color,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(item.name, style: textTheme),
            ),
            const SizedBox(width: 24),
            _AddButton(item: item),
          ],
        ),
      ),
    );
  }
}
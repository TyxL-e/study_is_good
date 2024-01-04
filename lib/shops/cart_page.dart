import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_is_good/main.dart';
import 'package:study_is_good/models/cart.dart';
import 'package:study_is_good/models/catalog.dart';


class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    final  usersStream =
    FirebaseFirestore.instance
        .collection("StudyIsGood")
        .doc("Players")
        .collection("All Users").doc(auth.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.displayMedium),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: usersStream.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            color: Colors.yellow,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: _CartList(),
                  ),
                ),
                const Divider(height: 4, color: Colors.black),
                _CartTotal(snapshot.data!.data()!["points"]),
              ],
            ),
          );
        }
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.titleLarge;
    // This gets the current state of CartModel and also tells Flutter
    // to rebuild this widget when CartModel notifies listeners (in other words,
    // when it changes).
    var cart = context.watch<CartModel>();

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.done),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            cart.remove(cart.items[index]);
          },
        ),
        title: Text(
          cart.items[index].name,
          style: itemNameStyle,
        ),
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {

  const _CartTotal(this.userMoney);
  final int userMoney;

  @override
  Widget build(BuildContext context) {
    var hugeStyle = Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 48);
    int cartAmount = 0;
    List cartItems = [];
    List<String> cartItemsNames = [];

    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Your current Money amount: $userMoney",style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 20)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Another way to listen to a model's change is to include
                // the Consumer widget. This widget will automatically listen
                // to CartModel and rerun its builder on every change.
                //
                // The important thing is that it will not rebuild
                // the rest of the widgets in this build method.
                Consumer<CartModel>(
                    builder: (context, cart, child) {
                      cartAmount = cart.totalPrice;
                      cartItems = cart.items;
                      for (Item item in cartItems) {
                        cartItemsNames.add(item.name);
                      }
                      return Text('\$${cart.totalPrice}', style: hugeStyle);
                    }
                ),
                const SizedBox(width: 24),
                FilledButton(
                  onPressed: () async {
                    if (userMoney < cartAmount) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('You do not have enough to purchase these contents')));
                    }
                    else {
                      try {
                        // Get the existing banner items
                        final docRef = FirebaseFirestore.instance
                            .collection("StudyIsGood")
                            .doc("Players")
                            .collection("All Users")
                            .doc(auth!.currentUser!.uid);
                        final docSnapshot = await docRef.get();
                        final existingBannerItems;
                        docSnapshot.data()!["banner"] == null ?
                        existingBannerItems = [] : existingBannerItems = docSnapshot.data()!["banner"] as List;

                        // Check for duplicates
                        final newItems = cartItemsNames.where((item) => !existingBannerItems.contains(item)).toList();
                        if (newItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You already have all of these items.')),
                          );
                          return; // Exit early if no new items to add
                        }

                        await FirebaseFirestore.instance
                            .collection("StudyIsGood")
                            .doc("Players")
                            .collection("All Users")
                            .doc(auth!.currentUser!.uid)
                            .set(
                          {
                            "points": FieldValue.increment(-cartAmount),
                            "banner": FieldValue.arrayUnion(cartItemsNames),
                          },
                          SetOptions(merge: true),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Purchase complete')));
                      } catch (e) {
                        print('Error fetching user data: $e');
                        // Handle the error gracefully, e.g., display an error message to the user
                      }
                    }
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('BUY'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

// -------------------------------------------------------
//  MODEL : Produit
// -------------------------------------------------------
class Product {
  final String name;
  final double price;
  final String image;
  final bool isNew;
  final double rating;

  final String ecran;
  final String processeur;
  final String memoire;
  final String batterie;

  const Product(
    this.name,
    this.price,
    this.image, {
    this.isNew = false,
    this.rating = 0.0,
    this.ecran = '',
    this.processeur = '',
    this.memoire = '',
    this.batterie = '',
  });
}

// -------------------------------------------------------
//  MODEL : Item du panier
// -------------------------------------------------------
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

// -------------------------------------------------------
//  PAGE PRINCIPALE : Liste des produits
// -------------------------------------------------------
class Atelier6Page extends StatefulWidget {
  const Atelier6Page({super.key});

  @override
  State<Atelier6Page> createState() => _Atelier6PageState();
}

class _Atelier6PageState extends State<Atelier6Page> {
  final List<Product> products = const [
    Product(
      'iPhone 15',
      999.000,
      'images/iphone15.jpg',
      isNew: true,
      rating: 4.5,
      ecran: '6.1 pouces Super Retina XDR',
      processeur: 'A16 Bionic',
      memoire: '128 GB',
      batterie: 'Jusqu’à 20h de vidéo',
    ),
    Product(
      'Samsung 9 Galaxy',
      799.000,
      'images/samsung.jpg',
      rating: 4.2,
      ecran: '6.4 pouces AMOLED',
      processeur: 'Exynos 2100',
      memoire: '256 GB',
      batterie: 'Jusqu’à 22h de vidéo',
    ),
    Product(
      'Google Pixel',
      699.000,
      'images/google.jpg',
      isNew: true,
      rating: 4.7,
      ecran: '6.0 pouces OLED',
      processeur: 'Google Tensor',
      memoire: '128 GB',
      batterie: 'Jusqu’à 18h de vidéo',
    ),
  ];

  List<CartItem> cart = [];
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = List<bool>.filled(products.length, false);
  }

  int get cartCount => cart.fold(0, (sum, item) => sum + item.quantity);

  void _addToCart(Product product) {
    setState(() {
      final index =
          cart.indexWhere((item) => item.product.name == product.name);

      if (index != -1) {
        cart[index].quantity++;
      } else {
        cart.add(CartItem(product: product));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Produits'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PanierPage(cart: cart),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isExpanded = _expanded[index];

          return Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.only(bottom: 18),
            child: Column(
              children: [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(product.image,
                        width: 55, height: 55, fit: BoxFit.cover),
                  ),
                  title: Text(product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade600, size: 16),
                      const SizedBox(width: 4),
                      Text("${product.rating}"),
                      const SizedBox(width: 10),
                      Text(
                        "${product.price} DT",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        color: Colors.deepPurple,
                        onPressed: () => _addToCart(product),
                      ),
                      IconButton(
                        icon: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _expanded[index] = !isExpanded;
                          });
                        },
                      )
                    ],
                  ),
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Spécifications",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        _spec("Écran", product.ecran),
                        _spec("Processeur", product.processeur),
                        _spec("Mémoire", product.memoire),
                        _spec("Batterie", product.batterie),
                      ],
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _spec(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text("$label : $value",
          style: const TextStyle(color: Colors.black54)),
    );
  }
}

// -------------------------------------------------------
//  PAGE PANIER (AMÉLIORÉE + FORMULAIRE DE PAIEMENT)
// -------------------------------------------------------
class PanierPage extends StatefulWidget {
  final List<CartItem> cart;

  const PanierPage({super.key, required this.cart});

  @override
  State<PanierPage> createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  double get subtotal => widget.cart.fold(0, (sum, item) => sum + item.total);

  double get delivery => 15.000;
  double get tax => subtotal * 0.12;

  @override
  Widget build(BuildContext context) {
    if (widget.cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Récapitulatif du Panier")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined,
                  size: 90, color: Colors.grey),
              const SizedBox(height: 20),
              const Text("Votre panier est vide",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Ajoutez des produits pour continuer",
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Retour aux produits"),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Récapitulatif du Panier")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -------- LISTE DES ARTICLES --------
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (_, index) {
                  final item = widget.cart[index];

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(item.product.image,
                            width: 55, height: 55, fit: BoxFit.cover),
                      ),
                      title: Text(item.product.name),
                      subtitle: Text("${item.product.price} DT"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (item.quantity > 1) {
                                  item.quantity--;
                                }
                              });
                            },
                          ),
                          Text("${item.quantity}"),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                item.quantity++;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                widget.cart.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // -------- TOTAL --------
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sous-total : ${subtotal.toStringAsFixed(3)} DT"),
                  Text("Livraison : ${delivery.toStringAsFixed(3)} DT"),
                  Text("Taxes : ${tax.toStringAsFixed(3)} DT"),
                  const SizedBox(height: 10),
                  Text(
                    "Total : ${(subtotal + delivery + tax).toStringAsFixed(3)} DT",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------- FORMULAIRE DE PAIEMENT --------
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                labelText: "Numéro de carte (simulation)",
                prefixIcon: const Icon(Icons.credit_card),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // -------- BUTTON PAYER --------
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () {},
              child: Text(
                "Payer ${(subtotal + delivery + tax).toStringAsFixed(3)} DT",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, // 👈 Texte en blanc
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

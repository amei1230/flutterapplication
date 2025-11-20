import 'package:flutter/material.dart';

class Atelier4App extends StatelessWidget {
  const Atelier4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atelier 4 - Flutter M3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const ProductListPageM3(),
    );
  }
}

// ---------------------------------------------------------------------------
// 🧱 Modèle Produit (modifié)
// ---------------------------------------------------------------------------
class Product {
  final String name;
  final double price;
  final String image;
  final bool isNew;
  final double rating;
  final Map<String, String> specs; // 👈 Nouveau : spécifications

  const Product(
    this.name,
    this.price,
    this.image, {
    this.isNew = false,
    this.rating = 0.0,
    this.specs = const {}, // Par défaut vide
  });
}

// ---------------------------------------------------------------------------
// 🛍 Page Liste des produits (modifiée)
// ---------------------------------------------------------------------------
class ProductListPageM3 extends StatefulWidget {
  const ProductListPageM3({super.key});

  @override
  State<ProductListPageM3> createState() => _ProductListPageM3State();
}

class _ProductListPageM3State extends State<ProductListPageM3> {
  // 🛒 État du panier
  final List<Product> _cart = [];
  int get cartCount => _cart.length;
  double get cartTotal => _cart.fold(0.0, (sum, p) => sum + p.price);

  // 📄 État d'affichage des specs par produit
  final Map<int, bool> _showSpecs = {};

  // ✨ Liste des produits avec specs
  final List<Product> products = const [
    Product('iPhone 15', 999, 'assets/images/iphone-15.jpg',
        isNew: true,
        rating: 4.5,
        specs: {
          'Écran': '6.1 pouces Super Retina XDR',
          'Processeur': 'A16 Bionic',
          'Mémoire': '128 GB',
          'Batterie': 'Jusqu\'à 20h de vidéo',
        }),
    Product('Samsung Galaxy', 799, 'assets/images/samsung.jpg',
        rating: 4.2,
        specs: {
          'Écran': '6.7 pouces AMOLED',
          'Processeur': 'Snapdragon 8 Gen 2',
          'Mémoire': '256 GB',
          'Batterie': '5000 mAh',
        }),
    Product('Google Pixel', 699, 'assets/images/google.jpg',
        isNew: true,
        rating: 4.7,
        specs: {
          'Écran': '6.3 pouces OLED',
          'Processeur': 'Tensor G3',
          'Mémoire': '128 GB',
          'Batterie': '4700 mAh',
        }),
  ];

  // 🛒 Ouvre le récapitulatif du panier
  void _showCartSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Récapitulatif Panier',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              if (_cart.isEmpty)
                Text(
                  'Votre panier est vide.',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              else ...[
                for (final product in _cart)
                  ListTile(
                    leading: Image.asset(product.image, width: 40),
                    title: Text(product.name),
                    subtitle: Text('${product.price}€'),
                  ),
                Divider(),
                Text(
                  'Articles: ${_cart.length}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Total: ${cartTotal.toStringAsFixed(2)}€',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context); // Ferme le bottom sheet
                },
                child: const Text('Fermer'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Produits'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          // 🛒 Icône panier avec badge
          Badge(
            label: Text('$cartCount'),
            child: IconButton(
              onPressed: _showCartSummary,
              icon: Icon(Icons.shopping_cart, color: colorScheme.primary),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final showSpecs = _showSpecs[index] ?? false;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // ✅ Image locale avec badge "NEW"
                      Stack(
                        children: [
                          Hero(
                            tag: product.name,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: AssetImage(product.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          if (product.isNew)
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'NEW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // ✅ Infos produit
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber.shade600,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(product.rating.toString()),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${product.price}€',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // ✅ Bouton panier
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _cart.add(product);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} ajouté au panier 🛍',
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: colorScheme.primary,
                        ),
                      ),

                      // ✅ Flèche pour afficher/masquer les specs
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showSpecs[index] = !showSpecs;
                          });
                        },
                        icon: Icon(
                          showSpecs ? Icons.expand_less : Icons.expand_more,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  // ✅ Description (toujours visible)
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Découvrez le ${product.name}, un produit haute performance conçu pour répondre à tous vos besoins. Design élégant et fonctionnalités avancées.',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),

                  // ✅ Spécifications (affichées si demandé)
                  if (showSpecs) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Spécifications',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    for (final entry in product.specs.entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              entry.value,
                              style: TextStyle(
                                  color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

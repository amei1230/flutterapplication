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
// 🧱 Modèle Produit
// ---------------------------------------------------------------------------
class Product {
  final String name;
  final double price;
  final String image;
  final bool isNew;
  final double rating;

  const Product(
    this.name,
    this.price,
    this.image, {
    this.isNew = false,
    this.rating = 0.0,
  });
}

// ---------------------------------------------------------------------------
// 🛍 Page Liste des produits
// ---------------------------------------------------------------------------
class ProductListPageM3 extends StatelessWidget {
  const ProductListPageM3({super.key});

  final List<Product> products = const [
    Product('iPhone 15', 999, 'assets/images/iphone-15.jpg',
        isNew: true, rating: 4.5),
    Product('Samsung Galaxy', 799, 'assets/images/samsung.jpg', rating: 4.2),
    Product('Google Pixel', 699, 'assets/images/google.jpg',
        isNew: true, rating: 4.7),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Produits'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
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
                        debugPrint('Ajouter ${product.name} au panier');
                      },
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 🔍 Page Détail Produit
// ---------------------------------------------------------------------------
class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ValueNotifier<int> _quantity = ValueNotifier<int>(1);

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ✅ Image étirable locale
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.product.name,
                child: Image.asset(widget.product.image, fit: BoxFit.cover),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
            ],
          ),

          // ✅ Infos produit
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom + prix
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.product.price}€',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Étoiles et note
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(widget.product.rating.toString()),
                        const SizedBox(width: 8),
                        Text(
                          '(128 avis)',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Description
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Découvrez le ${widget.product.name}, un produit haute performance conçu pour répondre à tous vos besoins. Design élégant et fonctionnalités avancées.',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sélecteur de quantité
                    Text(
                      'Quantité',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ValueListenableBuilder<int>(
                      valueListenable: _quantity,
                      builder: (context, quantity, child) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.outline),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: quantity > 1
                                    ? () => _quantity.value--
                                    : null,
                              ),
                              SizedBox(
                                width: 40,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Text(
                                    quantity.toString(),
                                    key: ValueKey(quantity),
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _quantity.value++,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),

      // ✅ Bouton d’action en bas
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: Row(
          children: [
            // Prix total
            ValueListenableBuilder<int>(
              valueListenable: _quantity,
              builder: (context, quantity, child) {
                final total = widget.product.price * quantity;
                return Text(
                  '${total.toStringAsFixed(2)}€',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                );
              },
            ),
            const SizedBox(width: 12),

            // Bouton d’achat
            Expanded(
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.product.name} ajouté au panier 🛍',
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Ajouter au panier'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

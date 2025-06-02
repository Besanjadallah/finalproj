import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'plant_detail_page.dart';
import 'providers/favorite_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favorites = favoriteProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: const Color(0xFF8DBF67),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet 💔'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (ctx, index) {
                final item = favorites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: Image.asset(item.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        favoriteProvider.removeFavorite(item.id);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlantDetailPage(
                            imagePath: item.image,
                            name: item.name,
                            temperature: 'N/A',
                            lighting: 'N/A',
                            watering: 'N/A',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

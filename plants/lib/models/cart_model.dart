class CartItem {
  final String id;       
  final String name;
  final double price; 
   final String image;  
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'plantId': id,
      'quantity': quantity,
    };
  }
}

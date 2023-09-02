class Dummy {
  Dummy(
      {required this.name,
      required this.price,
      required this.ratings,
      required this.image,
      required this.distance});

  final String name;
  final String price;
  final String ratings;
  final String image;
  final String distance;
  static Dummy fromJson(json) => Dummy(
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      ratings: json['ratings'] ?? '',
      image: json['image'],
      distance: json['distance'] ?? '');

  Map<String, dynamic> toJson() =>
      {'name': name, 'price': price, 'ratings': ratings, 'image': image};
}

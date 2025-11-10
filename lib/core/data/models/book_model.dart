class BookModel {
  final int? id;
  final String? bookname;
  final String? price;
  final String? description;
  final String? coverpicture;

  BookModel({
    this.id,
    this.bookname,
    this.price,
    this.description,
    this.coverpicture,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      bookname: json['bookname'],
      price: json['price'],
      description: json['description'],
      coverpicture: json['coverpicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookname': bookname,
      'price': price,
      'description': description,
      'coverpicture': coverpicture,
    };
  }
}

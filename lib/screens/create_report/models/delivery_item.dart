class DeliveryItem {
  String? name;
  int? amount;

  DeliveryItem({
    this.name,
    this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': amount,
    };
  }
}
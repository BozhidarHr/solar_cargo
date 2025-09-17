class DeliveryItem {
  String? name;
  int? amount;

  DeliveryItem({
    this.name,
    this.amount,
  });

  DeliveryItem.empty() : name = null, amount = null;

  factory DeliveryItem.fromJson(Map<String, dynamic> json) {
    return DeliveryItem(
      name: json['item']?['name'] as String?,
      amount: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? ''),
    );
  }

  factory DeliveryItem.fromLocalJson(Map<String, dynamic> json) {
    return DeliveryItem(
      name: json['name'] as String?,
      amount: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? ''),
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': amount,
    };
  }
}

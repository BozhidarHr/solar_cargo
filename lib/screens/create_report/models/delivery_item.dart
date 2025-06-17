class DeliveryItem {
   String? name;
   int? amount;

  DeliveryItem({
    this.name,
    this.amount,
  });

   DeliveryItem.empty() : name = null, amount = null;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': amount,
    };
  }
}

enum ReportOption { ok, notOk, na }

class CheckBoxItem {
  String name; // not nullable since it's the key
  ReportOption? selectedOption;
  String? comment;

  CheckBoxItem({
    required this.name,
    this.selectedOption,
    this.comment,
  });

  static Map<String, dynamic> listToFlatJson(List<CheckBoxItem> items) {
    final Map<String, dynamic> result = {};

    for (var item in items) {
      result['${item.name}_status'] = _reportOptionToBool(item.selectedOption);
      result['${item.name}_comment'] = item.comment;
    }

    return result;
  }

  /// Converts ReportOption to boolean (ok = true, notOk = false, na = null)
  static bool? _reportOptionToBool(ReportOption? option) {
    switch (option) {
      case ReportOption.ok:
        return true;
      case ReportOption.notOk:
        return false;
      case ReportOption.na:
      case null:
        return null;
    }
  }

  static Map<String, CheckBoxItem> defaultStep3Items() {
    return {
      'Load properly secured': CheckBoxItem(name: 'load_secured'),
      'Goods according to delivery and PO, amount and indentity':
      CheckBoxItem(name: 'goods_according'),
      'Packaging sufficient and stable enough': CheckBoxItem(name: 'packaging'),
      'Delivery without damages': CheckBoxItem(name: 'delivery_without_damages'),
      'Suitable machines for unloading/handling present':
      CheckBoxItem(name: 'suitable_machines'),
      'Delivery slip scanned, uploaded and filed':
      CheckBoxItem(name: 'delivery_slip'),
      'Inspection Report scanned, uploaded and filed':
      CheckBoxItem(name: 'inspection_report'),
    };
  }
}

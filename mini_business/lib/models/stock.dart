class Stock {
  int? id;
  String code;
  String name;
  String description;
  String supplier;
  String category;
  int count;
  double cost;
  String price;
  List<double> variations;

  Stock(this.code, this.name, this.description, this.supplier, this.category, this.count, this.cost, this.price, this.variations, {this.id});
  
  Map<String, dynamic> toJson() => {
    "code" : code,
    "name" : name,
    "description" : description,
    "supplier" : supplier,
    "category" : category,
    "count" : count,
    "cost" : cost,
    "price" : price,
    "variations" : variations
  };

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'code': code,
    'name': name,
    'description': description,
    'supplier': supplier,
    'category': category,
    'count': count,
    'cost': cost,
    'price': price,
    'variations': variations.isNotEmpty ? variations.join(',') : ''
  };

  factory Stock.fromMap(Map<String, dynamic> map) {
    // variations stored as comma-separated string in DB
    List<double> variations = [];
    final raw = map['variations'] as String?;
    if (raw != null && raw.isNotEmpty) {
      variations = raw.split(',').map((s) => double.tryParse(s) ?? 0.0).toList();
    }

    return Stock(
      map['code'] as String? ?? '',
      map['name'] as String? ?? '',
      map['description'] as String? ?? '',
      map['supplier'] as String? ?? '',
      map['category'] as String? ?? '',
      (map['count'] is int) ? map['count'] as int : int.tryParse('${map['count']}') ?? 0,
      (map['cost'] is double) ? map['cost'] as double : double.tryParse('${map['cost']}') ?? 0.0,
      map['price'] as String? ?? '',
      variations,
      id: map['id'] is int ? map['id'] as int : int.tryParse('${map['id']}'),
    );
  }

  factory Stock.fromJson(Map<String, dynamic> json) {
    // Safely extract variations, ensuring we get a List<double>
    List<double> variations = [];
    final rawVariations = json['variations'];
    if (rawVariations != null) {
      if (rawVariations is List) {
        variations = rawVariations.map((v) {
          if (v is double) return v;
          if (v is int) return v.toDouble();
          return double.tryParse('$v') ?? 0.0;
        }).toList();
      }
    }

    return Stock(
      json['code'] as String? ?? '',
      json['name'] as String? ?? '',
      json['description'] as String? ?? '',
      json['supplier'] as String? ?? '',
      json['category'] as String? ?? '',
      (json['count'] is int) ? json['count'] as int : int.tryParse('${json['count']}') ?? 0,
      (json['cost'] is double) ? json['cost'] as double : double.tryParse('${json['cost']}') ?? 0.0,
      json['price'] as String? ?? '',
      variations
    );
  }


}
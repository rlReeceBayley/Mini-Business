class Supplier {
  int? id;
  String account;
  String name;
  String email;
  int number;
  String pricing;

  Supplier(this.account, this.name, this.email, this.number, this.pricing, {this.id});

  Map<String, dynamic> toJson() => {
        "account": account,
        "name": name,
        "email": email,
        "number": number,
        "pricing": pricing,
      };

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'account': account,
        'name': name,
        'email': email,
        'number': number,
        'pricing': pricing,
      };

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        json['account'] as String? ?? '',
        json['name'] as String? ?? '',
        json['email'] as String? ?? '',
        (json['number'] is int) ? json['number'] as int : int.tryParse('${json['number']}') ?? 0,
        json['pricing'] as String? ?? '',
      );

  factory Supplier.fromMap(Map<String, dynamic> map) => Supplier(
        map['account'] as String? ?? '',
        map['name'] as String? ?? '',
        map['email'] as String? ?? '',
        (map['number'] is int) ? map['number'] as int : int.tryParse('${map['number']}') ?? 0,
        map['pricing'] as String? ?? '',
        id: map['id'] is int ? map['id'] as int : int.tryParse('${map['id']}'),
      );
}

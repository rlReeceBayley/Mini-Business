class Client {
  int? id;
  String account;
  String name;
  String email;
  String address;
  int number;
  String pricing;
  String term;
  int vat;


  Client(this.account, this.name, this.email, this.address, this.number, this.pricing, this.term, this.vat, {this.id});

  Map<String, dynamic> toJson() => {
        "account": account,
        "name": name,
        "email": email,
        "address": address,
        "number": number,
        "pricing": pricing,
        "term": term,
        "vat": vat,
      };

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'account': account,
        'name': name,
        'email': email,
        'address': address,
        'number': number,
        'pricing': pricing,
        'term': term,
        'vat': vat
      };

  factory Client.fromMap(Map<String, dynamic> map) => Client(
        map['account'] as String? ?? '',
        map['name'] as String? ?? '',
        map['email'] as String? ?? '',
        map['address'] as String? ?? '',
        (map['number'] is int) ? map['number'] as int : int.tryParse('${map['number']}') ?? 0,
        map['pricing'] as String? ?? '',
        map['term'] as String? ?? '',
        (map['vat'] is int) ? map['vat'] as int : int.tryParse('${map['vat']}') ?? 0,
        id: map['id'] is int ? map['id'] as int : int.tryParse('${map['id']}'),
      );

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        json['account'] as String? ?? '',
        json['name'] as String? ?? '',
        json['email'] as String? ?? '',
        json['address'] as String? ?? '',
        (json['number'] is int) ? json['number'] as int : int.tryParse('${json['number']}') ?? 0,
        json['pricing'] as String? ?? '',
        json['term'] as String? ?? '',
        (json['vat'] is int) ? json['vat'] as int : int.tryParse('${json['vat']}') ?? 0,
      );
}

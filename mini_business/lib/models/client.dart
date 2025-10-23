class Client {
  String account;
  String name;
  String email;
  int number;
  String pricing;
  

  Client(this.account, this.name, this.email, this.number, this.pricing);

  Map<String, dynamic> toJson() => {
        "account": account,
        "name": name,
        "email": email,
        "number": number,
        "pricing": pricing,
      };

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        json['account'] as String? ?? '',
        json['name'] as String? ?? '',
        json['email'] as String? ?? '',
        (json['number'] is int) ? json['number'] as int : int.tryParse('${json['number']}') ?? 0,
        json['pricing'] as String? ?? '',
      );
}

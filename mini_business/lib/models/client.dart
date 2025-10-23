class Client {
  String name;
  String email;

  Client(this.name, this.email);

  Map<String, dynamic> toJson() => {"name": name, "email": email};
}

class Child {
  final int id;
  final String name;
  final int balance;

  const Child({
    required this.id,
    required this.name,
    required this.balance,
  });

  // Convert a Child into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }

  // Implement toString to make it easier to see information about
  // each Child when using the print statement.
  @override
  String toString() {
    return 'Child{id: $id, name: $name, balance: $balance}';
  }
}

class Parent {
  final int id;
  final String name;
  final String lastname;
  final int pin;

  const Parent({
    required this.id,
    required this.name,
    required this.lastname,
    required this.pin,
  });

  // Convert a Child into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'pin': pin,
    };
  }

  // Implement toString to make it easier to see information about
  // each Child when using the print statement.
  @override
  String toString() {
    return 'Child{id: $id, name: $name, lastname: $lastname, pin: $pin}';
  }
}

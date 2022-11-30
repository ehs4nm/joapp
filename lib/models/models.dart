class Child {
  int? id;
  String? name;
  int? balance;
  String? avatar;

  Child({
    this.id,
    this.name,
    this.balance,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'avatar': avatar,
    };
  }

  @override
  String toString() {
    return 'Child{id: $id, name: $name, balance: $balance, avatar: $avatar}';
  }
}

class Parent {
  int? id;
  String? firstName;
  String? lastName;
  int? pin;

  Parent({
    this.id,
    this.firstName,
    this.lastName,
    this.pin,
  });

  // Convert a Child into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'pin': pin,
    };
  }

  // Implement toString to make it easier to see information about
  // each Child when using the print statement.
  @override
  String toString() {
    return 'Child{id: $id, firstName: $firstName, lastName: $lastName, pin: $pin}';
  }
}

class BTransaction {
  int? id;
  int? childId;
  int? transaction;
  DateTime? createdAt;

  BTransaction({
    this.id,
    this.childId,
    this.transaction,
    this.createdAt,
  });

  // Convert a Child into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'lastNamtransactione': transaction,
      'createdAt': createdAt,
    };
  }

  // Implement toString to make it easier to see information about
  // each Child when using the print statement.
  @override
  String toString() {
    return 'Child{id: $id, childId: $childId, transaction: $transaction, createdAt: $createdAt}';
  }
}

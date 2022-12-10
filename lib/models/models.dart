class Child {
  int? id;
  String? name;
  String? sex;
  int? balance;
  String? avatar;

  Child({
    this.id,
    this.name,
    this.sex,
    this.balance,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sex': sex,
      'balance': balance,
      'avatar': avatar,
    };
  }

  @override
  String toString() {
    return 'Child{id: $id, name: $name, sex:$sex, balance: $balance, avatar: $avatar}';
  }
}

class Parent {
  int? id;
  String? fullName;
  int? pin;

  Parent({
    this.id,
    this.fullName,
    this.pin,
  });

  // Convert a Child into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'pin': pin,
    };
  }

  // Implement toString to make it easier to see information about
  // each Child when using the print statement.
  @override
  String toString() {
    return 'Child{id: $id, fullName: $fullName, pin: $pin}';
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

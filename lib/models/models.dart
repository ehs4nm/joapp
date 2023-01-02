class Parent {
  int? id;
  String? fullName;
  String? email;
  String? pin;

  Parent({
    this.id,
    this.fullName,
    this.pin,
    this.email,
  });

  // Convert a Child into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'pin': pin,
      'email': email,
    };
  }

  // Implement toString to make it easier to see information about
  // each Child when using the print statement.
  @override
  String toString() {
    return 'Parent{id: $id, fullName: $fullName, pin: $pin, email: $email}';
  }
}

class BankAction {
  int? id;
  int? childId;
  int? action;
  String? note;
  String? createdAt;

  BankAction({
    this.id,
    this.childId,
    this.action,
    this.note,
    this.createdAt,
  });

  // Convert a Child into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'action': action,
      'note': note,
      'createdAt': createdAt,
    };
  }

  // Implement toString to make it easier to see information about
  // each Child when using the print statement.
  @override
  String toString() {
    return 'Action{id: $id, childId: $childId, action: $action, note: $note, createdAt: $createdAt}';
  }
}

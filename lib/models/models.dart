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

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      fullName: json['fullName'],
      pin: json['pin'],
      email: json['email'],
    );
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

  factory BankAction.fromJson(Map<String, dynamic> json) {
    return BankAction(
      id: json['id'],
      childId: json['childId'],
      action: json['action'],
      note: json['note'],
      createdAt: json['createdAt'],
    );
  }

  // Implement toString to make it easier to see information about
  // each Child when using the print statement.
  @override
  String toString() {
    return 'Action{id: $id, childId: $childId, action: $action, note: $note, createdAt: $createdAt}';
  }
}

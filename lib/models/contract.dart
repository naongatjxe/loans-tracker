import 'person.dart';

class Contract {
  final String id;
  final Person person;
  final String companyName;
  final DateTime creationDate;
  final String terms;

  Contract({
    required this.id,
    required this.person,
    required this.companyName,
    required this.creationDate,
    this.terms = '',
  });

  Contract copyWith({
    String? id,
    Person? person,
    String? companyName,
    DateTime? creationDate,
    String? terms,
  }) {
    return Contract(
      id: id ?? this.id,
      person: person ?? this.person,
      companyName: companyName ?? this.companyName,
      creationDate: creationDate ?? this.creationDate,
      terms: terms ?? this.terms,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'person': person.toMap(),
      'companyName': companyName,
      'creationDate': creationDate.millisecondsSinceEpoch,
      'terms': terms,
    };
  }

  factory Contract.fromMap(Map<String, dynamic> map) {
    return Contract(
      id: map['id'],
      person: Person.fromMap(map['person']),
      companyName: map['companyName'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      terms: map['terms'] ?? '',
    );
  }
}

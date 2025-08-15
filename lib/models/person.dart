class Person {
  final String id;
  final String name;
  final String phone;
  final String nrc;
  final String workplace;
  final double amount;
  final double interestRate;
  final DateTime loanDate;
  final DateTime dueDate;
  final bool isPaid;

  Person({
    required this.id,
    required this.name,
    required this.phone,
    required this.nrc,
    required this.workplace,
    required this.amount,
    required this.interestRate,
    required this.loanDate,
    required this.dueDate,
    this.isPaid = false,
  });

  Person copyWith({
    String? id,
    String? name,
    String? phone,
    String? nrc,
    String? workplace,
    double? amount,
    double? interestRate,
    DateTime? loanDate,
    DateTime? dueDate,
    bool? isPaid,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      nrc: nrc ?? this.nrc,
      workplace: workplace ?? this.workplace,
      amount: amount ?? this.amount,
      interestRate: interestRate ?? this.interestRate,
      loanDate: loanDate ?? this.loanDate,
      dueDate: dueDate ?? this.dueDate,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'nrc': nrc,
      'workplace': workplace,
      'amount': amount,
      'interestRate': interestRate,
      'loanDate': loanDate.millisecondsSinceEpoch,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'isPaid': isPaid,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      nrc: map['nrc'],
      workplace: map['workplace'],
      amount: map['amount'],
      interestRate: map['interestRate'],
      loanDate: DateTime.fromMillisecondsSinceEpoch(map['loanDate']),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
      isPaid: map['isPaid'] ?? false,
    );
  }

  double calculateTotalAmount() {
    // Calculate the total amount to be paid including interest (weekly basis)
    final daysElapsed = DateTime.now().difference(loanDate).inDays;
    final double weeksElapsed = daysElapsed / 7.0;
    final double interest =
        amount * (interestRate / 100) * weeksElapsed; // Weekly interest
    return amount + interest;
  }

  double calculateAmountDue(DateTime currentDate) {
    // Calculate the amount due based on the current date (weekly basis)
    final daysElapsed = currentDate.difference(loanDate).inDays;
    final double weeksElapsed = daysElapsed / 7.0;
    final double interest =
        amount * (interestRate / 100) * weeksElapsed; // Weekly interest
    return amount + interest;
  }

  /// Interest for the agreed term (loanDate -> dueDate), not just elapsed time.
  double interestForTerm() {
    final days = dueDate.difference(loanDate).inDays;
    final double weeks = days / 7.0;
    return amount * (interestRate / 100) * weeks;
  }

  /// Total amount for the agreed term (principal + interest for term).
  double totalForTerm() {
    return amount + interestForTerm();
  }
}

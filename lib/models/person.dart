import '../utils/interest_calculator.dart';

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
    // Calculate the total amount to be paid including fixed per-term interest.
    // Interest is applied as: interest = amount * (interestRate/100),
    // then total = amount + interest (previous behaviour).
    return totalForTerm();
  }

  double calculateAmountDue(DateTime currentDate) {
    // Return the total amount due for the loan term (fixed per-term interest).
    // The due date is accepted for API compatibility but not used because the
    // interest is not time-pro-rated.
    return totalForTerm();
  }

  /// Interest for the loan (simple fixed percentage, not time-dependent).
  double interestForTerm() {
    return InterestCalculator.calculateInterestCharge(amount, interestRate);
  }

  /// Total amount for the loan (principal + fixed interest).
  double totalForTerm() {
    return InterestCalculator.calculateTotalDue(amount, interestRate);
  }
}

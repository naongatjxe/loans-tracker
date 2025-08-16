class InterestCalculator {
  // Calculate total amount due with fixed interest rate (not time-dependent)
  static double calculateTotalDue(double amountLoaned, double interestRate) {
    // Convert percentage rate (e.g. 10) into decimal (0.10)
    double interest = interestRate / 100;

    // Interest charge
    double interestCharge = amountLoaned * interest;

    // Amount due
    double totalDue = amountLoaned + interestCharge;

    return totalDue;
  }

  // Calculate just the interest charge (not time-dependent)
  static double calculateInterestCharge(
    double amountLoaned,
    double interestRate,
  ) {
    // Convert percentage rate (e.g. 10) into decimal (0.10)
    double interest = interestRate / 100;

    // Interest charge
    return amountLoaned * interest;
  }

  // Return both interest charge and total due as a Map
  static Map<String, double> calculateInterestBreakdown(
    double amountLoaned,
    double interestRate,
  ) {
    double interestCharge = calculateInterestCharge(amountLoaned, interestRate);
    double totalDue = amountLoaned + interestCharge;

    return {
      'interestCharge': interestCharge,
      'totalDue': totalDue,
      'principal': amountLoaned,
    };
  }

  // Calculate simple interest
  static double calculateSimpleInterest(
    double principal,
    double rate,
    int daysElapsed,
  ) {
    // Convert annual rate to daily rate and multiply by days elapsed
    final dailyRate = rate / 100 / 365;
    return principal * dailyRate * daysElapsed;
  }

  // Calculate compound interest (monthly compounding)
  static double calculateCompoundInterest(
    double principal,
    double annualRate,
    int daysElapsed,
  ) {
    // Convert annual rate to monthly rate
    final monthlyRate = annualRate / 100 / 12;
    // Calculate number of months
    final months = daysElapsed / 30;
    // Calculate compound interest: P(1 + r)^t - P
    final compoundFactor = pow(1 + monthlyRate, months);
    return principal * compoundFactor - principal;
  }

  // Calculate total amount due with simple interest
  static double calculateTotalAmountDue(
    double principal,
    double rate,
    DateTime startDate,
    DateTime endDate,
  ) {
    final daysElapsed = endDate.difference(startDate).inDays;
    final interest = calculateSimpleInterest(principal, rate, daysElapsed);
    return principal + interest;
  }
}

double pow(double x, double y) {
  double result = 1.0;
  for (int i = 0; i < y.floor(); i++) {
    result *= x;
  }

  // Handle the fractional part if necessary
  if (y - y.floor() > 0) {
    // A simple approximation for fractional powers
    double fraction = y - y.floor();
    result *= 1 + (x - 1) * fraction;
  }

  return result;
}

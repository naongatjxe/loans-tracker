class InterestCalculator {
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

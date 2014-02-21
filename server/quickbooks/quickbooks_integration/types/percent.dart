part of QuickbooksIntegration;

class QBPercent {
  /// Percent value as a double between 0 and 100
  double value = 0.0;
  
  /// Percent value / 10 to get the quickbooks formatted value
  double get quickbooksFormatValue => value / 10;
  
  QBPercent._create(double value) {
    this.value = value;
  } 
  
  /***
   * Creates a new Quickbooks Percent Type. 
   * [value] should be a value between 0 and 100 representing a percentage
   */
  factory QBPercent (num value) {
    if (value > 100) throw new ArgumentError("Percent value cannot be greater than 100");
    if (value < 0) throw new ArgumentError("Percent value cannot be less than 0");
    return new QBPercent._create(value.toDouble());
  }
  
  /***
   * Returns the Quickbooks Formatted value as a string.
   */
  String toString () {
    if (quickbooksFormatValue == quickbooksFormatValue.toInt().toDouble()) {
      return quickbooksFormatValue.toStringAsFixed(1);
    }
    else {
      return quickbooksFormatValue.toString();
    }
  }
}
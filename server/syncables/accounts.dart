part of FreemansServer;

class Accounts extends SyncCachable<Accounts> {
  // Quickbooks XML generated fields
  String listID;
  DateTime timeCreated;
  DateTime timeModified;
  String name;
  String parentID;  
  String fullName;
  AccountType accountType;
  bool isTaxAccount;
  String accountNumber;
  SpecialAccountType specialAccountType;
  String bankNumber;
  String description;
  num balance;
  num totalBalance;
  String taxLineID;
  CashFlowClassification cashFlowClassification;
  String currencyRef;
  
  // Filled after initial data load
  List<Accounts> childAccounts;
  
  Accounts(String listID):super(0, listID) {
    this.listID = listID;
  }
  
  
  static Future<bool> init () {
    
  }
}

class EnumString<T> {
  static Map<Type, Map<String, EnumString>> enums = new Map<Type, Map<String, EnumString>>();
  static EnumString get (Type T, String value) {
    if (enums.containsKey(T) && enums[T].containsKey(value)) {
      return enums[T][value];
    }
  }
  final String enumStr;
  const EnumString (String this.enumStr);
  String toString () { 
    return enumStr;
  }
}

class AccountType extends EnumString<AccountType> {
  const AccountType(String eN):super(eN);

  static const AccountType ACCOUNTS_PAYABLE = const AccountType("AccountsPayable");
  static const AccountType ACCOUNTS_RECEIVABLE = const AccountType("AccountsReceivable");
  static const AccountType BANK = const AccountType("Bank");
  static const AccountType COST_OF_GOODS_SOLD = const AccountType("CostOfGoodsSold");
  static const AccountType CREDIT_CARD = const AccountType("CreditCard");
  static const AccountType EQUITY = const AccountType("Equity");
  static const AccountType EXPENSE = const AccountType("Expense");
  static const AccountType FIXED_ASSET = const AccountType("FixedAsset");
  static const AccountType INCOME = const AccountType("Income");
  static const AccountType LONG_TERM_LIABILITY = const AccountType("LongTermLiability");
  static const AccountType NON_POSTING = const AccountType("NonPosting");
  static const AccountType OTHER_ASSET = const AccountType("OtherAsset");
  static const AccountType OTHER_CURRENT_ASSET = const AccountType("OtherCurrentAsset");
  static const AccountType OTHER_CURRENT_LIABILITY = const AccountType("OtherCurrentLiability");
  static const AccountType OTHER_EXPENSE = const AccountType("OtherExpense");
  static const AccountType OTHER_INCOME = const AccountType("OtherIncome");
}

class SpecialAccountType extends EnumString<SpecialAccountType> {
  const SpecialAccountType(String eN):super(eN);

  static const SpecialAccountType ACCOUNTS_PAYABLE = const SpecialAccountType("AccountsPayable");
  static const SpecialAccountType ACCOUNTS_RECEIVABLE = const SpecialAccountType("AccountsReceivable");
  static const SpecialAccountType CONDENSE_ITEM_ADJUSTMENT_EXPENSES = const SpecialAccountType("CondenseItemAdjustmentExpenses");
  static const SpecialAccountType COST_OF_GOODS_SOLD = const SpecialAccountType("CostOfGoodsSold");
  static const SpecialAccountType DIRECT_DEPOSIT_LIABILITIES = const SpecialAccountType("DirectDepositLiabilities");
  static const SpecialAccountType ESTIMATES = const SpecialAccountType("Estimates");
  static const SpecialAccountType EXCHANGE_GAIN_LOSS = const SpecialAccountType("ExchangeGainLoss");
  static const SpecialAccountType INVENTORY_ASSETS = const SpecialAccountType("InventoryAssets");
  static const SpecialAccountType ITEM_RECEIPT_ACCOUNT = const SpecialAccountType("ItemReceiptAccount");
  static const SpecialAccountType OPENING_BALANCE_EQUITY = const SpecialAccountType("OpeningBalanceEquity");
  static const SpecialAccountType PAYROLL_EXPENSES = const SpecialAccountType("PayrollExpenses");
  static const SpecialAccountType PAYROLL_LIABILITIES = const SpecialAccountType("PayrollLiabilities");
  static const SpecialAccountType PETTY_CASH = const SpecialAccountType("PettyCash");
  static const SpecialAccountType PURCHASE_ORDERS = const SpecialAccountType("PurchaseOrders");
  static const SpecialAccountType RECONCILIATION_DIFFERENCES = const SpecialAccountType("ReconciliationDifferences");
  static const SpecialAccountType RETAINED_EARNINGS = const SpecialAccountType("RetainedEarnings");
  static const SpecialAccountType SALES_ORDERS = const SpecialAccountType("SalesOrders");
  static const SpecialAccountType SALES_TAX_PAYABLE = const SpecialAccountType("SalesTaxPayable");
  static const SpecialAccountType UNCATEGORIZED_EXPENSES = const SpecialAccountType("UncategorizedExpenses");
  static const SpecialAccountType UNCATEGORIZED_INCOME = const SpecialAccountType("UncategorizedIncome");
  static const SpecialAccountType UNDEPOSITED_FUNDS = const SpecialAccountType("UndepositedFunds");
}

class CashFlowClassification extends EnumString<CashFlowClassification> {
  const CashFlowClassification(String eN):super(eN);

  static const CashFlowClassification NONE = const CashFlowClassification("None");
  static const CashFlowClassification OPERATING = const CashFlowClassification("Operating");
  static const CashFlowClassification INVESTING = const CashFlowClassification("Investing");
  static const CashFlowClassification FINANCING = const CashFlowClassification("Financing");
  static const CashFlowClassification NOT_APPLICABLE = const CashFlowClassification("NotApplicable");
}

part of QuickbooksIntegration;


class DataExtRet {
  String ownerID = "";
  String dataExtName = "";
  DataExtType dataExtType;
  String dataExtValue = "";
  DataExtRet (this.dataExtName, this.dataExtType, this.dataExtValue, [this.ownerID]);

  DataExtRet.parseFromListXml (XmlElement dataExtEl) { 
    dataExtName = getQbxmlContainer(dataExtEl, "DataExtName").text;
    dataExtType = EnumString.get(DataExtType, getQbxmlContainer(dataExtEl, "DataExtType").text);
    dataExtValue = getQbxmlContainer(dataExtEl, "DataExtValue").text;
    ownerID = getQbxmlContainer(dataExtEl, "OwnerID", optional: true).text;          
  }
  
  String toString() {
    return toJson().toString();
  }
  Map toJson () {
    return { "ownerID": ownerID, "dataExtName": dataExtName, "dataExtType": dataExtType, "dataExtValue": dataExtValue };
  }
}


class EnumString<T> {
  static Map<Type, Map<String, EnumString>> enums = new Map<Type, Map<String, EnumString>>();
  static EnumString get (Type T, String value) {
    if (enums.containsKey(T)) {
      if (enums[T].containsKey(value)) {
        return enums[T][value];
      }
      else if (enums[T].containsKey("DEFAULT")) {
        return enums[T]["DEFAULT"];
      }
    }
  }
  
  String enumStr;
  bool isDefault;
  EnumString (String this.enumStr, [bool this.isDefault = false ]) {
    if (!enums.containsKey(T)) enums[T] = new Map<String, EnumString>();
    enums[T][enumStr] = this;
    if (isDefault) enums[T]["DEFAULT"] = this;
  }
  String toString () { 
    return enumStr;
  }
  String toJson () { 
    return enumStr;
  }
}


class DataExtType extends EnumString<DataExtType> {
  DataExtType(String eN):super(eN);

  static DataExtType AMTTYPE = new DataExtType("AMTTYPE");
  static DataExtType DATETIMETYPE = new DataExtType("DATETIMETYPE");
  static DataExtType INTTYPE = new DataExtType("INTTYPE");
  static DataExtType PERCENTTYPE = new DataExtType("PERCENTTYPE");
  static DataExtType PRICETYPE = new DataExtType("PRICETYPE");
  static DataExtType QUANTYPE = new DataExtType("QUANTYPE");
  static DataExtType STR1024TYPE = new DataExtType("STR1024TYPE");
  static DataExtType STR255TYPE = new DataExtType("STR255TYPE");
}

class AccountType extends EnumString<AccountType> {
  AccountType(String eN):super(eN);

  static AccountType ACCOUNTS_PAYABLE = new AccountType("AccountsPayable");
  static AccountType ACCOUNTS_RECEIVABLE = new AccountType("AccountsReceivable");
  static AccountType BANK = new AccountType("Bank");
  static AccountType COST_OF_GOODS_SOLD = new AccountType("CostOfGoodsSold");
  static AccountType CREDIT_CARD = new AccountType("CreditCard");
  static AccountType EQUITY = new AccountType("Equity");
  static AccountType EXPENSE = new AccountType("Expense");
  static AccountType FIXED_ASSET = new AccountType("FixedAsset");
  static AccountType INCOME = new AccountType("Income");
  static AccountType LONG_TERM_LIABILITY = new AccountType("LongTermLiability");
  static AccountType NON_POSTING = new AccountType("NonPosting");
  static AccountType OTHER_ASSET = new AccountType("OtherAsset");
  static AccountType OTHER_CURRENT_ASSET = new AccountType("OtherCurrentAsset");
  static AccountType OTHER_CURRENT_LIABILITY = new AccountType("OtherCurrentLiability");
  static AccountType OTHER_EXPENSE = new AccountType("OtherExpense");
  static AccountType OTHER_INCOME = new AccountType("OtherIncome");
}

class SpecialAccountType extends EnumString<SpecialAccountType> {
  SpecialAccountType(String eN):super(eN);

  static SpecialAccountType ACCOUNTS_PAYABLE = new SpecialAccountType("AccountsPayable");
  static SpecialAccountType ACCOUNTS_RECEIVABLE = new SpecialAccountType("AccountsReceivable");
  static SpecialAccountType CONDENSE_ITEM_ADJUSTMENT_EXPENSES = new SpecialAccountType("CondenseItemAdjustmentExpenses");
  static SpecialAccountType COST_OF_GOODS_SOLD = new SpecialAccountType("CostOfGoodsSold");
  static SpecialAccountType DIRECT_DEPOSIT_LIABILITIES = new SpecialAccountType("DirectDepositLiabilities");
  static SpecialAccountType ESTIMATES = new SpecialAccountType("Estimates");
  static SpecialAccountType EXCHANGE_GAIN_LOSS = new SpecialAccountType("ExchangeGainLoss");
  static SpecialAccountType INVENTORY_ASSETS = new SpecialAccountType("InventoryAssets");
  static SpecialAccountType ITEM_RECEIPT_ACCOUNT = new SpecialAccountType("ItemReceiptAccount");
  static SpecialAccountType OPENING_BALANCE_EQUITY = new SpecialAccountType("OpeningBalanceEquity");
  static SpecialAccountType PAYROLL_EXPENSES = new SpecialAccountType("PayrollExpenses");
  static SpecialAccountType PAYROLL_LIABILITIES = new SpecialAccountType("PayrollLiabilities");
  static SpecialAccountType PETTY_CASH = new SpecialAccountType("PettyCash");
  static SpecialAccountType PURCHASE_ORDERS = new SpecialAccountType("PurchaseOrders");
  static SpecialAccountType RECONCILIATION_DIFFERENCES = new SpecialAccountType("ReconciliationDifferences");
  static SpecialAccountType RETAINED_EARNINGS = new SpecialAccountType("RetainedEarnings");
  static SpecialAccountType SALES_ORDERS = new SpecialAccountType("SalesOrders");
  static SpecialAccountType SALES_TAX_PAYABLE = new SpecialAccountType("SalesTaxPayable");
  static SpecialAccountType UNCATEGORIZED_EXPENSES = new SpecialAccountType("UncategorizedExpenses");
  static SpecialAccountType UNCATEGORIZED_INCOME = new SpecialAccountType("UncategorizedIncome");
  static SpecialAccountType UNDEPOSITED_FUNDS = new SpecialAccountType("UndepositedFunds");
}

class CashFlowClassification extends EnumString<CashFlowClassification> {
  CashFlowClassification(String eN):super(eN);

  static CashFlowClassification NONE = new CashFlowClassification("None");
  static CashFlowClassification OPERATING = new CashFlowClassification("Operating");
  static CashFlowClassification INVESTING = new CashFlowClassification("Investing");
  static CashFlowClassification FINANCING = new CashFlowClassification("Financing");
  static CashFlowClassification NOT_APPLICABLE = new CashFlowClassification("NotApplicable");
}

class SalesTaxCountry extends EnumString<SalesTaxCountry> {
  SalesTaxCountry(String eN,[ bool isDefault = false ]):super(eN, isDefault);

  static SalesTaxCountry AUSTRALIA = new SalesTaxCountry("Australia");
  static SalesTaxCountry CANADA = new SalesTaxCountry("Canada");
  static SalesTaxCountry UK = new SalesTaxCountry("UK", true);
  static SalesTaxCountry US = new SalesTaxCountry("US");
}

class JobStatus extends EnumString<JobStatus> {
  JobStatus(String eN,[ bool isDefault = false ]):super(eN, isDefault);

  static JobStatus AWARDED = new JobStatus("Awarded");
  static JobStatus CLOSED = new JobStatus("Closed");
  static JobStatus IN_PROGRESS = new JobStatus("InProgress");
  static JobStatus NONE = new JobStatus("None", true);
  static JobStatus NOT_AWARDED = new JobStatus("NotAwarded");
  static JobStatus PENDING = new JobStatus("Pending");
}


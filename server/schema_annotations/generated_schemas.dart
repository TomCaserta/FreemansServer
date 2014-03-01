/* AUTO GENERATED FILE */
library GeneratedSchema;

// Account Schema: 
Map ACCOUNT_SCHEMA = {"type":"object","name":"Account","additionalProperties":true,"properties":{"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// Terms Schema: 
Map TERMS_SCHEMA = {"type":"object","name":"Terms","additionalProperties":true,"properties":{"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// QBSyncCachable Schema: 
Map QBSYNCCACHABLE_SCHEMA = {"type":"object","name":"QBSyncCachable","additionalProperties":true,"properties":{"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// User Schema: 
Map USER_SCHEMA = {"type":"object","name":"User","additionalProperties":true,"properties":{"username":{"type":"string"},"password":{"oneOf":[{"type":"string"},{"type":"null"}]},"permissions":{"type":"string"},"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// Transport Schema: 
Map TRANSPORT_SCHEMA = {"type":"object","name":"Transport","additionalProperties":true,"properties":{"name":{"type":"string"},"quickbooksName":{"oneOf":[{"type":"string"},{"type":"null"}]},"transportSheetEmail":{"oneOf":[{"type":"string"},{"type":"null"}]},"remittanceEmail":{"oneOf":[{"type":"string"},{"type":"null"}]},"termsRef":{"type":"string"},"terms":{"type":"integer"},"surcharges":{"type":"string"},"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// WorkbookRow Schema: 
Map WORKBOOKROW_SCHEMA = {"type":"object","name":"WorkbookRow","additionalProperties":true,"properties":{"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// ProductWeight Schema: 
Map PRODUCTWEIGHT_SCHEMA = {"type":"object","name":"ProductWeight","additionalProperties":true,"properties":{"description":{"type":"string"},"kg":{"type":"integer"},"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// SalesRow Schema: 
Map SALESROW_SCHEMA = {"type":"object","name":"SalesRow","additionalProperties":true,"properties":{"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// PurchaseRow Schema: 
Map PURCHASEROW_SCHEMA = {"type":"object","name":"PurchaseRow","additionalProperties":true,"properties":{"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// TransportRow Schema: 
Map TRANSPORTROW_SCHEMA = {"type":"object","name":"TransportRow","additionalProperties":true,"properties":{"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// Product Schema: 
Map PRODUCT_SCHEMA = {"type":"object","name":"Product","additionalProperties":true,"properties":{"name":{"type":"string"},"validWeights":{"type":"array"},"validPackaging":{"type":"array"},"quickbooksName":{"oneOf":[{"type":"string"},{"type":"null"}]},"category":{"type":"integer"},"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// ProductPackaging Schema: 
Map PRODUCTPACKAGING_SCHEMA = {"type":"object","name":"ProductPackaging","additionalProperties":true,"properties":{"description":{"type":"string"},"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// ProductCategory Schema: 
Map PRODUCTCATEGORY_SCHEMA = {"type":"object","name":"ProductCategory","additionalProperties":true,"properties":{"categoryName":{"type":"string"},"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// Customer Schema: 
Map CUSTOMER_SCHEMA = {"type":"object","name":"Customer","additionalProperties":true,"properties":{"name":{"type":"string"},"quickbooksName":{"oneOf":[{"type":"string"},{"type":"null"}]},"billto1":{"oneOf":[{"type":"string"},{"type":"null"}]},"billto2":{"oneOf":[{"type":"string"},{"type":"null"}]},"billto3":{"oneOf":[{"type":"string"},{"type":"null"}]},"billto4":{"oneOf":[{"type":"string"},{"type":"null"}]},"billto5":{"oneOf":[{"type":"string"},{"type":"null"}]},"shipto1":{"oneOf":[{"type":"string"},{"type":"null"}]},"shipto2":{"oneOf":[{"type":"string"},{"type":"null"}]},"shipto3":{"oneOf":[{"type":"string"},{"type":"null"}]},"shipto4":{"oneOf":[{"type":"string"},{"type":"null"}]},"shipto5":{"oneOf":[{"type":"string"},{"type":"null"}]},"termsRef":{"type":"string"},"terms":{"type":"integer"},"invoiceEmail":{"oneOf":[{"type":"string"},{"type":"null"}]},"isEmailedInvoice":{"type":"boolean"},"confirmationEmail":{"oneOf":[{"type":"string"},{"type":"null"}]},"isEmailedConfirmation":{"type":"boolean"},"faxNumber":{"oneOf":[{"type":"string"},{"type":"null"}]},"phoneNumber":{"oneOf":[{"type":"string"},{"type":"null"}]},"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// Supplier Schema: 
Map SUPPLIER_SCHEMA = {"type":"object","name":"Supplier","additionalProperties":true,"properties":{"name":{"type":"string"},"quickbooksName":{"oneOf":[{"type":"string"},{"type":"null"}]},"termsRef":{"type":"string"},"terms":{"type":"integer"},"remittanceEmail":{"oneOf":[{"type":"string"},{"type":"null"}]},"confirmationEmail":{"oneOf":[{"type":"string"},{"type":"null"}]},"addressLine1":{"oneOf":[{"type":"string"},{"type":"null"}]},"addressLine2":{"oneOf":[{"type":"string"},{"type":"null"}]},"addressLine3":{"oneOf":[{"type":"string"},{"type":"null"}]},"addressLine4":{"oneOf":[{"type":"string"},{"type":"null"}]},"addressLine5":{"oneOf":[{"type":"string"},{"type":"null"}]},"phoneNumber":{"oneOf":[{"type":"string"},{"type":"null"}]},"faxNumber":{"oneOf":[{"type":"string"},{"type":"null"}]},"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// ProductGroup Schema: 
Map PRODUCTGROUP_SCHEMA = {"type":"object","name":"ProductGroup","additionalProperties":true,"properties":{"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

// WorkbookDay Schema: 
Map WORKBOOKDAY_SCHEMA = {"type":"object","name":"WorkbookDay","additionalProperties":true,"properties":{"ID":{"type":"integer"},"Uuid":{"type":"string"},"isActive":{"type":"boolean"}}};

 // END AUTO GENERATED FILE

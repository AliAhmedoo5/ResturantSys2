import 'package:pos_domain/access_policy.dart';

void main() {
  if (StaffRole.values.length != 2) {
    throw StateError('Exactly Cashier and Manager roles are permitted.');
  }
  const cashierActions = [
    Capability.manageLiveCart,
    Capability.searchCustomerForBilling,
    Capability.confirmCheckout,
    Capability.applyPublishedDiscount,
    Capability.updateFulfillment,
    Capability.openCashierShift,
    Capability.submitBlindCount,
    Capability.reviseConfirmedOrder,
    Capability.cancelConfirmedOrder,
    Capability.recordCollectedFundsRefund,
    Capability.recordCashierPayIn,
    Capability.recordCashierPayOut,
  ];
  const managerActions = [
    Capability.reviewOperations,
    Capability.reviewShiftDiscrepancy,
    Capability.manageBusinessDay,
    Capability.manageCatalogRecipesDeals,
    Capability.manageDiscountDefinitions,
    Capability.manageInventory,
    Capability.manageSuppliersPurchases,
    Capability.manageStaffPayroll,
    Capability.manageCredentials,
    Capability.manageExpenseCategories,
    Capability.postAdministrativeFinance,
    Capability.manageShortcuts,
    Capability.manageSecuritySettings,
    Capability.manageBackupsRestore,
    Capability.viewManagementReports,
    Capability.manageReportDelivery,
  ];
  for (final action in cashierActions) {
    AccessPolicy.require(StaffRole.cashier, action);
    _denied(StaffRole.manager, action);
  }
  for (final action in managerActions) {
    AccessPolicy.require(StaffRole.manager, action);
    _denied(StaffRole.cashier, action);
  }
  for (final role in StaffRole.values) {
    AccessPolicy.require(role, Capability.lockOwnSession);
    _denied(role, Capability.rewritePostedHistory);
    _denied(role, Capability.operateRiderTrips);
  }
  AccessPolicy.require(StaffRole.cashier, Capability.operateRiderTrips,
      riderOperationsEnabled: true);
  _denied(StaffRole.manager, Capability.operateRiderTrips,
      riderOperationsEnabled: true);

  // Every added capability must receive an explicit acceptance decision.
  final covered = {
    ...cashierActions,
    ...managerActions,
    Capability.lockOwnSession,
    Capability.operateRiderTrips,
    Capability.rewritePostedHistory
  };
  if (covered.length != Capability.values.length) {
    throw StateError('A capability is missing role acceptance coverage.');
  }
  print(
      'Passed two-role separation, routine cashier rights and rider feature gate.');
}

void _denied(StaffRole role, Capability action,
    {bool riderOperationsEnabled = false}) {
  try {
    AccessPolicy.require(role, action,
        riderOperationsEnabled: riderOperationsEnabled);
  } on AuthorizationDenied {
    return;
  }
  throw StateError('Forbidden role/action pair was accepted: $role / $action');
}

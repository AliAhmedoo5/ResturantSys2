/// Supervisor and Owner are display names for Manager, never extra roles.
enum StaffRole { cashier, manager }

enum Capability {
  lockOwnSession,
  manageLiveCart,
  searchCustomerForBilling,
  confirmCheckout,
  applyPublishedDiscount,
  updateFulfillment,
  operateRiderTrips,
  openCashierShift,
  submitBlindCount,
  reviseConfirmedOrder,
  cancelConfirmedOrder,
  recordCollectedFundsRefund,
  recordCashierPayIn,
  recordCashierPayOut,
  reviewOperations,
  reviewShiftDiscrepancy,
  manageBusinessDay,
  manageCatalogRecipesDeals,
  manageDiscountDefinitions,
  manageInventory,
  manageSuppliersPurchases,
  manageStaffPayroll,
  manageCredentials,
  manageExpenseCategories,
  postAdministrativeFinance,
  manageShortcuts,
  manageSecuritySettings,
  manageBackupsRestore,
  viewManagementReports,
  manageReportDelivery,
  rewritePostedHistory,
}

final class AuthorizationDenied implements Exception {
  const AuthorizationDenied();

  @override
  String toString() => 'This action is not permitted for the current role.';
}

/// Role eligibility only, not authentication, approval or financial validation.
/// Services must obtain the role from a current persisted authenticated session,
/// recheck active credentials and enforce entity/day/shift locks transactionally.
abstract final class AccessPolicy {
  static bool allows(
    StaffRole role,
    Capability capability, {
    bool riderOperationsEnabled = false,
  }) => switch (capability) {
    Capability.lockOwnSession => true,
    Capability.operateRiderTrips =>
      role == StaffRole.cashier && riderOperationsEnabled,
    Capability.manageLiveCart ||
    Capability.searchCustomerForBilling ||
    Capability.confirmCheckout ||
    Capability.applyPublishedDiscount ||
    Capability.updateFulfillment ||
    Capability.openCashierShift ||
    Capability.submitBlindCount ||
    Capability.reviseConfirmedOrder ||
    Capability.cancelConfirmedOrder ||
    Capability.recordCollectedFundsRefund ||
    Capability.recordCashierPayIn ||
    Capability.recordCashierPayOut => role == StaffRole.cashier,
    Capability.reviewOperations ||
    Capability.reviewShiftDiscrepancy ||
    Capability.manageBusinessDay ||
    Capability.manageCatalogRecipesDeals ||
    Capability.manageDiscountDefinitions ||
    Capability.manageInventory ||
    Capability.manageSuppliersPurchases ||
    Capability.manageStaffPayroll ||
    Capability.manageCredentials ||
    Capability.manageExpenseCategories ||
    Capability.postAdministrativeFinance ||
    Capability.manageShortcuts ||
    Capability.manageSecuritySettings ||
    Capability.manageBackupsRestore ||
    Capability.viewManagementReports ||
    Capability.manageReportDelivery => role == StaffRole.manager,
    Capability.rewritePostedHistory => false,
  };

  static void require(
    StaffRole role,
    Capability capability, {
    bool riderOperationsEnabled = false,
  }) {
    if (!allows(role, capability,
      riderOperationsEnabled: riderOperationsEnabled)) {
      throw const AuthorizationDenied();
    }
  }
}

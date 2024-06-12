class Subscription {
    final String customerId;
    final String customerType;
    final int? subscriptionStart;
    final int currentPeriodEnd;
    final String region;
    final DateTime expires;
    final bool? paymentFailed;
    final String? scheduledProductId;
    final bool? isCancelled;
    final int? slfLicense;
    final int? usedSlfLicense;
    final int? scheduledSlfLicense;

    Subscription({
        required this.customerId,
        required this.customerType,
        required this.subscriptionStart,
        required this.currentPeriodEnd,
        required this.region,
        required this.expires,
        required this.paymentFailed,
        required this.scheduledProductId,
        required this.isCancelled,
        required this.slfLicense,
        required this.usedSlfLicense,
        required this.scheduledSlfLicense,
    });

    factory Subscription.fromMap(Map<String, dynamic> json) => Subscription(
        customerId: json["customer_id"],
        customerType: json["customer_type"],
        subscriptionStart: json["subscription_start"],
        currentPeriodEnd: json["current_period_end"],
        region: json["region"],
        expires: DateTime.parse(json["expires"]),
        paymentFailed: json["payment_failed"],
        scheduledProductId: json["scheduled_product_id"],
        isCancelled: json["is_cancelled"],
        slfLicense: json["slf_license"],
        usedSlfLicense: json["used_slf_license"],
        scheduledSlfLicense: json["scheduled_slf_license"],
    );

    Map<String, dynamic> toMap() => {
        "customer_id": customerId,
        "customer_type": customerType,
        "subscription_start": subscriptionStart,
        "current_period_end": currentPeriodEnd,
        "region": region,
        "expires": expires.toIso8601String(),
        "payment_failed": paymentFailed,
        "scheduled_product_id": scheduledProductId,
        "is_cancelled": isCancelled,
        "slf_license": slfLicense,
        "used_slf_license": usedSlfLicense,
        "scheduled_slf_license": scheduledSlfLicense,
    };
}
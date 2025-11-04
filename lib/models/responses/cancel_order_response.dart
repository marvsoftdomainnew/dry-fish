class CancelOrderResponse {
  final bool status;
  final String message;

  CancelOrderResponse({
    required this.status,
    required this.message,
  });

  factory CancelOrderResponse.fromJson(Map<String, dynamic> json) {
    return CancelOrderResponse(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
class Response{

  /// If the operation was successful
  bool success ;
  /// Message to be displayed, success or error codes
  String message;

  /// Constructor, takes the [success] and [message]
  Response(this.success, this.message);


}
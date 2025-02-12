class ContactModel {
  String name;
  String status;
  bool select = false;

  ContactModel({
    required this.name,
    required this.status,
    this.select = false,
  });
}

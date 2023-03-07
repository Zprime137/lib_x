import 'package:example/src/src.dart';

class UserProvider extends DataProvider<UserModel> {
  // Declare the desired data you want the provider to provide
  final UserModel userModel;

  const UserProvider({
    super.key,
    required this.userModel, // first argument: require the declared data object
    required super.child, // second argument: require & pass child to the super class
  }) : super(data: userModel); // pass the data to the super class

  // third argument: without it the class is useless
  // Declare a static method that returns the provider instance of(context)
  static UserProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserProvider>()!;
  // just copy the method and change the class name.
}

class UserModel extends StatefulData {
  final String id;
  String username;

  UserModel({required this.id, required this.username});

  void updateUsername(String newName) {
    username = newName;
    update();
  }
}

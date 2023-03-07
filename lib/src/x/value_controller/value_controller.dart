import 'package:lib_x/lib_x.dart';

class ValueController<T> {
  /// private: ValueNotifier
  late ValueNotifier<T> _notifier;

  /// public: ValueListenable "the private ValueNotifier"
  late ValueListenable listenable = _notifier;

  /// public: value of the private ValueNotifier
  late T value = _notifier.value;

  /// constructor to set the private notifier value
  ValueController(this.value) {
    _notifier = ValueNotifier<T>(value);
  }

  /// to update the value of the notifier and trigger ReactiveBuilder to rebuild
  void update(T v) {
    value = v;
    _notifier.value = v;
  }

  /// setter: if you want to attach callback when value changes
  set onChange(VoidCallback callback) => _notifier.addListener(callback);

  /// to dispose the controller,  you must not use the controller after dispose()
  void dispose() => _notifier.dispose();
}

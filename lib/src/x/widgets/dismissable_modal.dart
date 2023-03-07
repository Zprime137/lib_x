import 'package:lib_x/lib_x.dart';

// used by X.showModal to make dialog dismissable
class DismissableModal extends StatelessWidget {
  final Widget child;
  const DismissableModal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () => X.pop(),
        ),
        child,
      ],
    );
  }
}

// E.g.
// class MyDialog extends StatelessWidget {
//   const MyDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Dialog'));
//   }
// }

// class ShowMyDialogButton extends StatelessWidget {
//   const ShowMyDialogButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () => showDialog(
//         context: context,
//         barrierDismissible: true, // not reliable
//         builder: (context) {
//           return const DismissableModal(child: MyDialog());
//         },
//       ),
//       child: const Text('Show Dismissable Dialog'),
//     );
//   }
// }

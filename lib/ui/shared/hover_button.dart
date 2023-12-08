import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';
enum TranslateTo { left, right }

class HoverButton extends StatefulWidget {
  final Widget child;
  final TranslateTo translateTo;

  HoverButton({required this.child, required this.translateTo});

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovering = false;
  Matrix4 _transform = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    if (_isHovering) {
      _transform = Matrix4.identity();
      _transform.scale(1.1);
      _transform.translate(
        widget.translateTo == TranslateTo.left ? -25.0 : 25.0,
        3.0,
      );
    } else {
      _transform = Matrix4.identity();
    }

    return MouseRegion(
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: _transform,
        child: widget.child,
      ),
    );
  }
}

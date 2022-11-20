import 'package:flutter/material.dart';
import 'package:flutter_shader_glsl/shader_component.dart';

class FullscreenShader extends StatefulWidget {
  final String shaderPath;

  const FullscreenShader({
    required this.shaderPath,
    super.key,
  });

  @override
  State<FullscreenShader> createState() => _FullscreenShaderState();
}

class _FullscreenShaderState extends State<FullscreenShader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(children: [
        ShaderComponent(
          shaderPath: widget.shaderPath,
          enabled: ValueNotifier<bool>(true),
        ),
        Builder(
          builder: (innerContext) => Positioned(
            right: 0,
            bottom: 0,
            child: Column(children: [
              Text('Widgth: ${MediaQuery.of(innerContext).size.width}'),
              Text('Height: ${MediaQuery.of(innerContext).size.height}')
            ]),
          ),
        ),
      ]),
    );
  }
}

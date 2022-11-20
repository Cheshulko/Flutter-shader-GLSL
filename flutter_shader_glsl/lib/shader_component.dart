import 'dart:ui';

import 'package:flutter/material.dart';

const _precision = 1000000;

class ShaderComponent extends StatefulWidget {
  final String shaderPath;
  final ValueNotifier<bool> enabled;

  final Widget? child;

  const ShaderComponent({
    required this.shaderPath,
    required this.enabled,
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<ShaderComponent> createState() => _ShaderComponentState();
}

class _ShaderComponentState extends State<ShaderComponent>
    with TickerProviderStateMixin {
  Duration elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initTicker();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: FutureBuilder<FragmentProgram>(
        future: _initShader(widget.shaderPath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ValueListenableBuilder<bool>(
                valueListenable: widget.enabled,
                builder: (context, enabled, child) {
                  if (enabled) {
                    return ShaderMask(
                      shaderCallback: (bounds) {
                        return snapshot.data!.fragmentShader()
                          ..setFloat(0, elapsedTime.inMicroseconds / _precision)
                          ..setFloat(1, bounds.width)
                          ..setFloat(2, bounds.height);
                      },
                      child: Container(
                        color: Colors.white,
                        child: widget.child,
                      ),
                    );
                  } else {
                    return Container(
                      color: Colors.white,
                      child: widget.child ?? const SizedBox.expand(),
                    );
                  }
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _initTicker() async {
    await createTicker((elapsed) {
      setState(() {
        elapsedTime = elapsed;
      });
    }).start();
  }

  Future<FragmentProgram> _initShader(String shaderPath) {
    return FragmentProgram.fromAsset(shaderPath);
  }
}

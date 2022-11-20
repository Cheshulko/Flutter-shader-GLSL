import 'package:flutter/material.dart';
import 'package:flutter_shader_glsl/assets.dart';
import 'package:flutter_shader_glsl/fullscreen_shader.dart';
import 'package:flutter_shader_glsl/shader_component.dart';
import 'package:statsfl/statsfl.dart';

const _testShaderPaths = [
  Assets.shader1Path,
  Assets.shader2Path,
  Assets.shader3Path,
  Assets.shader4Path,
];

void main() {
  runApp(
    StatsFl(
      isEnabled: true,
      align: Alignment.topRight,
      height: 54,
      child: const IntroApp(),
    ),
  );
}

class IntroApp extends StatefulWidget {
  const IntroApp({
    super.key,
  });

  @override
  State<IntroApp> createState() => _IntroAppState();
}

class _IntroAppState extends State<IntroApp> {
  late List<_ShaderData> _shaderData;

  @override
  void initState() {
    _shaderData = List.generate(
      _testShaderPaths.length,
      (index) => _ShaderData(
        path: _testShaderPaths[index],
        enabled: ValueNotifier<bool>(false),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Flutter Shaders Test';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          children: List.generate(_testShaderPaths.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ShaderComponent(
                      enabled: _shaderData[index].enabled,
                      shaderPath: _testShaderPaths[index],
                      child: ValueListenableBuilder<bool>(
                          valueListenable: _shaderData[index].enabled,
                          builder: (context, enabled, child) {
                            if (enabled) {
                              return const SizedBox.expand();
                            } else {
                              return Center(
                                child:
                                    Text('Shader: ${_shaderData[index].path}'),
                              );
                            }
                          }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    ElevatedButton(
                      onPressed: () {
                        _shaderData[index].enabled.value =
                            !_shaderData[index].enabled.value;
                      },
                      child: const Text('On/Off'),
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (innerContext) => ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            innerContext,
                            MaterialPageRoute(
                              builder: (innerContext) => FullscreenShader(
                                shaderPath: _shaderData[index].path,
                              ),
                            ),
                          );
                        },
                        child: const Text('Fullscreen'),
                      ),
                    ),
                  ]),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _ShaderData {
  final String path;
  final ValueNotifier<bool> enabled;

  _ShaderData({
    required this.path,
    required this.enabled,
  });
}

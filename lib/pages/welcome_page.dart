import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/welcome_controller.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WelcomeController>(
      init: WelcomeController(),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              // 背景图片
              Obx(() => controller.imageUrl.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Image.network(
                      controller.imageUrl.value,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    )),

              // 渐变遮罩层
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),

              // 内容层
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          // 文字描边效果
                          Text(
                            '欢迎使用',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.black.withOpacity(0.5),
                            ),
                          ),
                          const Text(
                            '欢迎使用',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // 刷新按钮
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: controller.refreshImage,
                          borderRadius: BorderRadius.circular(30),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: controller.onEnterPressed,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: const Text(
                          '开始使用',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

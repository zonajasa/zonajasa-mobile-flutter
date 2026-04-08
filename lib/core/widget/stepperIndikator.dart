import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalStep;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalStep,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double lineWidth = totalStep > 1
        ? (screenWidth - 130) / (totalStep - 1)
        : 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: List.generate(totalStep, (index) {
        int step = index + 1;
        bool isActive = step == currentStep;
        bool isCompleted = step < currentStep;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CIRCLE
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isActive || isCompleted
                    ? const Color(0xff1a1a6e)
                    : Colors.white,
                border: Border.all(color: const Color(0xff1a1a6e), width: 2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "$step",
                  style: TextStyle(
                    color: isActive || isCompleted
                        ? Colors.white
                        : const Color(0xff1a1a6e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // LINE
            if (step != totalStep)
              Container(
                width: lineWidth,
                height: 2,
                color: step < currentStep
                    ? const Color(0xff1a1a6e)
                    : Colors.grey.shade300,
              ),
          ],
        );
      }),
    );
  }
}

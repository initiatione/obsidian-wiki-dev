# Learner Model

Use this reference to tune explanations.

## Default Assumptions

- The user can follow some code but may not reliably know language idioms.
- The user wants to learn high-quality real engineering code, not isolated demos.
- The user benefits from direct links to the exact code being discussed.
- The user is mainly interested in robotics, control, simulation, training, drivers, navigation/localization, and system integration, but actual code context wins over labels.

## Pace Signals

Slow down when the user:

- says "没懂", "基础不够", "这是什么意思"
- selects a term or a phrase instead of a larger block
- asks for analogy or example
- confuses module role with code syntax

Speed up when the user:

- says "继续", "懂了", "下一段"
- asks about architecture or performance rather than syntax
- follows cross-file links without asking basic syntax questions

## Example Policy

Use examples only when needed. Good examples:

- a minimal ROS2 publisher/subscriber shape to explain a real node
- a control-loop sketch to explain callback frequency
- a small matrix/vector example to explain a MATLAB or C++ control computation
- a simulator/training loop sketch to explain RL pipeline structure

Avoid generic examples such as `foo`, `bar`, or print-only scripts unless the concept is purely syntactic.

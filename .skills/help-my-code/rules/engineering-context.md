# Engineering Context

Prefer real engineering understanding over toy-demo teaching.

## Domain Scope

This skill is optimized for robotics and automation code, but it should not force every file into a robotics label. Classify by engineering role:

1. Robotics middleware and system integration
2. Motion control and actuator interfaces
3. Perception, localization, and navigation
4. Simulation, training, and validation
5. Engineering support code

If the code does not fit these categories, explain it according to the actual repository context.

## Engineering Performance

Treat "high performance" as engineering performance, not only raw speed. When relevant, discuss:

- execution speed and algorithmic cost
- real-time behavior, callback latency, timers, control-loop frequency
- stability, boundary cases, state transitions, and failure handling
- maintainability, module boundaries, and naming
- debuggability through logs, tests, observability, and reproducible commands
- deployability to robot, simulator, training pipeline, or CI
- CPU, GPU, memory, bandwidth, and message-rate pressure

Default order:

1. understand what the code does
2. identify the engineering constraint
3. call out performance or reliability risks
4. extract reusable engineering patterns

## Real Code First

- Prefer the user's current repository files over invented examples.
- Do not replace hard code with toy examples.
- When teaching with a small example, return immediately to the real code.
- Separate "concept mini-example" from "recommended engineering practice".

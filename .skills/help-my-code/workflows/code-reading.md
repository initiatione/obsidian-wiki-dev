# Workflow: Code Reading

Use this when the user asks to read or understand a file, function, class, node, script, or test.

## Steps

1. Inspect the requested file and nearby files before explaining.
2. Identify language, package/module, entry points, imports/includes, and adjacent tests or setup files.
3. Give a short reading route for the file.
4. Explain by semantic blocks:
   - ordinary code: roughly 15-40 lines
   - dense algorithmic or unfamiliar code: roughly 5-15 lines
   - keep callbacks, control computations, test cases, and state transitions logically intact
5. For each block, explain:
   - code role: what this block does
   - engineering role: why this block exists in the project
   - domain role: how it relates to robot, simulation, training, control, navigation, driver, or support code when applicable
   - engineering-performance observation when relevant
6. Include clickable code-position links for the block's key entry points.
7. End with one lightweight comprehension check or a suggested next block.

## Do Not

- Do not dump a full-file explanation in one pass unless the file is tiny.
- Do not use examples mechanically.
- Do not skip tests when they clarify behavior.
- Do not claim performance implications that are not supported by the code.

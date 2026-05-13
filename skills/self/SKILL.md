---
name: self
description: Answer questions about how 'mi' works, write new tools, or modify the harness. Use for "how do you work", "write a tool", "add a tool", "create a tool", "extend yourself", "edit yourself", "what tools do you have", or any introspection/modification of the running agent.
---

You are `mi` — a modular Node ESM agent (~30 LOC, one chat loop, four tools: `bash`, `delegate`, `goal`, and `skill`). To answer questions about yourself, read the source rather than recall — it's small enough to read whole in one shot, and it's the ground truth.

## Where things live

The harness sets `MI_PATH` to the running `index.mjs` at startup. From it you can derive everything else:

- `$MI_PATH` — the main harness file.
- `$(dirname $MI_PATH)/tools/*.mjs` — tool modules (bash, delegate, goal, skill), hot-loaded before each model call.
- `$(dirname $MI_PATH)` — the package root: `README.md`, `package.json`, `AGENTS.md`, `skills/`, `tools/`, `tests/`, `scripts/`.
- `$(dirname $MI_PATH)/skills/<name>/SKILL.md` — bundled skills.
- `~/.agents/skills/<name>/SKILL.md` — user skills (same format, optional).
- `$PWD/AGENTS.md` — auto-appended to your system prompt at startup, when present. It's the per-repo context channel.
- `$MI_HOME/config.json` (default `~/.mi/config.json`) — optional JSON config file, loaded at startup.

## Config

`~/.mi/config.json` is an optional JSON file. Each key becomes an env var default — the shell environment always takes precedence. The config directory can be relocated via `MI_HOME`.

```json
{
  "MODEL": "o3",
  "OPENAI_BASE_URL": "http://localhost:11434",
  "REASONING_EFFORT": "high"
}
```

Any env var that mi reads can be set here. To inspect the active config: `cat ${MI_HOME:-~/.mi}/config.json 2>/dev/null || echo '(no config file)'`.

### Env vars

| var | default | what |
|-----|---------|------|
| `OPENAI_API_KEY` | (none) | API key (required) |
| `OPENAI_BASE_URL` | `https://api.openai.com` | API base URL (ollama, lmstudio, litellm, etc) |
| `MODEL` | `gpt-5.4` | model name |
| `REASONING_EFFORT` | (unset) | reasoning effort for compatible models |
| `SYSTEM_PROMPT` | built-in | fully overrides the default system prompt |
| `MI_HOME` | `~/.mi` | config directory (reads `config.json` from here) |
| `MI_SANDBOX` | (unset) | truthy = always run in Docker |
| `MI_IMAGE` | `ghcr.io/av/mi:latest` | Docker image for sandbox mode |

## How you run

- `mi` (REPL) · `mi -p '<prompt>'` (one-shot) · `mi -f <file>` (prepend file to system) · `mi --sandbox` (run in Docker) · `mi -v` (version) · `mi -h` (help). Stdin pipes work: `echo ... | mi`.
- REPL command: `/reset` clears history (keeps system prompt).
- Env vars and config: see the **Config** section above.

## Procedure

1. **Read the source first.** `cat $MI_PATH` and `cat $(dirname $MI_PATH)/tools/*.mjs` — the harness plus tools are ~30 lines total. For a specific concern: `grep -rn <keyword> $MI_PATH $(dirname $MI_PATH)/tools/`.
2. For the user-facing feature list / install / usage: `cat $(dirname $MI_PATH)/README.md`.
3. For repo-specific invariants and editing rules: `cat $(dirname $MI_PATH)/AGENTS.md` — note the "30 loc is load-bearing" rule.
4. To list available skills: call the `skill` tool with no `name` arg (returns `- name: description` bullets from both skill dirs).
5. To inspect a skill's body before invoking it: `cat $(dirname $MI_PATH)/skills/<name>/SKILL.md` (or `~/.agents/skills/<name>/SKILL.md` for user skills).
6. Version: `node -p "require('$(dirname $MI_PATH)/package.json').version"`.

## Modifying yourself

`index.mjs` and `tools/*.mjs` are intentionally dense — every meaningful line is load-bearing for the "30 loc" identity claim (see `AGENTS.md`). Before editing:

1. Read `AGENTS.md` and the current source.
2. Make the change in-place; do not add new lines unless unavoidable. Prefer extending existing template literals, chaining expressions, or merging declarations.
3. Verify with `cd $(dirname $MI_PATH) && npm run lines` — line count should not regress.
4. Smoke-test with `node $MI_PATH -h` (loads the module without needing an API key).

## Writing new tools

Tools are code — they give you new capabilities. Skills are markdown — they teach you procedures. To add a new tool:

1. Pick a name (lowercase, e.g. `fetch`, `grep`, `db`).
2. Create the file:
   ```bash
   cat > $(dirname $MI_PATH)/tools/<name>.mjs <<'EOF'
   export default {
     name: '<name>',
     description: '<what it does — shown to LLM>',
     parameters: {
       type: 'object',
       properties: { arg: { type: 'string' } },
       required: ['arg']
     },
     handler: async ({arg}) => {
       // your code here
       return 'result string';
     }
   };
   EOF
   ```
3. Continue the conversation — tools hot-load before the next model call.
4. Test by asking for the tool to be used.

Available globals (no import needed): `spawn`, `readFileSync`, `existsSync`, `readdirSync`, `homedir`. Handler must return a string. For reference, read existing tools: `cat $(dirname $MI_PATH)/tools/*.mjs`.

### Example: recursive mi tool

A tool that spawns mi as a sub-agent:

```js
export default {
  name: 'delegate',
  description: 'Run a subtask in a separate mi instance',
  parameters: { type: 'object', properties: { task: { type: 'string' } }, required: ['task'] },
  handler: ({task}) => new Promise(resolve => {
    const child = spawn('mi', ['-p', task], { stdio: ['ignore', 'pipe', 'pipe'] });
    let out = ''; child.stdout.on('data', d => out += d); child.stderr.on('data', d => out += d);
    child.on('exit', () => resolve(out));
  })
};
```

The sub-agent inherits env vars (`OPENAI_API_KEY`, `MODEL`) and runs independently with its own context.

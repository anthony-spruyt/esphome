---
name: block-recursive-config-read
enabled: true
event: bash
action: block
pattern: (?:^|[\s;&|(])[ef]?grep(?:\s+-\S+)*?\s+(?:-[a-zA-Z]*[rR][a-zA-Z]*|--(?:dereference-)?recursive)(?=\s|$)|(?:^|[\s;&|(])rg\s(?:[^|;&]*\s)?(?:-[a-zA-Z]*u[a-zA-Z]*|--no-ignore[\w-]*)(?=\s|$)|(?:-exec|xargs(?:\s+-\S+)*)\s+(?:cat|[ef]?grep|rg|head|tail|less|more|sed|awk|strings|base64|xxd|od)\b|(?:^|[\s'"])(?:\./)?config/[^\s/'"]*[*?\[]
---

🚫 **Blocked: recursive or glob read that can reach `config/secrets.yaml`**

**What was blocked:** `grep -r`, `rg -u` / `--no-ignore`, `find -exec cat`, `xargs grep`, or a glob like `config/*` that would pull `config/secrets.yaml` into the output.

**Why:** the `Read(config/secrets.yaml)` deny rule only covers file tools. A recursive shell search leaked the API key once already.

**Use instead:** the Grep tool, or plain `rg` (it skips `secrets.yaml` because `config/.gitignore` lists it), or grep one named file.

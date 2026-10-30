# qq: quick questions in your terminal

Ask Claude a terminal question without leaving the terminal:

```
$ qq how do i list files newest first?
  ls -lt          # newest first
  ls -ltr         # oldest first
```

No quotes, no chat window. You get one short answer and you're back to work.

## Setup (the easy way)

You need [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and logged in.

```
git clone https://github.com/jamilt0n/qq.git
cd qq
claude
```

Then tell Claude: **"Set this up for me."** It reads the instructions in this folder and handles the rest.

<details>
<summary>Setup (by hand)</summary>

```
./install.sh
```

Then open a new terminal window. To remove it later, run `./install.sh --uninstall`.
</details>

## Using it

| You type | What happens |
|---|---|
| `qq how do i copy a folder` | Short answer, commands first |
| `qq -x how do i copy a folder` | Same answer, plus what each part means (`cp -r`: **c**o**p**y, **r**ecursive) |
| `qqr` | Show the last answer again (handy after it scrolled away) |
| `qqr 3` | Show the 3rd most recent answer |
| `qqr -l` | List your last 5 questions |
| `cat error.txt \| qq what does this mean` | Send it some text to look at |
| `qq -h` | Help |

Flags go **before** the question: `qq -x ...`, not `qq ... -x`.

### Things that need quotes

The terminal treats a few characters specially before `qq` ever sees them. If your question contains an apostrophe (`what's`) or any of `| ; & < >`, wrap the whole question in double quotes:

```
qq "what's the difference between > and >>"
```

Or skip the apostrophe: `qq whats the difference...`.

## Settings

Add these to your shell startup file (`~/.zshrc` on a Mac) if you want them:

```
export QQ_EXPLAIN=1       # always explain, as if you typed -x
export QQ_MODEL=sonnet    # smarter but slower than the default (haiku)
```

## Updating

```
cd qq && git pull
```

The installed `qq` points at this folder, so it updates immediately.

## How it works

`qq` is a short bash script. It runs Claude Code in one-shot mode (`claude -p`) with a small prompt that says "you're a terminal helper, be brief." It also tells Claude which OS and shell you're on. Claude can't run anything or touch your files; it only answers. Your last 5 answers are saved in `~/.local/state/qq/` so `qqr` can show them again.

Works on macOS, Linux, and WSL. On Windows, use WSL or Git Bash.

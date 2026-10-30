# Setting up qq

The person you're talking to probably cloned this repo because a friend told them to, and they're likely **new to the terminal**. When they ask you to set it up, do it for them, and explain in plain language without jargon. Keep it short and friendly.

## What qq is

`qq` (and `qqr`) are small bash scripts that call `claude -p` to answer terminal questions in one shot. See `README.md`. `install.sh` does the whole setup:

- links `qq` and `qqr` into `~/.local/bin`
- adds one marked block (`# >>> qq >>>` … `# <<< qq <<<`) to their shell startup file: `~/.zshrc` for zsh; `~/.bashrc` (Linux) or `~/.bash_profile` (macOS) for bash
- you can safely run it again; `./install.sh --uninstall` reverses it

## Setup steps

1. **Check the platform.** Run `uname -s` and `echo $SHELL`.
   - macOS, Linux, or WSL with zsh or bash: continue.
   - Native Windows (PowerShell/cmd): stop. Explain that qq is a bash tool and needs WSL or Git Bash, and offer to walk them through that instead. Don't try to port it.
   - Other shells (fish, etc.): explain that `install.sh` won't edit their config. Help them add `~/.local/bin` to PATH by hand.
2. **Run the installer:** `./install.sh`
3. **Verify it works** before telling them it's done:
   - `"$HOME/.local/bin/qq" -h` prints help
   - `"$HOME/.local/bin/qq" how do i list files newest first` returns a short answer. This makes a real Claude call, which is fine.
4. **Ask one question:** "Do you want qq to always explain what each part of a command means? Recommended while you're learning." If yes, add `export QQ_EXPLAIN=1` **inside** the qq block in their startup file (before the `# <<< qq <<<` line), so uninstall removes it too.
5. **Tell them what to do next**, roughly:
   > All set. Open a **new** terminal window (the current one won't know about qq yet), then try:
   > `qq how do i see what folder i am in`
   > `qq -x how do i make a new folder` (the -x explains each part)
   > `qqr` shows the last answer again.

   Mention the quoting gotcha once, briefly: questions with an apostrophe (`what's`) need double quotes around the whole question.

## Rules

- Don't install other tools, change other parts of their shell config, or "improve" their setup unless they ask.
- If something fails, show them the exact error in plain words and fix it. Don't just hand them commands to run.
- If they ask how qq works or want to change it, `qq` is a short, commented bash script. Walk them through it.

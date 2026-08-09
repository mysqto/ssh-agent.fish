# ssh-agent.fish

One ssh-agent per machine, not one per terminal.

## Install

```fish
fisher install mysqto/ssh-agent.fish
```

## Why

The usual `eval (ssh-agent -c)` in a shell startup file spawns a fresh agent for
every terminal you open, so your keys have to be unlocked again in each one and
orphaned agents pile up in the process table.

This plugin reuses an agent whenever it can find one, and starts a new agent
only when it genuinely cannot.

## How it works

On an interactive shell, `init_ssh_agent` tries in order:

1. **The agent in the environment.** If `$SSH_AUTH_SOCK` points at a live
   socket, use it and stop.
2. **An agent already running.** Walk `pgrep ssh-agent`, recover each agent's
   socket via `lsof`, test it, and adopt the one holding the most keys. This
   also picks up sockets belonging to a forwarding `sshd`, not just `ssh-agent`.
3. **A new agent.** Only if both of the above fail.

It then exports `SSH_AUTH_SOCK` and `SSH_AGENT_PID` and prints them. If the
agent still fails to answer, both variables are erased rather than left
pointing at a dead socket.

## Configuration

To stop the agent from starting automatically:

```fish
set -U ssh_agent_autostart 0
```

`init_ssh_agent` remains available to call by hand.

## Functions

| Function | Purpose |
| --- | --- |
| `init_ssh_agent` | Find, adopt, or start an agent. Run from `conf.d`. |
| `find_ssh_sock` | Scan running processes for a usable agent socket. |
| `singleton_ssh_agent` | Kill every agent except the one in use. |

## Requirements

- fish 3.0+
- `ssh-add`, `ssh-agent`
- `pgrep`, `lsof`

## License

[MIT](LICENSE)

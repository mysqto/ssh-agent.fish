# Start (or adopt) an ssh-agent for interactive shells.
#
# init_ssh_agent prefers, in order: the agent already in $SSH_AUTH_SOCK, any
# reusable agent found among running processes, and only then a fresh one.
#
# To opt out of starting an agent automatically:
#     set -U ssh_agent_autostart 0

if status is-interactive
    if not set -q ssh_agent_autostart; or test "$ssh_agent_autostart" != 0
        init_ssh_agent
    end
end

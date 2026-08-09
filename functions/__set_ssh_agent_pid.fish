function __set_ssh_agent_pid -d "Try to set SSH_AGENT_PID"

	if begin; test -z "$SSH_AGENT_PID"; and test -n "$SSH_AUTH_SOCK"; end
		# On BSD/macOS fuser writes the pid to stdout and the filename to
		# stderr, so this captures just the pid.
		set -l agent (fuser $SSH_AUTH_SOCK 2>/dev/null)

		if test -n "$agent"
			set -gx SSH_AGENT_PID $agent[1]
		end
    end

end

function __set_ssh_agent_pid -d "Try to set SSH_AGENT_PID"

	if begin; test -z "$SSH_AGENT_PID"; and test -n "$SSH_AUTH_SOCK"; end
		set agent (fuser $SSH_AUTH_SOCK 2>/dev/null)
		setenv SSH_AGENT_PID $agent
    end

end

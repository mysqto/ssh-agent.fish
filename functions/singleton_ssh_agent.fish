function singleton_ssh_agent -d "Keep one instance of ssh-agent"

	set -l agent $SSH_AGENT_PID

	if test -z "$agent"
		find_ssh_sock
	else
		set -l agents (pgrep ssh-agent)
		set -l ssh_agent_pid $SSH_AGENT_PID
		for agent in $agents
			if test ! $ssh_agent_pid -eq $agent
				 env SSH_AGENT_PID=$agent ssh-agent -k >/dev/null 2>&1
			end
		end	
	end
end

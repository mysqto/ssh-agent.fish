function find_ssh_sock -d "try to find ssh-agent and ssh auth sock"

	set agents (pgrep ssh-agent)

	set keys  0

	for agent in $agents

		set result (lsof -p $agent | grep unix | tr -s ' ' | tr ' ' '\n')

		set index (count $result)

		if test "type=STREAM" =  $result[$index]
			set index (math $index - 1)
		end

		set socket $result[$index]

		__test_ssh_socket $socket

		if test 0 -eq $status
			ssh-add -l >/dev/null 2>&1
			if test 0 -eq $status
				if test (ssh-add -l | wc -l) -ge keys
					set agent_pid  $agent
					set agent_sock $socket
					set keys (ssh-add -l | wc -l)
				end
			end
		end
	end

	if begin;  test ! -z "$agent_pid"; and test ! -z "$agent_socket"; end
		setenv SSH_AUTH_SOCK $socket
		setenv SSH_AGENT_PID $agent
		return 0
	else
		return 1
	end
end

function find_ssh_sock -d "try to find ssh-agent and ssh auth sock"

	set -l agents (pgrep ssh-agent)

	set -l keys 0
	set -l agent_pid
	set -l agent_sock

	for agent in $agents

		set -l result (lsof -p $agent | grep unix | tr -s ' ' | tr ' ' '\n')

		set -l index (count $result)

		if test 1 -gt $index
			continue
		end

		if test "type=STREAM" = $result[$index]
			set index (math $index - 1)
		end

		if test 1 -gt $index
			continue
		end

		set -l socket $result[$index]

		__test_ssh_socket $socket

		if test 0 -ne $status
			continue
		end

		# Count keys through this candidate's own socket. A bare `ssh-add -l`
		# queries whatever agent is already in the environment, which would
		# score every candidate identically.
		set -l listing (env SSH_AUTH_SOCK=$socket ssh-add -l 2>/dev/null | string match -v -- '*no identities*')
		set -l candidate_keys (count $listing)

		if test $candidate_keys -ge $keys
			set agent_pid $agent
			set agent_sock $socket
			set keys $candidate_keys
		end
	end

	if begin; test -n "$agent_pid"; and test -n "$agent_sock"; end
		set -gx SSH_AUTH_SOCK $agent_sock
		set -gx SSH_AGENT_PID $agent_pid
		return 0
	else
		return 1
	end
end

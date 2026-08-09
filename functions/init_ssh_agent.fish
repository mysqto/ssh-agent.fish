function init_ssh_agent -d "Start a ssh-agent session for ssh-key management"

    # ssh agent sockets can be attached to a ssh daemon process or an ssh-agent
    # process.
	set -l agent_started 0

    # Attempt to find and use the ssh-agent in the current environment
    __test_ssh_socket

    if test 0 -eq $status
		set agent_started 1

    # If there is no agent in the environment, search running processs for
	# possible agent to reuse before starting a fresh ssh-agent process.
    else
		find_ssh_sock

		if test 0 -eq $status
			set agent_started 1
		end
	end


	if test 0 -eq $agent_started
		# Parse ssh-agent's csh-format output directly rather than writing it
		# to a predictable path in /tmp and sourcing that back. Sourcing also
		# needed a `setenv` helper that plain fish does not provide.
		for line in (ssh-agent -c)
			set -l assignment (string match -r '^setenv\s+(\S+)\s+([^;]+);' -- $line)

			if test 3 -eq (count $assignment)
				set -gx $assignment[2] $assignment[3]
			end
		end
	end

    # Try to test whether the agent is successfully started
    __test_ssh_socket

	if test ! 0 -eq $status
		echo "start ssh-agent failed, give up."
        set -e -g SSH_AGENT_PID
        set -e -g SSH_AUTH_SOCK
    else
		__set_ssh_agent_pid
		echo "SSH_AGENT_PID = $SSH_AGENT_PID"
		echo "SSH_AUTH_SOCK = $SSH_AUTH_SOCK"
		# singleton_ssh_agent
	end
end

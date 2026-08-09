function init_ssh_agent -d "Start a ssh-agent session for ssh-key management"

    # ssh agent sockets can be attached to a ssh daemon process or an ssh-agent
    # process.
	set agent_started 0

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
        set ssh_env /tmp/ssh_env
        ssh-agent -c | sed 's/^echo/#echo/' > $ssh_env
        source $ssh_env
        rm -rf $ssh_env
	end

    # Try to test whether the agent is successfully started
    __test_ssh_socket

	if test ! 0 -eq $status
		echo "start ssh-agent failed, give up."
        set -e SSH_AGENT_PID
        set -e SSH_AUTH_SOCK
    else
		__set_ssh_agent_pid
		echo "SSH_AGENT_PID = $SSH_AGENT_PID"
		echo "SSH_AUTH_SOCK = $SSH_AUTH_SOCK"
		# singleton_ssh_agent
	end
end

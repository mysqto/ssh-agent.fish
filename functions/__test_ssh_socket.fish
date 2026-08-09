function __test_ssh_socket -d "check if ssh socket valid"

    if test -z (which ssh-add)
        echo "ssh-add is not available, agent test aborted"
        return 1
    end

    set ssh_auth_sock $SSH_AUTH_SOCK

    if test -n "$argv[1]"
        set ssh_auth_sock $argv[1]
    end

    if test -z "$ssh_auth_sock"
        return 2
    end

    if test -S $ssh_auth_sock

        env SSH_AUTH_SOCK=$ssh_auth_sock ssh-add -l >/dev/null 2>&1

		if test 2 -ne $status
			return 0
		else
			return $status
		end
    else
		return 3
    end
end

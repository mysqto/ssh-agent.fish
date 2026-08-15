function __test_ssh_socket -d "check if ssh socket valid"

    # `command -q` is a builtin, so it needs no `which` on the system. The old
    # `test -z (which ssh-add)` degenerated to a bare `test -z` whenever
    # ssh-add was missing, which returns true only by accident.
    if not command -q ssh-add
        echo "ssh-add is not available, agent test aborted"
        return 1
    end

    set -l ssh_auth_sock $SSH_AUTH_SOCK

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

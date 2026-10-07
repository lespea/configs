function vlog
    set -l vuser (string lower (whoami))
    set -l token (vault login -token-only -method=ldap username=$vuser)
    or return

    set -gx VAULT_TOKEN $token
end

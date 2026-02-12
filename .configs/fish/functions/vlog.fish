function vlog
    set -l vuser (whoami | tr '[:upper:]' '[:lower:]')
    set -gx VAULT_TOKEN (vault login -token-only -method=ldap username=$vuser)
end

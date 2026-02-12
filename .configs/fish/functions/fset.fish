function fset
    argparse --min-args=1 'o/org=' -- $argv
    or return 1

    if not set -q _flag_org
        echo "Error: -o/--org is required" >&2
        return 1
    end

    set -l org $_flag_org

    for item in $argv
        # Split the comma-delimited string
        set -l parts (string split ',' $item)

        if test (count $parts) -ne 3
            echo "Error: Invalid format '$item'. Expected: value_name,attribute,env_var" >&2
            return 1
        end

        set -l value_name $parts[1]
        set -l attribute $parts[2]
        set -l env_var $parts[3]

        # Get the value from fnox and check it's non-empty
        set -l secret_value (fnox get $env_var)

        if test -z "$secret_value"
            echo "Error: fnox get $env_var returned empty string" >&2
            return 1
        end

        # Execute vault kv put
        vault kv put secret/$org/$value_name $attribute=$secret_value
        or return 1

        # Execute fnox set
        set -l description "$value_name $attribute"
        fnox set -P vault -p vault -d $description -k $value_name/$attribute $env_var
        or return 1
    end
end

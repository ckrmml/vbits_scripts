#!/usr/bin/env bash

iptables_delete () 
{ 

    if [[ $3 == "" ]] ; then
        echo "Usage: iptables_delete {CHAIN} {starting rule number} {ending rule number}";
        return; # don't use exit here - it will exit the controlling shell
    fi;

    CHAIN=$1
    RULES=("${@:2}")
    
    echo "Got chain $CHAIN"
    echo "  rules to delete: " "${RULES[@]}"

    DELIMITER="-"
    RULES_ARRAY=()
    for rule in "${RULES[@]}" ; do 
        if [[ "$rule" == *"$DELIMITER"* ]] ; then 
            IFS="$DELIMITER" read -ra "RULE_NUMS" <<< "$rule" 
            for (( r="${RULE_NUMS[1]}"; r>="${RULE_NUMS[0]}"; r-- )); do 
                RULES_ARRAY+=("$r")
            done
        else 
            RULES_ARRAY+=("$rule")
        fi
    done

    readarray -t REV_SORTED_RULES < <(for a in "${RULES_ARRAY[@]}"; do echo "$a"; done | sort -nr)
    for rule in "${REV_SORTED_RULES[@]}" ; do 
        iptables_delete_for_real_now "$CHAIN" "$rule"; 
    done
}


iptables_delete_for_real_now ()
{
    # /sbin/iptables -D $1 $2;
    echo "/sbin/iptables -D $1 $2;"

}

iptables_delete ccc 2-5 7 17-23 8 12 100-120 13

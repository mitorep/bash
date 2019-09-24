#usr/bin/sh
datediff()
{
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    days=$(( (d1 - d2) / 86400 ))
}
offset=10 #days
hosts=("192.168.56.12" "192.168.56.12")
users=("python2" "python2" "python2")
for host in ${hosts[@]}
do 
    for user in ${users[@]}
    do 
        command=$(ssh "$host" 'sudo chage -l '"$user" | grep "Password expires" | cut -d ":" -f 2)
        if  expr length "$command" > 0 && date -d "$command" &> /dev/null
        then 
            expires=$(date -d "$command")
            now=$(date)
            datediff "$expires" "$now"
            if [ $days -lt $offset ];
                then 
                    echo "Password for "$user" on "$host" will expire in " $days " days. It's not ok."
                else
                    echo "Password for "$user" on "$host" will expire in " $days " days. It's ok."
            fi  
        fi
    done
done



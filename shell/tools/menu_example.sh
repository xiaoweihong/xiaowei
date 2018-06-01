#!/bin/bash

shell_usage(){
    echo "Usage: ./$0 delete db"
    echo "Usage: ./$0 sql db1 db2"
    echo "Usage: ./$0 seq db1 db2"
    echo "Usage: ./$0 export db"
    exit 1
}

[ $# -ne 2 ] && shell_usage && exit 1

case "$1" in
sql)
    sql
        ;;
seq)
    seq
        ;;
export)
    export
        ;;
delete)
    delete
        ;;
*)             
    shell_usage
        exit 1
        ;;
esac
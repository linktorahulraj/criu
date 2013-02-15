#!/bin/sh

set -e
set -u

FILE=$1
NAME=$2
INC_GUARD=__${NAME}_h__
PREFIX=${NAME}_blob_offset__
BLOB=${NAME}_blob
OBJNAME=${FILE}.built-in.bin.o
BINARY=${FILE}.built-in.bin

AWK_CMD='$2 ~ /^[tT]$/ { print "#define '$PREFIX'" $3 " 0x" $1; }'

cat << EOF
/* Autogenerated by $0, do not edit */
#ifndef $INC_GUARD
#define $INC_GUARD

EOF

nm $OBJNAME | grep "__export_" | tr . _ | awk "$AWK_CMD"

cat << EOF

static char $BLOB[] = {
EOF

hexdump -v -e '"\t" 8/1 "0x%02x, " "\n"' $BINARY

cat << EOF
};

#endif /* $INC_GUARD */
EOF

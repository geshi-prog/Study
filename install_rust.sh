#!/bin/sh

INPUTWORD="yes"

expect -c "
set timeout 5
spawn bash -c \"curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh\"
expect \"3) Cancel installation\"
send \"\n${INPUTWORD}\n\"
expect \"$\"
exit 0
"

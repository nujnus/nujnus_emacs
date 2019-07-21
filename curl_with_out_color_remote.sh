curl -s -d "code=$1" http://192.168.3.57:8111/interpret|gsed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"

curl -s -d "code=$1" http://127.0.0.1:8000/interpret|gsed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"

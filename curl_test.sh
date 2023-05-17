#! /bin/bash

# --------------------------------------
# Setup
# --------------------------------------

# Read each line of the file into an array
mapfile -t lines <./sites

# find length of the array
len="${#lines[@]}"

# find the baseurl key:val pair
firstpair="${lines[0]}"

# define a separator string
sep=": "

# pull the val from the baseurl key:val pair
baseurl="${firstpair#*"${sep}"}"

echo "Live Site"
echo "$baseurl"
echo "---- ---- ----"

# set scoring values
total=$((len - 1))
score=0

# --------------------------------------
# Test
# --------------------------------------

for ((i = 1; i < len; i++)); do
	line="${lines[$i]}"
	space=" "

	# remove the substring from sep to the end ->
	key="${line%"${sep}"*}"
	# remove the substring from sep to the beginning <-
	val="${line#*"${sep}"}"
	# remove the substring from space to the end ->
	method="${val%"${space}"*}"
	# remove the substring from space to the beginning <-
	route="${val#*"${space}"}"

	echo "$key ($method -> $route)"

	# extract HTTP status code -- will need to change this section drastically
	# Probably compare curl json output with expected output + expected status code
	# Probably cross reference $key against another file that contains required output via grep/awk
	# Or a folder of individual files that have the key as a fileName and the output as content
	statuscode=$(curl --silent --head "$baseurl$route" | awk '/^HTTP/{print $2}')
	if [[ $statuscode -eq 200 ]]; then
		echo "pass"
		((++score))
	else
		echo "fail"
	fi
	echo "---- ---- ----"
done

echo "Score: $score/$total"

#! /bin/bash

# --------------------------------------
# Setup
# --------------------------------------

# Read each line of the file into an array
# mapfile -t lines <./sites
mapfile -t lines <./json-routes.txt

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

	# -o- send output to stdout
	# -s  hide progress
	# $'\1' first argument (response) plus marker to use to seperate
	# %{response_code} curl variable to extract http status code
	res=$(curl -o- -s "$baseurl$route" -w $'\1'"%{response_code}")
	body="${res%$'\1'*}"
	statuscode="${res#*$'\1'}"

	echo "status: $statuscode"
	echo ""
	echo "$body"

	echo "---- ---- ----"
done

echo "Score: $score/$total"

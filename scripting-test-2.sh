#! /bin/bash

myvar="foo/bar/baz"
pattern_var="pattern"
pattern="s/bar/123/"

result=$(echo "$myvar" | sed "${!pattern_var}")
echo "$result"

#!/bin/sh

if git ls-files >& /dev/null; then
	git symbolic-ref --short HEAD
fi

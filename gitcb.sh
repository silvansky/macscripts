#!/bin/sh

git symbolic-ref -q HEAD | sed s:refs/heads/::

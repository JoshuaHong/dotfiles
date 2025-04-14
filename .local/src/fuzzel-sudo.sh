#!/bin/bash
#
# Use Fuzzel to enter sudo passwords using `sudo --askpass`.

fuzzel --dmenu --password --prompt="Password: "

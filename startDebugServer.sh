#!/usr/bin/env bash
echo "Starting a tiny webserver for testing."
echo "To test the webapp you'll need a real server with HTTPS, though."
python3 -m http.server 3333

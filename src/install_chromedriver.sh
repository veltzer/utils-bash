#!/bin/bash -eu

rm -rf /tmp/chromedriver-linux64 || true
rm -f /tmp/chromedriver_linux64.zip || true

# Fetch the JSON data
# json_data=$(curl -s https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json)
# echo "${json_data}"

# Extract the corresponding ChromeDriver version
# chromedriver_version=$(echo "${json_data}" | jq -r '.versions[-1]["version"]')
chromedriver_version=$(google-chrome --version | grep -o '[0-9.]\+')
# echo "version is [${chromedriver_version}]"

# Construct the download URL
download_url="https://storage.googleapis.com/chrome-for-testing-public/${chromedriver_version}/linux64/chromedriver-linux64.zip"

# Download the ChromeDriver
wget -O /tmp/chromedriver_linux64.zip "${download_url}"

# Unzip the file
unzip /tmp/chromedriver_linux64.zip -d /tmp

# Make it executable
chmod +x /tmp/chromedriver-linux64/chromedriver
mv /tmp/chromedriver-linux64/chromedriver ~/install/binaries

# Optionally, move it to a directory in your PATH (e.g., /usr/local/bin)

echo "Latest ChromeDriver for Linux downloaded and installed!"

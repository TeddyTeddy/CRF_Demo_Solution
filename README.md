# 1. INSTALLATION INSTRUCTIONS FOR UBUNTU 18.04 LTS

### 1.1 Installing SQLite on Ubuntu [1]
1. sudo apt-get update
2. sudo apt-get install sqlite3
3. sqlite3 --version

### 1.2 Installing Python 3.7.4 or Higher
Follow the instructions in [2]. Verify that you have python 3.7.4 or higher:
1. python --version

### 1.3 Installing Node.js v16.4.1
According to the instructions in [3]:
1. curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
2. sudo apt-get install -y nodejs
3. node --version

### 1.4 Installing The Testing Project
On bash terminal, in the given order:
1. git clone https://github.com/TeddyTeddy/CRF_Demo_Solution.git
2. cd CRF_Demo_Solution/
3. git clone https://github.com/Interview-demoapp/Flasky.git

Continuing on the same bash terminal in CRF_Demo_Solution/ folder:
4. Install a virtual environment:       python -m venv .venv/
5. Activate the virtual environment:    source .venv/bin/activate
6. python -m pip install -r requirements.txt
7. rfbrowser init

# 2. Running The UI Test Cases
1. cd CRF_Demo_Solution/WebUiTests/
2. ./run


# REFERENCES

[1] https://linuxhint.com/install_sqlite_browser_ubuntu_1804/
[2] https://phoenixnap.com/kb/how-to-install-python-3-ubuntu
[3] https://github.com/nodesource/distributions/blob/master/README.md  > Node.js v16.x

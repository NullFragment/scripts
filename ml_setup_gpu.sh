#! /bin/bash
echo "Please allow sudo to do the work for you..."
sudo echo "Setting Temp Downloads directory"
install -d ~/Downloads/temp
cd ~/Downloads/temp

bash_pkgs=(
	'zsh'
	'xterm'
	'tmux'
	'vim'
	'htop'
	'git'
	'python3'
	'python3-pip'
	'python3-tk'
	'python3-numpy'
	'openmpi-bin'
	)

py_pkgs=(
	'http://download.pytorch.org/whl/cu80/torch-0.1.12.post2-cp35-cp35m-linux_x86_64.whl'
	'https://cntk.ai/PythonWheel/GPU-1bit-SGD/cntk-2.0-cp35-cp35m-linux_x86_64.whl'
	'torchvision'
	'tensorflow-gpu'
	'keras'
	'matplotlib'
	)

echo "Updating package repositories"
sudo apt-get update 

echo "Upgrading installed packages"
sudo apt-get upgrade -y 

echo "Installing requested packages"
for i in "${bash_pkgs[@]}"
do
	sudo -H apt-get install -y $i 
done

echo "Ensuring pip is up-to-date"
sudo -H pip3 install --upgrade pip 

echo "Installing python ML packages"
for i in "${py_pkgs[@]}"
do
	sudo -H pip3 install $i 
done

echo "Cleaning up unnecessary packages..."
sudo apt-get update 
sudo apt autoremove -y 
echo "Finished"

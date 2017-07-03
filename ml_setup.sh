#! /bin/bash
echo -e "\e[1;31mWhich Machine Learning Packages would you like to install?\e[0m"
select cg in "CPU" "GPU"; do
	case $cg in
		CPU ) x=1; break;;
		GPU ) x=2; break;;
	esac
done
echo $x

echo -e "\e[1;31mIf you do not want to overwrite your default terminal profile, add a new profile for the solarized settings\e[0m"
read -p "Press enter to continue when ready"
echo -e "\e[1;31mPlease allow sudo to do the work for you...\e[0m"
sudo echo -e "\e[1;31mSetting Temp Downloads directory\e[0m"
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
	'torchvision'
	'keras'
	'matplotlib'
	)

cpu_ml_pkgs=(
	'http://download.pytorch.org/whl/cu75/torch-0.1.12.post2-cp35-cp35m-linux_x86_64.whl'
	'https://cntk.ai/PythonWheel/CPU-Only/cntk-2.0-cp35-cp35m-linux_x86_64.whl'
	'tensorflow'
	)


gpu_ml_pkgs=(
	'http://download.pytorch.org/whl/cu80/torch-0.1.12.post2-cp35-cp35m-linux_x86_64.whl'
	'https://cntk.ai/PythonWheel/GPU/cntk-2.0-cp35-cp35m-linux_x86_64.whl'
	'tensorflow-gpu'
	)

echo -e "\e[1;31mUpdating package repositories\e[0m"
sudo apt-get update 

echo -e "\e[1;31mUpgrading installed packages\e[0m"
sudo apt-get upgrade -y 

echo -e "\e[1;31mInstalling requested packages\e[0m"
for i in "${bash_pkgs[@]}"
do
	sudo -H apt-get install -y $i 
done

echo -e "\e[1;31mEnsuring pip is up-to-date\e[0m"
sudo -H pip3 install --upgrade pip 


if x=1; then
	echo -e "\e[1;31mInstalling python CPU ML packages\e[0m"
	for i in "${cpu_ml_pkgs[@]}"
	do
		sudo -H pip3 install $i 
	done
elif x=2; then
	echo -e "\e[1;31mInstalling python GPU ML packages\e[0m"
	for i in "${gpu_ml_pkgs[@]}"
	do
		sudo -H pip3 install $i 
	done
fi


echo -e "\e[1;31mInstalling universal python packages\e[0m"
for i in "${py_pkgs[@]}"
do
	sudo -H pip3 install $i 
done

echo -e "\e[1;31mCleaning up unnecessary packages...\e[0m"
sudo apt-get update 
sudo apt autoremove -y 

echo -e "\e[1;31mExtracting dotfiles...\e[0m"
cp ./dotfiles/* ~/

echo -e "\e[1;31mDownloading vundle, Powerline fonts and Solarized terminal fix...\e[0m"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git ~/Downloads/temp/solarized
git clone https://github.com/powerline/fonts.git ~/Downloads/temp/fonts

~/Downloads/temp/fonts/install.sh
~/Downloads/temp/solarized/install.sh

echo -e "\e[1;31mFinished installing."
echo -e "You must run ':PluginInstall' in VIM to complete VIM setup."
echo -e "For Airline to display properly, change your terminal font to 'Ubuntu Mono derivative Powerline Regular' in your profile settings.\e[0m"

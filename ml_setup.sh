#! /bin/bash
echo -e "\e[1;35m****************************************************************************\e[0m"
echo -e "\e[1;31mWhich Machine Learning Packages would you like to install?\e[0m"
select cg in "CPU" "GPU"; do
	case $cg in
		CPU ) x=1; break;;
		GPU ) x=2; break;;
	esac
done
echo $x

echo -e "\e[1;35m****************************************************************************\e[0m"
echo -e "\e[1;31mIf you do not want to overwrite your default terminal profile, add a new profile for the solarized settings\e[0m"
read -p "Press enter to continue when ready"
echo -e "\e[1;35m****************************************************************************\e[0m"
echo -e "\e[1;31mPlease allow sudo to do the work for you...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
sudo echo -e "\e[1;31mSetting Temp Downloads directory\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
install -d ~/Downloads/temp
cd ~/Downloads/temp
touch install.log

bash_pkgs=(
	'zsh'
	'xterm'
	'tmux'
	'vim'
	'htop'
	'git'
	'python'
	'python-dev'
	'python-pip'
	'python-tk'
	'python3'
	'python3-dev'
	'python3-pip'
	'python3-tk'
	'python3-numpy'
	'ipython3'
	'openmpi-bin'
	'neovim'
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
echo -e "\e[1;35m****************************************************************************\e[0m"
> /dev/null 2>&1
sudo apt-get install -y software-properties-common >> ~/Downloads/temp/install.log
sudo add-apt-repository -y ppa:neovim-ppa/stable >> ~/Downloads/temp/install.log
sudo apt-get update >> ~/Downloads/temp/install.log

echo -e "\e[1;31mUpgrading installed packages\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
sudo apt-get upgrade -y >> ~/Downloads/temp/install.log

echo -e "\e[1;31mInstalling requested packages\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
for i in "${bash_pkgs[@]}"
do
	sudo -H apt-get install -y $i >> ~/Downloads/temp/install.log
done

echo -e "\e[1;31mEnsuring pip is up-to-date\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
sudo -H pip3 install --upgrade pip 


if x=1; then
	echo -e "\e[1;31mInstalling python CPU ML packages\e[0m"
	for i in "${cpu_ml_pkgs[@]}"
	do
		sudo -H pip3 install $i >> ~/Downloads/temp/install.log
	done
elif x=2; then
	echo -e "\e[1;31mInstalling python GPU ML packages\e[0m"
	for i in "${gpu_ml_pkgs[@]}"
	do
		sudo -H pip3 install $i >> ~/Downloads/temp/install.log
	done
fi


echo -e "\e[1;31mInstalling universal python packages\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
for i in "${py_pkgs[@]}"
do
	sudo -H pip3 install $i >> ~/Downloads/temp/install.log
done

echo -e "\e[1;31mCleaning up unnecessary packages...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
sudo apt-get update >> ~/Downloads/temp/install.log
sudo apt autoremove -y >> ~/Downloads/temp/install.log

echo -e "\e[1;31mDownloading github repos...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git ~/Downloads/temp/solarized >> ~/Downloads/temp/install.log
git clone https://github.com/powerline/fonts.git ~/Downloads/temp/fonts >> ~/Downloads/temp/install.log
git clone https://github.com/NullFragment/scripts.git ~/Downloads/temp/scripts >> ~/Downloads/temp/install.log

echo -e "\e[1;31mInstalling Vundle...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo -e "\e[1;31mInstalling VIM Plugins...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
echo | echo | vim +PluginInstall +qall &>/dev/null

echo -e "\e[1;31mExtracting dotfiles...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
cd ~/Downloads/temp/scripts/dotfiles/
for file in ./*;
do
	cp $file ~/
done

echo -e "\e[1;31mInstalling Powerline Fonts and Solarized terminal fix...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
~/Downloads/temp/fonts/install.sh
~/Downloads/temp/solarized/install.sh

echo -e "\e[1;35m****************************************************************************\e[0m"
echo -e "\e[1;31mFinished installing."
echo -e "****************************************************************************"
echo -e "NOTE1: Check the log file at ~/Downloads/temp/ if you'd like."
echo -e "       Make sure to delete the directory to clean up unnecessary files."
echo -e "****************************************************************************"
echo -e "NOTE2: For Airline to display properly, change your terminal font to" 
echo -e "       'Ubuntu Mono derivative Powerline Regular' in your profile settings."
echo -e "****************************************************************************"
echo -e "NOTE3: If you are using a GPU setup, you must still install the latest"
echo -e "       nVidia CUDA drivers manually."
echo -e "****************************************************************************\e[0m"

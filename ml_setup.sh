#! /bin/bash

####################################
### PACKAGES TO INSTALL          ###
####################################

bash_pkgs=(
    'build-essential'
    'curl'
    'cmake'
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
    'rubygems'
    'r-base-core'
    'r-base-dev'
    'r-base'
    'r-cran-ggplot2'
    'r-cran-reshape2'
    'r-cran-car'
    'r-cran-gridextra'
    )
sh_len=${#bash_pkgs[@]}

py_pkgs=(
    'torchvision'
    'keras'
    'matplotlib'
    )
py_len=${#py_pkgs[@]}

cpu_ml_pkgs=(
    'http://download.pytorch.org/whl/cu75/torch-0.2.0.post3-cp35-cp35m-manylinux1_x86_64.whl'
    'https://cntk.ai/PythonWheel/CPU-Only/cntk-2.2-cp35-cp35m-linux_x86_64.whl'
    'tensorflow-gpu'
    )
cpu_len=${#cpu_ml_pkgs[@]}

gpu_ml_pkgs=(
    'http://download.pytorch.org/whl/cu80/torch-0.2.0.post3-cp35-cp35m-manylinux1_x86_64.whl'
    'https://cntk.ai/PythonWheel/GPU/cntk-2.2-cp35-cp35m-linux_x86_64.whl'
    'tensorflow-gpu'
    )
gpu_len=${#gpu_ml_pkgs[@]}

####################################
### SELECT CPU/GPU               ###
####################################

echo -e "\e[1;35m****************************************************************************\e[0m"
echo -e "\e[1;31mWhich Machine Learning Packages would you like to install?\e[0m"

select cg in "CPU" "GPU"; do
    case $cg in
        CPU ) x=1; break;;
        GPU ) x=2; break;;
    esac
done

if [ $x -eq "1" ] ; then
    echo "You have selected CPU."
elif [ $x -eq "2" ]; then
    echo "You have selected GPU."
fi

####################################
### WARNINGS / PERMISSIONS       ###
####################################

echo -e "\e[1;35m****************************************************************************\e[0m"
echo -e "\e[1;31mIf you do not want to overwrite your default terminal profile, add a new profile for the solarized settings\e[0m"
read -p "Press enter to continue when ready"
echo -e "\e[1;35m****************************************************************************\e[0m"
echo -e "\e[1;31mPlease allow sudo to do the work for you...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
sudo echo > /dev/null

####################################
### CREATE DIRECTORIES           ###
####################################

echo -e "\e[1;31mSetting Temp Downloads directory\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
install -d ~/Downloads/temp
cd ~/Downloads/temp
touch install.log
mkdir ~/.zsh/
mkdir ~/.tmuxinator/

####################################
### ADD/UPDATE APT REPOS         ###
####################################

echo -e "\e[1;31mUpdating package repositories\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

sudo apt-get install -y software-properties-common >> ~/Downloads/temp/install.log
sudo add-apt-repository -y ppa:neovim-ppa/stable >> ~/Downloads/temp/install.log
sudo apt-get update >> ~/Downloads/temp/install.log


####################################
### UPGRADE / INSTALL            ###
####################################

echo -e "\e[1;31mUpgrading installed packages\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

sudo apt-get upgrade -y >> ~/Downloads/temp/install.log

echo -e "\e[1;31mInstalling requested packages\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

for i in "${!bash_pkgs[@]}"
do 
    sh_pkg=${bash_pkgs[$i]}
    printf "%02d/%s Installing: %s\n" "$((i+1))" "$sh_len" "$sh_pkg"
    sudo -H apt-get install -y $sh_pkg >> ~/Downloads/temp/install.log
done

echo -e "\e[1;31mEnsuring pip is up-to-date\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"


if [ $x -eq "2" ]; then
    echo -e "\e[1;31mInstalling CUDA\e[0m"
    echo -e "\e[1;35m****************************************************************************\e[0m"
	wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
	sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
	sudo apt-get update
	sudo apt-get install cuda
fi

sudo -H pip3 install --upgrade pip 


if [ $x -eq "1" ]; then
    echo -e "\e[1;31mInstalling python CPU ML packages\e[0m"
    echo -e "\e[1;35m****************************************************************************\e[0m"

    for i in "${!cpu_ml_pkgs[@]}"
    do 
        cpu_pkg=${cpu_ml_pkgs[$i]}
        printf "%02d/%s Installing: %s\n" "$((i+1))" "$cpu_len" "$cpu_pkg"
        sudo -H pip3 install $cpu_pkg >> ~/Downloads/temp/install.log
    done

if [ $x -eq "2" ]; then
    echo -e "\e[1;31mInstalling python GPU ML packages\e[0m"
    echo -e "\e[1;35m****************************************************************************\e[0m"

    for i in "${!gpu_ml_pkgs[@]}"
    do 
        gpu_pkg=${gpu_ml_pkgs[$i]}
        printf "%02d/%s Installing: %s\n" "$((i+1))" "$gpu_len" "$gpu_pkg"
        sudo -H pip3 install $gpu_pkg >> ~/Downloads/temp/install.log
    done
fi

echo -e "\e[1;31mInstalling universal python packages\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

for i in "${!py_pkgs[@]}"
do 
    py_pkg=${py_pkgs[$i]}
    printf "%02d/%s Installing: %s\n" "$((i+1))" "$py_len" "$py_pkg"
    sudo -H pip3 install $py_pkg >> ~/Downloads/temp/install.log
done

####################################
### REMOVE UNNECESSARY PACKAGES  ###
####################################

echo -e "\e[1;31mCleaning up unnecessary packages...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

sudo apt-get update >> ~/Downloads/temp/install.log
sudo apt autoremove -y >> ~/Downloads/temp/install.log

####################################
### GITHUB REPOS                 ###
####################################

echo -e "\e[1;31mDownloading github repos...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git ~/Downloads/temp/solarized 
git clone https://github.com/powerline/fonts.git ~/Downloads/temp/fonts
git clone https://github.com/NullFragment/scripts.git ~/Downloads/temp/scripts

####################################
### DOTFILES                     ###
####################################

echo -e "\e[1;31mExtracting dotfiles...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

cd ~/Downloads/temp/scripts/dotfiles/
shopt -s dotglob
for file in *;
do
    cp $file ~/
done
shopt -u dotglob

mv ~/ml_sys.yml ~/.tmuxinator/ml_sys.yml

####################################
### RUBY GEMS                    ###
####################################

yes | sudo gem install tmuxinator >> ~/Downloads/temp/install.log

####################################
### VIM PLUGINS                  ###
####################################

echo -e "\e[1;31mInstalling Vundle...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo -e "\e[1;31mInstalling VIM Plugins...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

echo | echo | vim +PluginInstall +qall &>/dev/null
~/.vim/bundle/youcompleteme/install.py --clang-completer >> ~/Downloads/temp/install.log

####################################
### ZSH PLUGINS                  ###
####################################

echo -e "\e[1;31mInstalling zsh Plugins...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

curl -L git.io/antigen > ~/.zsh/antigen.zsh

echo -e "\e[1;31mSetting zsh as default shell...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

sudo chsh $USER -s $(which zsh)

####################################
### TERMINAL FIXES               ###
####################################

echo -e "\e[1;31mInstalling Powerline Fonts and Solarized terminal fix...\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

~/Downloads/temp/fonts/install.sh
~/Downloads/temp/solarized/install.sh

####################################
### ENDING MATERIAL              ###
####################################

echo -e "\e[1;35m****************************************************************************\e[0m"
echo -e "\e[1;31mFinished installing. Log out and back in for changes to take effect."
echo -e "****************************************************************************"
echo -e "NOTE1: Check the log file at ~/Downloads/temp/ if you'd like."
echo -e "       Make sure to delete the directory to clean up unnecessary files."
echo -e "****************************************************************************"
echo -e "NOTE2: For Airline to display properly, change your terminal font to" 
echo -e "       'Ubuntu Mono derivative Powerline Regular' in your profile settings."
echo -e "****************************************************************************"



#! /bin/bash

####################################
### PACKAGES TO INSTALL          ###
####################################

bash_pkgs=(
    'autoconf'
    'automake'
    'bison'
    'build-essential'
    'cmake'
    'curl'
    'default-jdk-headless'
    'default-jdk'
    'epstool'
    'flex'
    'fontconfig'
    'g++'
    'gcc'
    'gfortran'
    'git'
    'gnuplot-x11'
    'gnuplot'
    'gperf'
    'gzip'
    'hdf5-helpers'
    'htop'
    'icoutils'
    'ipython3'
    'javahelper'
    'kcachegrind'
    'libaec-dev'
    'libarpack2-dev'
    'libblas-dev'
    'libbtf1.2.1'
    'libcsparse3.1.4'
    'libcurl4-gnutls-dev'
    'libexif-dev'
    'libfftw3-dev'
    'libflac-dev'
    'libfltk-cairo1.3'
    'libfltk-forms1.3'
    'libfltk-images1.3'
    'libfltk1.3-dev'
    'libfontconfig1-dev'
    'libfreetype6-dev'
    'libftgl-dev'
    'libftgl2'
    'libgl1-mesa-dev'
    'libgl2ps-dev'
    'libglpk-dev'
    'libgraphicsmagick++1-dev'
    'libgraphicsmagick1-dev'
    'libhdf5-cpp-11'
    'libhdf5-dev'
    'libhdf5-serial-dev'
    'libjack-dev'
    'libjasper-dev'
    'libklu1.3.3'
    'liblapack-dev'
    'libldl2.2.1'
    'libogg-dev'
    'libosmesa6-dev'
    'libpcre3-dev'
    'libportaudiocpp0'
    'libqhull-dev'
    'libqrupdate-dev'
    'libqscintilla2-dev'
    'libqt4-designer'
    'libqt4-dev-bin'
    'libqt4-dev'
    'libqt4-help'
    'libqt4-network'
    'libqt4-opengl-dev'
    'libqt4-qt3support'
    'libqt4-scripttools'
    'libqt4-svg'
    'libqt4-test'
    'libqtcore4'
    'libqtgui4'
    'libqtwebkit4'
    'libreadline-dev'
    'librsvg2-bin'
    'librsvg2-dev'
    'libsndfile1-dev'
    'libspqr2.0.2'
    'libsuitesparse-dev'
    'libtool'
    'libvorbis-dev'
    'libwmf-dev'
    'libxft-dev'
    'llvm-3.5-dev'
    'llvm-dev'
    'lpr'
    'make'
    'openjdk-8-jdk-headless'
    'openjdk-8-jdk'
    'perl'
    'portaudio19-dev'
    'pstoedit'
    'python-dev'
    'python-pip'
    'python-tk'
    'python'
    'python3-dev'
    'python3-pip'
    'python3-tk'
    'python3'
    'qt4-linguist-tools'
    'qt4-qmake'
    'r-base-core'
    'r-base-dev'
    'r-base'
    'r-cran-car'
    'r-cran-ggplot2'
    'r-cran-gridextra'
    'r-cran-reshape2'
    'rsync'
    'rubygems'
    'tar'
    'texinfo'
    'tmux'
    'transfig'
    'uuid-dev'
    'valgrind'
    'zlib1g-dev'
    'zsh'
    )
sh_len=${#bash_pkgs[@]}

extra_pkgs=(
    'insync'
    'texlive-full'
    'texmaker'
    )
extra_len=${#extra_pkgs[@]}

snap_pkgs=(
    'atom --classic'
    'discord'
    )
snap_len=${#snap_pkgs[@]}


py_pkgs=(
    'jupyter'
    'keras'
    'librosa'
    'matplotlib'
    'mutagen'
    'numpy'
    'pandas'
    'pydot'
    'python-dotenv'
    'requests'
    'seaborn'
    'scikit-learn'
    'torchvision'
    'tqdm'
    )
py_len=${#py_pkgs[@]}

cpu_ml_pkgs=(
    'http://download.pytorch.org/whl/cpu/torch-0.3.0.post4-cp35-cp35m-linux_x86_64.whl'
    'https://cntk.ai/PythonWheel/CPU-Only/cntk-2.3-Pre-cp35-cp35m-linux_x86_64.whl'
    'tensorflow'
    )
cpu_len=${#cpu_ml_pkgs[@]}

gpu_ml_pkgs=(
    'http://download.pytorch.org/whl/cu90/torch-0.3.0.post4-cp35-cp35m-linux_x86_64.whl'
    'https://cntk.ai/PythonWheel/GPU/cntk-2.3-Pre-cp35-cp35m-linux_x86_64.whl'
    'tensorflow-gpu'
    )
gpu_len=${#gpu_ml_pkgs[@]}

####################################
### SELECT PACKAGES TO INSTALL   ###
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

echo -e "\e[1;35m****************************************************************************\e[0m"
echo -e "\e[1;31mDo you want to install the extra packages?\e[0m"

select cg in "Yes" "No"; do
    case $cg in
        Yes ) y=1; break;;
        No  ) y=2; break;;
    esac
done

if [ $y -eq "1" ] ; then
    echo "You have selected to install the extra packages."
elif [ $y -eq "2" ]; then
    echo "You have selected to NOT install the extra packages."
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
sudo add-apt-repository -y ppa:marutter/rrutter >> ~/Downloads/temp/install.log
sudo add-apt-repository -y ppa:libreoffice/libreoffice-5-4 >> ~/Downloads/temp/install.log
sudo apt-get update >> ~/Downloads/temp/install.log

####################################
### UPGRADE / INSTALL            ###
####################################

echo -e "\e[1;31mUpgrading installed packages\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

sudo apt-get full-upgrade -y >> ~/Downloads/temp/install.log

echo -e "\e[1;31mInstalling requested packages\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"

for i in "${!bash_pkgs[@]}"
do
    sh_pkg=${bash_pkgs[$i]}
    printf "%02d/%s Installing: %s\n" "$((i+1))" "$sh_len" "$sh_pkg"
    sudo -H apt-get install -y $sh_pkg >> ~/Downloads/temp/install.log
done

if [ $x -eq "2" ]; then
    echo -e "\e[1;31mInstalling CUDA\e[0m"
    echo -e "\e[1;35m****************************************************************************\e[0m"
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.1.85-1_amd64.deb >> ~/Downloads/temp/install.log
    sudo dpkg -i cuda-repo-ubuntu1604_9.1.85-1_amd64.deb >> ~/Downloads/temp/install.log
    sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub >> ~/Downloads/temp/install.log
    sudo apt-get update >> ~/Downloads/temp/install.log
    sudo apt-get install -y cuda >> ~/Downloads/temp/install.log
fi

echo -e "\e[1;31mEnsuring pip is up-to-date\e[0m"
echo -e "\e[1;35m****************************************************************************\e[0m"
sudo -H pip3 install --upgrade pip >> ~/Downloads/temp/install.log

if [ $x -eq "1" ]; then
    echo -e "\e[1;31mInstalling python CPU ML packages\e[0m"
    echo -e "\e[1;35m****************************************************************************\e[0m"

    for i in "${!cpu_ml_pkgs[@]}"
    do
        cpu_pkg=${cpu_ml_pkgs[$i]}
        printf "%02d/%s Installing: %s\n" "$((i+1))" "$cpu_len" "$cpu_pkg"
        sudo -H pip3 install $cpu_pkg >> ~/Downloads/temp/install.log
    done

elif [ $x -eq "2" ]; then
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
sudo apt-get autoremove -y >> ~/Downloads/temp/install.log

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
### EXTRA INSTALLS               ###
####################################
if [ $y -eq "1" ]; then
    echo -e "\e[1;31mInstalling Extra Apt Packages\e[0m"
    echo -e "\e[1;35m****************************************************************************\e[0m"
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C >> ~/Downloads/temp/install.log
    echo 'deb http://apt.insynchq.com/ubuntu xenial non-free contrib' | sudo tee /etc/apt/sources.list.d/insync.list >> ~/Downloads/temp/install.log
    sudo apt-get -y update >> ~/Downloads/temp/install.log
    for i in "${!extra_pkgs[@]}"
    do
        extra_pkg=${extra_pkgs[$i]}
        printf "%02d/%s Installing: %s\n" "$((i+1))" "$extra_len" "$extra_pkg"
        sudo -H apt-get install -y $extra_pkg >> ~/Downloads/temp/install.log
    done
    echo -e "\e[1;31mInstalling Extra Snap Packages\e[0m"
    echo -e "\e[1;35m****************************************************************************\e[0m"
    for i in "${!snap_pkgs[@]}"
    do
        snap_pkg=${snap_pkgs[$i]}
        printf "%02d/%s Installing: %s\n" "$((i+1))" "$snap_len" "$snap_pkg"
        sudo -H snap install $snap_pkg >> ~/Downloads/temp/install.log
    done
fi

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
echo -e "NOTE3: The following are commonly installed programs/packages:"
echo -e "       gitkraken, jetbrains toolbox, matlab, r-studio, nylas mail"
echo -e "****************************************************************************\e[0m"

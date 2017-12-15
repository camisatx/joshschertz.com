#!/bin/bash

# This is a script to install all requirements for mining cryptocoins on
#   an Ubuntu 16.04 machine with Nvidia GPUs.
# NOTE: Only run this script on machines that do not already have CUDA installed

# Update and upgrade the system (including security patches)
echo "Upgrading the system..."
sudo apt update
sudo apt upgrade -y

# Install wget if the system doesn't have it already
sudo apt install wget

###############################################################################
# Setup the CUDA 9 drivers
#   Guide: http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
echo ""
echo "Setting up the CUDA 9 drivers..."

# Make sure the system has the linux headers already installed
sudo apt install linux-headers-$(uname -r) -y

# Download the deb network drivers
# NOTE: If you are installing this on a non-Ubuntu 16.04 machine, used the
#   download navigator linked below, download the correct installer, and
#   replace the commands listed directly below with the commands listed for
#   your target platform:
#       https://developer.nvidia.com/cuda-downloads
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.1.85-1_amd64.deb
# Check installer integrity against the provided md5sum (assuming it's updated)
#wget https://developer.download.nvidia.com/compute/cuda/9.0/Prod/docs/sidebar/md5sum.txt

# Add the deb to the system packager
sudo dpkg -i cuda-repo-ubuntu1604_9.1.85-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub

# Install the CUDA drivers
sudo apt-get update
sudo apt-get install cuda -y

rm cuda-repo-ubuntu*.deb

echo ""
echo "Finished installing the CUDA 9 drivers"

###############################################################################
# Setup the mining software
echo ""
echo "For Ethereum miners, you can use either ethminer or Claymore's Dual miner. However, ethminer is the only Ethash option for v100 mining since Claymore's has a critical bug when using a v100."
echo ""
echo "Do you want ethminer installed?"
select ethminer_yn in "Yes" "No" 
do
    case $ethminer_yn in
        Yes )
            echo "Installing ethminer..."
            # https://github.com/ethereum-mining/ethminer
            
            # Download the Linux executable
            wget https://github.com/ethereum-mining/ethminer/releases/download/v0.12.0/ethminer-0.12.0-Linux.tar.gz
            # Extract the download
            tar -xvf ethminer-*.tar.gz
            # Delete the original download
            rm ethminer-*.tar.gz
            # Rename the extracted bin folder to ethminer
            mv bin ethminer
            
            # Create a script that will be used to start ethminer
            # NOTE: You need to enter your preferred mining pool and wallet information
            echo "./ethminer --farm-recheck 200 -G -F http://eth-us2.dwarfpool.com:80/0xCD61d787153Cba6b67795374a058Df84355B60f4/NvidiaMiner" >> ethminer/mine.sh
            chmod +x ethminer/mine.sh
            
            echo ""
            echo "Finished installing and setting up ethminer"
            echo ""
            echo "Navigate to the ethminer folder and open the mine.sh file:"
            echo "    nano mine.sh"
            echo "Once you are within this file, you can change the mining pool and wallet address."
            echo "You can also change 'NvidiaMiner' to a name you want to call this miner."
            break
            ;;
        No )
            break
            ;;
    esac
done

echo ""
echo "Do you want Claymore's Dual miner installed?"
select claymore_yn in "Yes" "No" 
do
    case $claymore_yn in
        Yes )
            echo "Installing Claymore's Dual Ethereum Miner"
            #https://github.com/nanopool/Claymore-Dual-Miner

            # Download the files
            wget https://github.com/nanopool/Claymore-Dual-Miner/releases/download/v10.0/Claymore.s.Dual.Ethereum.Decred_Siacoin_Lbry_Pascal.AMD.NVIDIA.GPU.Miner.v10.0.-.LINUX.tar.gz
            mkdir Claymore
            cd Claymore
            # Extract the download
            tar -xvf ../Claymore*.tar.gz
            rm ../Claymore*.tar.gz
            rm start.bash
            rm start_only_eth.bash
            echo "./ethdcrminer64 -epool eth-us.dwarfpool.com:8008 -ewal 0xCD61d787153Cba6b67795374a058Df84355B60f4/NvidiaMiner -epsw x -dpool stratum+tcp://dcr.suprnova.cc:3252 -dwal nightshade.NvidiaMiner -dpsw x -dcoin dcr -ftime 360 -retrydelay 5" >> start.bash
            echo "./ethdcrminer64 -epool eth-us.dwarfpool.com:8008 -ewal 0xCD61d787153Cba6b67795374a058Df84355B60f4/NvidiaMiner -epsw x -mode 1 -allpools 1 -ftime 360 -retrydelay 5" >> start_only_eth.bash
            chmod +x start.bash
            chmod +x start_only_eth.bash
            cd ..

            echo ""
            echo "Finished installing Claymore's Dual Miner"
            echo "If you want to only mine Ethereum, edit the start_only_eth.bash file with the"
            echo "mining pool you want to your Ethereum wallet address. Then you can run that file"
            echo "and the machine will start mining. If you want to dual mine Ethereum and Decred,"
            echo "edit and then run the start.bash file."
            break
            ;;
        No )
            break
            ;;
    esac
done

echo ""
echo "Do you want to install xmr-stak for CryptoNight mining (Monero, Electroneum)?"
select xmrstak_yn in "Yes" "No"
do
    case $xmrstak_yn in
        Yes )
            echo "Installing xmr-stak"
            # https://github.com/fireice-uk/xmr-stak

            # Compile the code
            sudo apt install libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev -y
            sudo apt install git -y
            git clone https://github.com/fireice-uk/xmr-stak.git
            mkdir xmr-stak/build
            cd xmr-stak/build
            cmake .. -DOpenCL_ENABLE=OFF
            make install
            cd ../..

            echo ""
            echo "Finished building the xmr-stak miner"
            echo ""
            echo "Run the xmr-stak file in the xmr-stack/build folder."
            echo "Once executed, this will guide you through the miner setup process."
            break
            ;;
        No )
            break
            ;;
    esac
done

echo ""
echo "It it recommended to read the documentation for each miner you downloaded."
echo "You might be able to optimize your miner to give you more performance and"
echo "more redundancy."
echo ""
echo "Thank you for using my Nvidia cryptocoin installation script."
echo "If you would like to make suggestions for future scripts, contact me at:"
echo "    joshschertz.com/contact"
echo ""
echo "If you'd like to support me, I'm grateful of any donations:"
echo "    Ethereum: 0xCD61d787153Cba6b67795374a058Df84355B60f4"
echo "    Monero: 49oAK16n2817cnoCnotEsG9mvsj4UBayZUZW78X65zZD1w48GbGoZ2jXCgRpdDtPESUwrXMbJXY52L4kgNEmn9Q4PMSKLMA"

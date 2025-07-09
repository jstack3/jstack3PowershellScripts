if [[ "$EUID" -ne 0 ]]; then

	dir=$(pwd)

	xfconf-query --channel xfce4-keyboard-shortcuts --property "/commands/custom/<Supesr>S" --create --type string --set "flameshot gui"

	xfconf-query --channel xfce4-panel --property "/panels/panel-1/position" --set "p=4;x=0;y=0"

	xfconf-query --channel xfce4-panel --property "/panels/panel-1/size" --set 45

	xfconf-query --channel xfce4-panel --property "/plugins/plugin-19/digital-time-format" --set '%I:%M %p'

	xfconf-query --channel pointers --property "/DELL0A2200_04881024_Touchpad/ReverseScrolling" --set true
	
	xfconf-query --channel pointers --property "/DELL0A2200_04881024_Touchpad/Properties/libinput_Click_Method_Enabled" -s 0 -s 1
	
	
	

	xfce4-panel -r
	
	mkdir /home/kali/Downloads/Dependencies
	
	wget -q 'https://drive.usercontent.google.com/download?id=1irSvrdcJRzOPwSm9HLpOG6ViXpvMG17G&export=download&authuser=0&confirm=t&uuid=1f2b9a01-31a6-495e-8d30-aee2b4e61ad3&at=AN8xHopJ-uUYuEUo2wBqZ69yuUeg%3A1752012245601' -O /home/kali/Downloads/dependencies.zip
	wget -q 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' -O /home/kali/Downloads/Dependencies/chrome.deb
	
	unzip -P Password01 -d /home/kali/Downloads/Dependencies /home/kali/Downloads/dependencies.zip
	
	echo "Not running as root. Elevating with sudo..."
	
	exec sudo "$dir/$0" "$@"

else

	systemctl start bluetooth
	
	timedatectl set-ntp true

	apt update

	apt install -y apt-transport-https curl

	dpkg -i /home/kali/Downloads/Dependencies/*.deb

	mkdir -p /etc/apt/keyrings

	curl -sSfL https://packages.openvpn.net/packages-repo.gpg >/etc/apt/keyrings/openvpn.asc

	echo "deb [signed-by=/etc/apt/keyrings/openvpn.asc] https://packages.openvpn.net/openvpn3/debian bookworm main" >>/etc/apt/sources.list.d/openvpn3.list

	apt update

	apt install -y openvpn3 flameshot

fi



echo 'Run sudo openvpn <.ovpn file> to connect...'

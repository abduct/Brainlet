[![Header](https://user-images.githubusercontent.com/5516806/101231459-5515e700-36a3-11eb-9b82-1362a27a3fcc.png "Header")]()

# Brainlet

## Initial Setup

Prior to any setup or initialization it is recommanded to create a new user which will manage all the printer related configuration and software stack. If using a non armbian image, you may already have a user you can use such as "pi". If not run the following

```
useradd -m brainlet -G sudo,dialout,video,tty
```

Once complete update apt and install the dependencies for the installer:

```
sudo apt update
sudo apt install --yes ruby
sudo gem install --no-document tty-prompt tty-command tty-spinner
```

I recommend attempting to install the listed python2 dependencies for klipper prior to using the software. If your distribution does not have the python2 packages any more, python2 and its related dependencies can be compiled from source via the `Maintenance->Python2` menu.

```
apt install --yes python2 python2-dev virtualenv
```

## Using the software

To begin using the software first login or change the user to the one created then clone this repository to your device:

```
sudo -s -u brainlet
cd ~
git clone https://github.com/abduct/brainlet
```

Afterwards you can launch the installer and follow the guided prompts:

```
cd brainlet
sudo ruby installer.rb
```

If python2 was not able to be installed by your package manager, you have to choose `Maintenance->Python2` before following the next steps.

First time installs should initialize the device by using `Maintenance->Initialize`. This will download and install the entire software stack. This can take anywhere from 5-10 minutes depending on hardware.

After the initialization is complete you may use the `Profiles` menu to List, Create, and Remove profiles from the device. It is recommended that the printers be connected to the device before creating a profile so that its serial TTY device is selectable during profile creation.

## Fluidd Configuration

When creating a printer profile you will be prompted for various information, most notibly the moonraker and webcam ports. These ports must be unique for each profile! When using Fluidd you will be asked for yor moonraker addresses. You should enter your devices lan IP followed by the specific profiles moonraker port ex: `10.0.0.134:7125`. For adding a webcam to the interface, use the devices lan IP followed by the webcams port ex: `http:/10.0.0.134:8080/?action=stream`.

## Printer configuration

All configuration files are located in the configs directory followed by the profiles name ex: `/home/brainlet/configs/imouto`

Only the basics are added to this config to allow klipper to start and it is up to the user to edit the configuration to suite their printer model and hardware. This can be done via vim/nano or by adding a passwd to your user followed by using (win)scp or SFTP. The web UI may also be used for editing the configuration files if moonraker successfully starts during install.

## Services

This software creates all required service files prefixed with the profiles name inside `/etc/systemd/system` and enables them to launch at startup. The three main services are `NAME-klipper.service`, `NAME-moonraker.serice`, and `NAME-webcam.service`. Additionally there is also a `caddy.service` which loads the web interface on port 80 and can provide reverse proxy support if needed via its configle file located in the caddy directory.

## NGROK

NGROK is a tunneling software which allows you to access your fluidd interface from behind NAT and firewall environments. To use NGROK simply use the following commands to download the binary, extract the binary, and run the software. Once the software is running it will provide you with a unique domain to access your install.


```
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
unzip ngrok-stable-linux-arm.zip
./ngrok http 80
```

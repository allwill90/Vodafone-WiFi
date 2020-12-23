This is a script written in bash that lets you automatically connect and refresh connections to Vodafone Hotspots in Italy (although it should work for other countries too with few changes to the url and the parameters which i didn't bother to do since i haven't had the need to use this abroad).
If your internet provider is Vodafone and you use their provided Vodafone Station you can enable a setting in the router which allows for your unused bandwidth to be shared with other people who are Vodafone customers through a secondary wireless interface that broadcasts a standard SSID "Vodafone-WiFi".
The prerequisites to use this are:
1. Being a Vodafone subscriber (you need to register for a Vodafone community account on their website to get your credentials) or have some friend give you their credentials.
2. Having activated the option on the Vodafone Station to share your bandwidth (or have your friend who gave you their credentials do it).
3. Access to a unix system with bash and wget

Then you just need to set the parameters in the script (username and password must be url encoded, you can use any tool you like or use [this](https://www.urlencoder.org/) website.
This was written on Arch linux and tested on Arch, Ubuntu and openwrt 18.06.x to 19.07.5.

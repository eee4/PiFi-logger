#!/bin/bash
#This is a Wi-Fi scanning script made (initially) to use with Raspberry Pi. The script logs nearby Wi-Fi networks to chosen destination. Feel free to add or change something :)
#You can use it for both personal and commercial purposes. You can modify it as you wish without asking anyone for permission.
trap bashtrap INT

bashtrap() #CTRL+C "block"
{
    clear #... the screen
    printf "Quitting. No scans were made.\n" #quick info that everything is ok
    sleep 1 #a little delay before the program ends
    exit
}

echo "Where to save (starting at root filesystem)?: "
read -r path #saving the string as $path

echo "Set delay between scans to (in seconds)?: "
read -r delay #saving the integer as delay

echo "The program will start scanning for networks in 5 seconds."
echo "The program will save data to $path with the delay of $delay."
scans=1 #setting everything up
sleep 5 #some seconds to make sure you read everything :D


echo "Starting scan for networks:" > "$path" #output to file, that the script started working

for (( ; ; )) #starting infinite loop
 do

        if [ $delay == 0 ] #simple if to make sure time is calculated properly
            then 

                time=$scans #time set simply to scans, because why multiply by one? :)

            else 

                time=$((delay*scans)) #calculating time when $delay is positive

        fi #end of statement
        printf "\n\nScan $scans - $time seconds from start\n\n" >> "$path" #printing info to file as a header - I am using here printf, since it allowes me to easily make a new line
                sudo iw dev wlan0 scan | grep SSID >> "$path" #this is where the magic happens - the command is saved to path specified by user
        sleep "$delay" #delay, also chosen by user
        echo "Scan number $scans successfully done. " #information to console, that scan has been successfully done
        scans=$((scans+1)) #let's update the scan number

bashtrap() #this is what happens when you CTRL+C
{
    clear; #clear the screen
    echo "CTRL+C detected. Saving..."
    printf "\n\n\n" >> "$path" #adding new lines to file
    echo "End of scanning. Total scans: $scans" >> "$path" #and a quick log
    echo "Scans in total: $scans. Thank you for using this program. " #info to console, that everything went as planned
    sleep 1; #one second delay before program ends
    exit
}

 done

#!/bin/bash

# This script will use the OpenSCAP scanner to scan your
# system with the chosen profile

# set the directories in which you would like to save the files
BASEDIR="/home/security/SCAP/$(uname -r)/$(date +"%m/%d/%Y")/"
STIGDIR="/home/security/STIGs/"
RPTFILE="${BASEDIR}report-$(date +"%F_%H%M").html"
RSLTSFILE="${BASEDIR}results-$(date +"%F_%H%M").xml"

# set the organic datastream for OpenSCAP to use to search for
# the proper profiles
DATASTREAM="/usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml"

# NOTE: Profiles are found in the xml files above and you can 
# see them by running the following command:
#   oscap info $DATASTREAM
# We will use this command later in the script

# clear the screen to start fresh
clear

# main loop
while true
do
    echo " "
    echo "*****************************************"
    echo "#                                       #"
    echo "#          Welcome to OpenSCAP          #"
    echo "#                                       #"
    echo "*****************************************"
    echo " "
    
    echo -e "Please choose a profile to use: \n"
    
    echo -e "\t1. "
    echo -e "\t2. "
    echo -e "\t3. "
    echo -e "\t4. "
    echo -e "\t0. Exit"
    
    # ask for user input
    read -p "Selection: " choice
    
    # create a response to the user input
    case in $choice
        1)
            echo -e "You have chosen the Payment Card Industry - Data Security Standard profile.\n"
            read -p "Do you wish to continue? " answer
            if [[ $answer =~ ^(y|Y|yes|Yes|YES) ]]
            then
                SECONDS=0
                PROFILE="$(oscap info $DATASTREAM | grep content_profile_pci-dss | awk '{print $2}')"
                oscap xccdf eval --profile $PROFILE --results-arf $RSLTFILE --report $RPTFILE $DATASTREAM
                echo "Scan complete. Please follow the link below to see the results in your browser.\n"
                echo -e "file://${RPTFILE}\n"
                echo "Elapsed time: $(($SECONDS / 3600))h:$((($SECONDS / 60) % 60))m:$(($SECONDS % 60))s"
                break
            elif [[ $answer =~ ^(n|N|no|No|NO) ]]
            then
                clear
                continue
            fi
            ;;
        2)
            echo -e "You have chosen the OS Security Protection profile.\n"
            read -p "Do you wish to continue? " answer
            if [[ $answer =~ ^(y|Y|yes|Yes|YES) ]]
            then
                SECONDS=0
                PROFILE="$(oscap info $DATASTREAM | grep content_profile_ospp | awk '{print $2}')"
                oscap xccdf eval --profile $PROFILE --results-arf $RSLTFILE --report $RPTFILE $DATASTREAM
                echo "Scan complete. Please follow the link below to see the results in your browser.\n"
                echo -e "file://${RPTFILE}\n"
                echo "Elapsed time: $(($SECONDS / 3600))h:$((($SECONDS / 60) % 60))m:$(($SECONDS % 60))s"
                break
            elif [[ $answer =~ ^(n|N|no|No|NO) ]]
            then
                clear
                continue
            fi
            ;;
        3)
            echo -e "You have chosen the Standard Security for General Operating Systems profile.\n"
            read -p "Do you wish to continue? " answer
            if [[ $answer =~ ^(y|Y|yes|Yes|YES) ]]
            then
                SECONDS=0
                PROFILE="$(oscap info $DATASTREAM | grep content_profile_standard | awk '{print $2}')"
                oscap xccdf eval --profile $PROFILE --results-arf $RSLTFILE --report $RPTFILE $DATASTREAM
                echo "Scan complete. Please follow the link below to see the results in your browser.\n"
                echo -e "file://${RPTFILE}\n"
                echo "Elapsed time: $(($SECONDS / 3600))h:$((($SECONDS / 60) % 60))m:$(($SECONDS % 60))s"
                break
            elif [[ $answer =~ ^(n|N|no|No|NO) ]]
            then
                clear
                continue
            fi
            ;;
        4)
            echo -e "You have chosen the DISA RHEL 7 Benchmark STIG profile.\n"
            read -p "Do you wish to continue? " answer
            if [[ $answer =~ ^(y|Y|yes|Yes|YES) ]]
            then
                SECONDS=0
                if [[ ! -d $BASEDIR ]]
                then
                    echo -e "Creating directory...\n"
                    mkdir -pv $BASEDIR
                fi
                ZIPS="$(find $STIGDIR -type f 2> /dev/null | grep *.zip)"
                if [[ -n $ZIPS ]]
                then
                    echo -e "Unpacking files...\n"
                    unzip -oq $STIGS
                fi
                XML="$(find $STIGDIR -type f 2> /dev/null | grep *.xml | sort | tail -n 1)"
                STIG="$(echo $XML | awk -F_ '{print $3,$4}')"
                echo "Loading DISA STIG RHEL $STIG..."
                read -p "Is this correct? " answer
                if [[ $answer =~ ^(y|Y|yes|Yes|YES)$ ]]
                then
                    PROFILE="$(oscap info $XML | grep content_profile_standard | awk '{print $2}')"
                    oscap xccdf eval --profile $PROFILE --results-arf $RSLTFILE --report $RPTFILE $DATASTREAM
                    echo "Scan complete. Please follow the link below to see the results in your browser.\n"
                    echo -e "file://${RPTFILE}\n"
                    echo "Elapsed time: $(($SECONDS / 3600))h:$((($SECONDS / 60) % 60))m:$(($SECONDS % 60))s"
                    break
                fi
            elif [[ $answer =~ ^(n|N|no|No|NO) ]]
            then
                clear
                continue
            fi
            ;;
        0)
            echo -e "Exiting. Thank you for using OpenSCAP.\n"
            break
            ;;
        *)
            echo -e "Invalid selection. Please try again.\n"
            sleep 2
            clear
            ;;
    esac
    
    

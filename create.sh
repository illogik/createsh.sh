#!/bin/bash

############################################
#                                          #
# create.sh - Authored by Tony Perretta    #
# A shell script, to create shell scripts! #
#                                          #
############################################

#### Functions

# Function for showing the useage of the script

function useage()
{
    echo "useage: create [ [[-f file] [-a author] [-d description] [-i]] | [-h] ] --! Enclose strings in \"\" !--"

}

# Function creatomg tje fo;e amd cjamgomg tje name

function createfile()
{

if [[ "$name" != "" ]]; then

    touch "$name"

    chmod +x "$name"

    extension=$(echo $name | cut -d "." -f2)

    if [[ "$extension" != "sh" ]]; then
        mv "$name" "$name".sh
    fi

else

    useage

    exit 1

fi

}

# Function to write output to file

function writeout()
{

if [[ "$extension" = "sh" ]]; then
    cat > "$name" << _EOF_
#!/bin/bash

# Script name: $name
# Author: $AUTHOR
# Created on: $(date +"%D")
# Description: $DESCRIPTION
_EOF_

else
    cat > "$name".sh << _EOF_
#!/bin/bash

# Script name: $name.sh
# Author: $AUTHOR
# Created on: $(date +"%D")
# Description: $DESCRIPTION
_EOF_

fi

}

# Function to check if an editor is set

function editcheck()
{
if [[ -n "$EDITOR" ]]; then

    "$EDITOR" "$name"
	
else 

	vim "$name"
	
fi
}


###############
##   Main    ##
###############

# Settings things up for interactive mode

interactive=
while [[ "$1" != "" ]]; do
    case $1 in
        -f | --file )           shift
                                name="$1"
                                ;;
        -a | --author )         shift
                                AUTHOR="$1"
                                ;;
        -d | --descripption )   shift
                                DESCRIPTION="$1"
                                ;;
        -i | --interactive )    interactive=1
                                ;;
        -h | --help )           useage
                                exit
                                ;;
        * )                     useage
                                exit 1
    esac
    shift
done

# If interactive mode is selected then enter interactive mode, or if no parameters are given echo usage and exit

if [[ "$interactive" == "1" ]]; then

    read -p "What would you like your script to be named ? > " name

    if [ -f "$name" -o -f "${name}.sh" ]; then
        read -p "Output file allready exists. Overwrite? (y/n) > " response
        if [ "$response" != "y" ]; then
            echo "Exiting"
            exit 1
        fi
    fi

    createfile

    read -p "What is your name? > " AUTHOR
    read -p "Enter a short description of what your script does > " DESCRIPTION

writeout

elif [[ "$interactive" != "1" ]]; then

    createfile

    writeout

else

    useage

    exit 1
fi

# Prompt if user would like to begin editing the file. If yes, use set editor or Vim if none are set

read -p "Would you like the begin editing the file now? (y/n) > " response2

if [[ "$response2" == "y" ]]; then

	editcheck
	
else

	exit 0
	
fi
	
	

	

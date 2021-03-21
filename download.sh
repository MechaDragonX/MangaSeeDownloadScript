# Display help information
_print_help() {
    printf "Usage: <Script Filename> <Series Title> <Chapter Number> <Page Count> [-d] <External Directory>\n"
    printf "\n"
    printf "\"Series Title\": The title of the series you wish to download. Must be in romanized form. This does not\n"
    printf "\t\tmean Romaji, as characters that refelect long tones are often dropped. Please see\n"
    printf "\t\tthe MangaSee website for the titles used.\n"
    printf "\"Chapter Number\": The number of the chapter you wish to download.\n"
    printf "\"Page Count\": The number of pages you wish to downoad.\n"
    printf "\"-d\": The external directory switch. You must use this switch if you wish to download to directory\n"
    printf "      other than where you are executing the script from.\n"
    printf "\"External Directory\": The path to the directory you wish to download to. If you do not use the switch,\n"
    printf "\t\t      all files are downloaded to the directory you are executing the script from.\n"
}
# Determine the correct number of zeroes to prefix the chapter number (ex. "66" means "00" in order to have "0066")
# $1 = Length of Chapter Number
_calc_chapter_num_zeroes() {
    case $1 in
        1)
            echo "000"
            ;;
        2)
            echo "00"
            ;;
        3)
            echo "0"
            ;;
    esac
}
# Test each server using the passed chapter and the first page
# Example URL: "https://scans-ongoing-1.lastation.us/manga/Grand-Blue/0066-001.png"
# $1 = Series Name in Kebab Case
# $2 = Zeroes Prefixing Chapter Number
# $3 = Chapter Number
_gen_base_url() {
    # URL stub for each of the possible servers
    _official_ongoing="https://official-ongoing-1.ivalice.us/manga/"
    _scan_ongoing="https://scans-ongoing-1.lastation.us/manga/"
    _official_complete="https://official-complete-1.granpulse.us/manga/"
    _scan_complete="https://scans-complete.hydaelyn.us/manga/"

    # Test official ongoing for 200
    if [[ $(wget -S --spider "$_official_ongoing$1/$2$3-001.png" 2>&1 | grep 'HTTP/1.1 200 OK') ]]; then
        echo "$_official_ongoing$1/$2$3"
        return 0
    # Test scan ongoing for 200
    elif [[ $(wget -S --spider "$_scan_ongoing$1/$2$3-001.png" 2>&1 | grep 'HTTP/1.1 200 OK') ]]; then
        echo "$_scan_ongoing$1/$2$3"
        return 0
    # Test official complete for 200
    elif [[ $(wget -S --spider "$_official_complete$1/$2$3-001.png" 2>&1 | grep 'HTTP/1.1 200 OK') ]]; then
        echo "$_official_complete$1/$2$3"
        return 0
    # Test scan complete for 200
    elif [[ $(wget -S --spider "$_scan_complete$1/$2$3-001.png" 2>&1 | grep 'HTTP/1.1 200 OK') ]]; then
        echo "$_scan_complete$1/$2$3"
        return 0
    else
        echo "Something went wrong! Please execute the script on the own to see the help." 1>&2
        printf "Possible Errors: - The series name isn't written in romanized Japanese\n" 1>&2
        printf "\t\t - The chapter number is not a number\n" 1>&2
        printf "\t\t - The page count is not a number\n" 1>&2
        return 1
    fi
}
# Check to see if a external directory switch is present and then create an external directory if it doesn't already exist
# $1 = Switch
# $2 = Path to External Directory
_create_external_dir() {
    # Check to see if a switch is present
    if [[ "$1" != "" ]]; then
        if [[ "$2" != "" ]]; then
            # Only create the directory if it doesn't arleady exist
            mkdir -p $2
            return 0
        else
            echo "No external directory path has been passed!" 1>&2
            return 1
        fi
    fi
    return 0
}
# Determine the correct number of zeroes to prefix the page number (ex. "51" means "0" in order to have "051")
# $1 = Length of Page Number
_calc_page_num_zeroes() {
    if (($1 == 1)); then
        echo "00"
    elif (($1 == 2)); then
        echo "0"
    fi
}
# Determine the correct number of zeroes to prefix the filename (ex. "1" means "0" in order to have "01")
# $1 = Length of Page Number
_calc_filename_zeroes() {
    if (($1 == 1)); then
        echo "0"
    fi
}

###
# Main Body
###
# $1 = Series Name
# $2 = Chapter Number
# $3 = Number of Pages
# $4 = "-d"; Download to External Directory Switch
# $5 = Path to download (optional; if not passed, will download to current directory)

# Exit if any functions returns a non-zero value
set -e

if (($# == 0)); then
    # Display help information
    _print_help
    exit 0
elif (($# < 3 && $# != 0)); then
    echo "You need at least 3 arguments!"
    echo "Please execute the script with no arguments for help."
    exit 1
elif (($# > 5)); then
    echo "You only need at least 3 arguments! 5 are are required for optional functionality."
    echo "Please execute the script with no arguments for help."
    exit 1
fi

# Convert series name to kebab case (ex. "Grand Blue" to "Grand-Blue")
_series_name_kebab="${1// /-}"
# Calculate number of digits in chapter number
_chapter_num_len=$(expr length "$2")

# Determine the correct number of zeroes to prefix the chapter number (ex. "66" means "00" in order to have "0066")
_chapter_num_zeroes=$(_calc_chapter_num_zeroes $_chapter_num_len)

# Test each server using the passed chapter and the first page
# Example URL: "https://scans-ongoing-1.lastation.us/manga/Grand-Blue/0066-001.png"
_base_url=$(_gen_base_url $_series_name_kebab $_chapter_num_zeroes $2)
_file_extension=".png"

# Check to see if a external directory switch is present and then create an external directory if it doesn't already exist
$(_create_external_dir $4 $5)

# Create URL's using the proper number of leading zeroes
_page_num_zeroes=""
_filename_zeroes=""
for ((i=1; i<=$3; i++)); do
    # Generate leading zeroes for page number
    _page_num_zeroes=$(_calc_page_num_zeroes $(expr length "$i"))
    # Generate leading zeroes for filename
    _filename_zeroes=$(_calc_filename_zeroes $(expr length "$i"))

    # Download all pages
    # Check to see if a external directory switch is present
    if [[ "$4" != "" ]]; then
        # Check to see if the passed directory contains a slash
        if [[ ${5: -1} = "/" ]]; then
            wget -O $5$_filename_zeroes$i$_file_extension "$_base_url-$_page_num_zeroes$i$_file_extension"
        else
            wget -O "$5/$_filename_zeroes$i$_file_extension" "$_base_url-$_page_num_zeroes$i$_file_extension"
        fi
    else
        wget -O $_filename_zeroes$i$_file_extension "$_base_url-$_page_num_zeroes$i$_file_extension"
    fi
done

exit 0

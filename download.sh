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
    if [[ `wget -S --spider "$_official_ongoing$1/$2$3-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
        echo "$_official_ongoing$1/$2$3"
        return 0
    # Test scan ongoing for 200
    elif [[ `wget -S --spider "$_scan_ongoing$1/$2$3-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
        echo "$_scan_ongoing$1/$2$3"
        return 0
    # Test official complete for 200
    elif [[ `wget -S --spider "$_official_complete$1/$2$3-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
        echo "$_official_complete$1/$2$3"
        return 0
    # Test scan complete for 200
    elif [[ `wget -S --spider "$_scan_complete$1/$2$3-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
        echo "$_scan_complete$1/$2$3"
        return 0
    else
        echo "That series isn't on MangaSee!" 1>&2
        echo "Make sure to pass the romanized Japanese name (but not Romaji) and not the official English title! Check MangaSee for what names are used." 1>&2
        return 1
    fi
}

###
# Main Body
###
# $1 = Series Name
# $2 = Chapter Number
# $3 = Number of Pages

# Exit if any functions returns a non-zero value
set -e

# Convert series name to kebab case (ex. "Grand Blue" to "Grand-Blue")
_series_name_kebab="${1// /-}"
# Calculate number of digits in chapter number
_chapter_num_len=$(expr length "$2")
# Calculate number of digits in page count
_page_count_len=$(expr length "$3")

# Determine the correct number of zeroes to prefix the chapter number (ex. "66" means "00" in order to have "0066")
_chapter_num_zeroes=$(_calc_chapter_num_zeroes $_chapter_num_len)

# Test each server using the passed chapter and the first page
# Example URL: "https://scans-ongoing-1.lastation.us/manga/Grand-Blue/0066-001.png"
_base_url=$(_gen_base_url $_series_name_kebab $_chapter_num_zeroes $2)

# Determine the correct number of zeroes to prefix the chapter number (ex. "51" means "0" in order to have "051")
# _page_num_zeroes=""
# case $_chapter_num_len in
#     1)
#         _page_num_zeroes="00"
#         ;;
#     2)
#         _page_num_zeroes="0"
#         ;;
# esac

echo "$_base_url-001.png"

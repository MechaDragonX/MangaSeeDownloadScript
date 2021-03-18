# $1 = Series Name
# $2 = Chapter Number
# $3 = Number of Pages

# URL stub for each of the possible servers
_official_ongoing="https://official-ongoing-1.ivalice.us/manga/"
_scan_ongoing="https://scans-ongoing-1.lastation.us/manga/"
_official_complete="https://official-complete-1.granpulse.us/manga/"
_scan_complete="https://scans-complete.hydaelyn.us/manga/"

# Convert series name to kebab case (ex. "Grand Blue" to "Grand-Blue")
_series_name_kebab="${1// /-}"
# Calculate number of digits in chapter number
_chapter_num_len=$(expr length "$2")
# Calculate number of digits in page count
_page_count_len=$(expr length "$3")

# Determine the correct number of zeroes to prefix the chapter number (ex. "66" means "00" in order to have "0066")
_chapter_num_zeroes=""
case $chapterNumLen in
    1)
        _chapter_num_zeroes="000"
        ;;
    2)
        _chapter_num_zeroes="00"
        ;;
    3)
        _chapter_num_zeroes="0"
        ;;
esac

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

# Test each server using the passed chapter and the first page
# Example URL: "https://scans-ongoing-1.lastation.us/manga/Grand-Blue/0066-001.png"
_url=""
# Test official ongoing for 200
if [[ `wget -S --spider "$_official_ongoing$_series_name_kebab/$_chapter_num_zeroes$2-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
    _url="$_official_ongoing$_series_name_kebab/$_chapter_num_zeroes$2-001.png"
# Test scan ongoing for 200
elif [[ `wget -S --spider "$_scan_ongoing$_series_name_kebab/$_chapter_num_zeroes$2-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
    _url="$_scan_ongoing$_series_name_kebab/$_chapter_num_zeroes$2-001.png"
# Test official complete for 200
elif [[ `wget -S --spider "$_official_complete$_series_name_kebab/$_chapter_num_zeroes$2-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
    _url="$_official_complete$_series_name_kebab/$_chapter_num_zeroes$2-001.png"
# Test scan complete for 200
elif [[ `wget -S --spider "$_scan_complete$_series_name_kebab/$_chapter_num_zeroes$2-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
    _url="$_scan_complete$_series_name_kebab/$_chapter_num_zeroes$2-001.png"
fi

echo $_url

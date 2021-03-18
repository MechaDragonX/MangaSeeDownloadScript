# $1 = Series Name
# $2 = Chapter
# $3 = Number of Pages

# URL stub for each of the possible servers
officialOngoing="https://official-ongoing-1.ivalice.us/manga/"
scanOngoing="https://scans-ongoing-1.lastation.us/manga/"
officialComplete="https://official-complete-1.granpulse.us/manga/"
scanComplete="https://scans-complete.hydaelyn.us/manga/"

# Convert series name to kebab case (ex. "Grand Blue" to "Grand-Blue")
seriesNameKebab="${1// /-}"
# Calculate number of digits in chapter number
chapterNumLen=$(expr length "$2")
# Calculate number of digits in page count
pageCountLen=$(expr length "$3")

# Determine the correct number of zeroes to prefix the chapter number (ex. "66" means "00" in order to have "0066")
chapterNumZeroes=""
case $chapterNumLen in
    1)
        chapterNumZeroes="000"
        ;;
    2)
        chapterNumZeroes="00"
        ;;
    3)
        chapterNumZeroes="0"
        ;;
esac

# Determine the correct number of zeroes to prefix the chapter number (ex. "51" means "0" in order to have "051")
# pageNumZeroes=""
# case $chapterNumLen in
#     1)
#         pageNumZeroes="00"
#         ;;
#     2)
#         pageNumZeroes="0"
#         ;;
# esac

# Test each server using the passed chapter and the first page
# Example URL: "https://scans-ongoing-1.lastation.us/manga/Grand-Blue/0066-001.png"
url=""
# Test official ongoing for 200
if [[ `wget -S --spider "$officialOngoing$seriesNameKebab/$chapterNumZeroes$2-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
    url="$officialOngoing$seriesNameKebab/$chapterNumZeroes$2-001.png"
# Test scan ongoing for 200
elif [[ `wget -S --spider "$scanOngoing$seriesNameKebab/$chapterNumZeroes$2-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
    url="$scanOngoing$seriesNameKebab/$chapterNumZeroes$2-001.png"
# Test official complete for 200
elif [[ `wget -S --spider "$officialComplete$seriesNameKebab/$chapterNumZeroes$2-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
    url="$officialComplete$seriesNameKebab/$chapterNumZeroes$2-001.png"
# Test scan complete for 200
elif [[ `wget -S --spider "$scanComplete$seriesNameKebab/$chapterNumZeroes$2-001.png" 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
    url="$scanComplete$seriesNameKebab/$chapterNumZeroes$2-001.png"
fi

echo $url

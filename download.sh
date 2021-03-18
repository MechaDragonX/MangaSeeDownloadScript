# $1 = Series Name
# $2 = Chapter
# $3 = Number of Pages

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

# Example URL: "https://scans-ongoing-1.lastation.us/manga/Grand-Blue/0066-001.png"
url="https://scans-ongoing-1.lastation.us/manga/$seriesNameKebab/$chapterNumZeroes$2-001.png"
echo $url

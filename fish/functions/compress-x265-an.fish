function compress-x265-an -d "Compress video to x265 without audio"
    if not argparse -N 2 -X 2 'crf=' 'scale=' -- $argv
        echo "Usage: $(status function) [--crf <crf>] [--scale <scale>] <input> <output>"
        return 1
    end

    if test -z $_flag_crf
        set _flag_crf 30
    end

    if test -z $_flag_scale
        set _flag_scale 1920x1080
    end

    ffmpeg -i $argv[1] -c:v libx265 -crf $_flag_crf -s $flag_scale -an $argv[2]
end

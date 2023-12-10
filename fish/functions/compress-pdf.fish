function compress-pdf -d "Compress PDF"
    if not argparse -N 2 -X 2 'preset=' -- $argv
        echo "Usage: $(status function) [--preset=<preset>] <input> <output>"
        return 1
    end

    if test -z $preset
        set preset ebook
    end

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/$_flag_preset -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$argv[2] $argv[1]
end

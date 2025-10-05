function compress-pdf-for-kindle -d "Compress PDF"
    if not argparse -N 2 -X 2 'preset=' -- $argv
        echo "Usage: $(status function) [--preset=<preset>] <input> <output>"
        return 1
    end

    if test -z $preset
        set preset ebook
    end

    # https://ghostscript.com/blog/optimizing-pdfs.html
    # https://ghostscript.readthedocs.io/en/gs10.0.0/VectorDevices.html#the-family-of-pdf-and-postscript-output-devices

    gs \
        -sDEVICE=pdfwrite \
        -dPDFSETTINGS=/$_flag_preset \
        -sCompatibilityLevel=1.7 \
        -dAutoFilterGrayImages=false \
        -dAutoFilterColorImages=false \
        -dPassThroughJPEGImages=false \
        -dPassThroughJPXImages=false \
        # -dConvertCMYKImagesToRGB=true \
        -sColorConversionStrategy=Gray \
        -dNOPAUSE \
        -dBATCH \
        -sOutputFile=$argv[2] \
        $argv[1]
end


function linecount
    awk '{print; fflush()} END {print NR " lines"}'
end

function check-zip -d "Test the integrity of ZIP archives"
    argparse h/help q/quiet v/verbose -- $argv
    or return 2

    if set -q _flag_help; or test (count $argv) -eq 0
        echo "Usage: $(status function) [-q|--quiet] [-v|--verbose] <archive.zip>..."
        echo
        echo "Tests each archive with 7z, one line per archive:"
        echo "  ok      verified, nothing to report"
        echo "  ok      in yellow: verified, but 7z had something to say"
        echo "  warn    could not be verified, an encrypted archive for instance"
        echo "  FAILED  damaged, truncated, or not a zip at all"
        echo
        echo "  -q  only the final summary"
        echo "  -v  show every note from 7z, instead of the first few"
        set -q _flag_help; and return 0
        return 2
    end

    if not command -q 7z
        echo (status function)": needs 7z, which isn't installed (pacman -S 7zip)" >&2
        return 127
    end

    # Colors and the progress line only make sense on a terminal.
    set -l c_ok ""
    set -l c_bad ""
    set -l c_warn ""
    set -l c_dim ""
    set -l c_off ""
    set -l erase ""
    if isatty stdout
        set c_ok (set_color green)
        set c_bad (set_color red)
        set c_warn (set_color yellow)
        set c_dim (set_color brblack)
        set c_off (set_color normal)
        set -q _flag_quiet; or set erase (printf '\r\e[K')
    end

    # Width of the name column, so the details line up.
    set -l width 12
    for f in $argv
        set -l n (string length -- $f)
        test $n -gt $width; and set width $n
    end
    test $width -gt 44; and set width 44

    # Boilerplate 7z prints whatever happens. Anything surviving this filter is
    # worth showing: an error, a warning, a stub offset, trailing data. Better to
    # show a line I didn't anticipate than to hide it.
    set -l noise '^$' '^7-Zip ' '^ *64-bit ' '^Scanning the drive' \
        '^[0-9]+ files?, [0-9]+ bytes' '^Testing archive:' '^--$' \
        '^(Path|Type|Physical Size|64-bit|Characteristics) = ' \
        '^Everything is Ok$' '^(Size|Compressed|Files|Folders): ' \
        '^Archives with ' '^(Warnings|Errors): [0-9]' '^(Sub items|Open) Errors: ' \
        '^(ERRORS|WARNINGS):$'

    set -l n_ok 0
    set -l n_note 0
    set -l n_warn 0
    set -l n_bad 0

    for f in $argv
        set -l mark
        set -l detail
        set -l notes

        # Big archives take minutes each, so say which one is running. The line
        # is erased by the verdict that replaces it.
        test -n "$erase"; and printf '%s%s… %s%s' $erase $c_dim $f $c_off

        if not test -e $f
            set mark bad
            set detail "no such file"
        else if test -d $f
            set mark bad
            set detail "is a directory"
        else
            # -tzip so a self-extracting stub doesn't get it waved off as "not an
            # archive"; -p'' so an encrypted one reports itself instead of
            # stopping to ask for a password.
            set -l out (7z t -tzip -bsp0 -p'' -- $f </dev/null 2>&1 | string collect)
            set -l rc $pipestatus[1]

            set -l lines (string split \n -- $out | string trim)
            if test (count $lines) -gt 0
                for pat in $noise
                    set lines (string match -rv -- $pat $lines)
                    test (count $lines) -gt 0; or break
                end
            end
            # 7z also echoes the archive's own path back, twice, around its errors.
            if test (count $lines) -gt 0
                set lines (string match -v -- $f $lines)
            end
            if test (count $lines) -gt 0
                set lines (string match -rv -- '^ERROR: '(string escape --style=regex -- $f)'$' $lines)
            end
            # 7z repeats its warnings, once per archive and once in the summary.
            for l in $lines
                contains -- $l $notes; or set -a notes $l
            end

            # 7z reports Files: only when there's more than one.
            set -l size (string match -r '(?m)^Size: +([0-9]+)' -- $out)[2]
            set -l files (string match -r '(?m)^Files: +([0-9]+)' -- $out)[2]
            set -l totals
            if test -n "$size"
                test -n "$files"; or set files 1
                set -l human "$size B"
                if test $size -ge 1073741824
                    set human (math -s1 $size/1073741824)" GiB"
                else if test $size -ge 1048576
                    set human (math -s1 $size/1048576)" MiB"
                else if test $size -ge 1024
                    set human (math -s0 $size/1024)" KiB"
                end
                # Careful: concatenating onto an empty command substitution
                # gives an empty list, not the string, so spell the plural out.
                set -l unit files
                test $files -eq 1; and set unit file
                set totals "$files $unit, $human"
            end

            if string match -qr 'Wrong password' -- $out
                set mark warn
                set detail "encrypted, not verified (needs the password)"
                set notes
            else if string match -qr 'Cannot open the file as|Is not archive' -- $out
                set mark bad
                set detail "not a zip archive, or truncated"
            else if string match -qr 'Unexpected end of archive' -- $out
                set mark bad
                set detail "truncated (unexpected end of archive)"
            else if test $rc -eq 0 -o $rc -eq 1
                # Data checks out. Yellow when 7z still had a remark about it.
                if test (count $notes) -gt 0
                    set mark note
                    set detail "$totals, with notes"
                else
                    set mark ok
                    set detail "$totals"
                end
            else
                set mark bad
                set -l errs (string match -r '^ERROR' -- $notes)
                if test (count $errs) -gt 0
                    set detail (count $errs)" bad entr"(test (count $errs) -eq 1; and echo y; or echo ies)
                else
                    set detail "failed (7z exit $rc)"
                end
            end
        end

        set -l marker
        set -l c_detail $c_dim
        switch $mark
            case ok
                set n_ok (math $n_ok + 1)
                set marker "$c_ok""ok    $c_off"
            case note
                set n_note (math $n_note + 1)
                set marker "$c_warn""ok    $c_off"
            case warn
                set n_warn (math $n_warn + 1)
                set marker "$c_warn""warn  $c_off"
                set c_detail ""
            case bad
                set n_bad (math $n_bad + 1)
                set marker "$c_bad""FAILED$c_off"
                set c_detail ""
        end

        if not set -q _flag_quiet
            printf '%s%s  %-*s  %s%s%s\n' $erase $marker $width $f $c_detail "$detail" $c_off

            # Quote what 7z actually said, rather than paraphrasing it.
            if test (count $notes) -gt 0
                set -l shown $notes
                set -q _flag_verbose
                or set shown $notes[1..(math min 3, (count $notes))]
                for line in $shown
                    printf '        %s%s%s\n' $c_dim $line $c_off
                end
                set -l hidden (math (count $notes) - (count $shown))
                test $hidden -gt 0
                and printf '        %s… and %d more%s\n' $c_dim $hidden $c_off
            end
        end
    end

    # A single archive already said everything on its own line.
    if test (count $argv) -gt 1; or set -q _flag_quiet
        set -l parts "$n_ok ok"
        test $n_note -gt 0; and set -a parts "$n_note ok with notes"
        test $n_warn -gt 0; and set -a parts "$n_warn not verified"
        test $n_bad -gt 0; and set -a parts "$n_bad failed"
        set -q _flag_quiet; or echo
        printf '%d archives: %s\n' (count $argv) (string join ", " $parts)
    end

    test $n_bad -eq 0
end

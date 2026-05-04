# Based on https://github.com/arbelt/fish-plugin-scmpuff,
# with fish3 fix https://github.com/arbelt/fish-plugin-scmpuff/pull/3
function scmpuff_status
    scmpuff_clear_vars
    set -lx scmpuff_env_char "e"
    set -l cmd_output (/usr/bin/env scmpuff status --filelist $argv)
    set -l es "$status"

    if test $es -ne 0
        return $es
    end

    set -l files (string split \t $cmd_output[1])
    if test (count $files) -gt 0
        for e in (seq (count $files))
            set -gx "$scmpuff_env_char""$e" "$files[$e]"
        end
    end

    for line in $cmd_output[2..-1]
        echo $line
    end
end

function scmpuff_branch
    # When invoked with arguments, delegate to `git branch` (via `scmpuff exec`
    # so numeric shortcuts still expand). The numbered-listing path only runs
    # when called with no arguments.
    if test (count $argv) -gt 0
        scmpuff exec -- git branch $argv
        return $status
    end

    scmpuff_clear_vars
    set -lx scmpuff_env_char "e"
    set -l cmd_output (/usr/bin/env scmpuff branch --branchlist)
    set -l es "$status"

    if test $es -ne 0
        return $es
    end

    set -l files (string split \t $cmd_output[1])
    if test (count $files) -gt 0
        for e in (seq (count $files))
            set -gx "$scmpuff_env_char""$e" "$files[$e]"
        end
    end

    for line in $cmd_output[2..-1]
        echo $line
    end
end

function scmpuff_clear_vars
    set -l scmpuff_env_char "e"
    set -l scmpuff_env_vars (set -x | awk '{print $1}' | grep -E '^'$scmpuff_env_char'[0-9]+')

    for v in $scmpuff_env_vars
        set -e $v
    end
end

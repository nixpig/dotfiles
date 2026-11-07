
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

# opencode
export PATH=/Users/jacobward/.opencode/bin:$PATH
# cooldowns:yarn:start
export YARN_NPM_MINIMAL_AGE_GATE="4320"
# cooldowns:yarn:end
# cooldowns:pip:start
pip3() {
    local pip_major cutoff
    pip_major=$(command pip3 --version 2>/dev/null | awk '{ split($2, a, "."); print a[1]; exit }')
    case "$1" in
        install|download|wheel)
            if [[ "${pip_major:-0}" -ge 26 ]]; then
                cutoff=$(date -u -v-3d '+%Y-%m-%dT%H:%M:%SZ')
                command pip3 "$1" --uploaded-prior-to "$cutoff" "${@:2}"
            else
                echo "warning: pip3 ${pip_major:-unknown} does not support --uploaded-prior-to (need >= 26), skipping cooldown" >&2
                command pip3 "$@"
            fi
            ;;
        *)
            command pip3 "$@"
            ;;
    esac
}
# cooldowns:pip:end

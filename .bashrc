
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

# opencode
export PATH=/Users/jacobward/.opencode/bin:$PATH
# cooldowns:yarn:start
export YARN_NPM_MINIMAL_AGE_GATE="4320"
# cooldowns:yarn:end
# cooldowns:pip:start
export PIP_UPLOADED_PRIOR_TO="P3D"
# cooldowns:pip:end

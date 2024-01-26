# ===-- log.mk -- Logging helper functions ----------------------------------===

COLOR_BLUE	:= tput -Txterm setaf 6
COLOR_GREEN	:= tput -Txterm setaf 2
COLOR_WHITE	:= tput -Txterm setaf 7
COLOR_RED	:= tput -Txterm setaf 1
COLOR_RESET	:= tput -Txterm sgr0

# Shorthand to silence a command's output, can be appended to any command.
export HUSH	?= >/dev/null 2>&1

# Log an high-level, important message, e.g. starting a major task.
log = { $(COLOR_GREEN); echo $1; $(COLOR_RESET); }

# Log a minor, less-important message, e.g. the state of a sub-task.
log_info = { $(COLOR_BLUE); echo $1; $(COLOR_RESET); }

# Log an error and terminate.
log_fatal = { $(COLOR_RED); echo $1; $(COLOR_RESET); exit 1; }

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <os/log.h>

int main(int argc, char **argv)
{
    os_log_t log = os_log_create("com.jonpalmisc.srdsh", "cryptex-run");

    if (argc < 2) {
        os_log_error(log, "Invalid invocation of `%{public}s`\n", argv[0]);
        return EXIT_FAILURE;
    }

    // If this fails, it is likely that the configuration for the daemon
    // invoking this tool is missing the `EnvironmentVariables` key, which
    // tells `cryptexd` to set `CRYPTEX_MOUNT_PATH` for us.
    char *cryptex_root = getenv("CRYPTEX_MOUNT_PATH");
    if (cryptex_root == NULL) {
        os_log_error(log, "Required environment variable `CRYPTEX_MOUNT_PATH` is not set\n");
        return EXIT_FAILURE;
    }

    char *path = NULL;
    asprintf(&path, "%s/usr/bin:%s/bin:%s", cryptex_root, cryptex_root, getenv("PATH"));
    if (!path) {
        os_log_error(log, "Internal failure, failed to assemble `PATH` variable for process");
        return EXIT_FAILURE;
    }

    char **binary = ++argv;
    char **args = binary;

    os_log_info(log, "Launching `%{public}s` using `PATH` value of `%{public}s`", *binary, path);
    setenv("PATH", path, true);
    execvP(*binary, path, args);

    os_log_error(log, "Failed to execute `%{public}s` (%{public}s)\n", *binary, strerror(errno));
    return EXIT_FAILURE;
}

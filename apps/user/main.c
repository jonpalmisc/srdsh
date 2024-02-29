#include <stdio.h>

#include <os/log.h>

int main(int argc, char const **argv)
{
    os_log_t log = os_log_create("com.jonpalmisc.srdsh", "user");
    os_log_info(log, "Hello, world!");

    puts("Hello, world!");

    return 0;
}

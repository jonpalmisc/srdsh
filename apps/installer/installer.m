#import <Foundation/Foundation.h>
#include <stdio.h>

#include <os/log.h>

@interface LSApplicationWorkspace : NSObject

+ (instancetype)defaultWorkspace;
- (BOOL)installApplication:(id)app withOptions:(id)options;

@end

int main(int argc, char const **argv)
{
    os_log_t log = os_log_create("com.jonpalmisc.srdsh", "install-ipa");
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <ipa> <bundle-id>\n", argv[0]);
        os_log_error(log, "IPA installer invoked incorrectly!");
        return EXIT_FAILURE;
    }

    char const *rawAppPath = argv[1];
    char const *rawBundleId = argv[2];

    NSString *appPath = [NSString stringWithUTF8String:rawAppPath];
    NSString *bundleId = [NSString stringWithUTF8String:rawBundleId];
    NSURL *appURL = [NSURL fileURLWithPath:appPath];
    NSDictionary *options = [NSDictionary dictionaryWithObject:bundleId forKey:@"CFBundleIdentifier"];

    os_log_info(log, "Requesting install of %{public}s (%{public}s)...", rawAppPath, rawBundleId);
    LSApplicationWorkspace *workspace = [LSApplicationWorkspace defaultWorkspace];
    BOOL ok = [workspace installApplication:appURL withOptions:options];
    if (ok)
        os_log_info(log, "Installation succeeded!");
    else
        os_log_error(log, "Installation failed.");

    return 0;
}

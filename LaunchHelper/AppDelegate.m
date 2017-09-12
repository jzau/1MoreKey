//
//  AppDelegate.m
//  LaunchHelper
//
//  Created by Jie Zhang on 7/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    BOOL alreadyRunning = NO;
    NSArray *running = [[NSWorkspace sharedWorkspace] runningApplications];
    for (NSRunningApplication *app in running) {
        if ([[app bundleIdentifier] isEqualToString:@"com.nsswift.1morekey"]) {
            alreadyRunning = YES;
        }
    }

    if (!alreadyRunning) {
        NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
        pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
        NSString *path = [NSString pathWithComponents:pathComponents];
        NSString *binaryPath = [[NSBundle bundleWithPath:path] executablePath];
        [[NSWorkspace sharedWorkspace] launchApplication:binaryPath];
    }
    [NSApp terminate:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end

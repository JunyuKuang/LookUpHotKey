//
//  AppDelegate.m
//  BluetoothConnectorLoginHelper
//
//  Created by Jonny Kuang on 4/24/19.
//  Copyright © 2019 Jonny Kuang. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSURL *URL = NSBundle.mainBundle.bundleURL;
    for (NSInteger i = 0; i < 4; i++) {
        URL = URL.URLByDeletingLastPathComponent;
    }
    if (@available(macOS 10.15, *)) {
        [NSWorkspace.sharedWorkspace openApplicationAtURL:URL
                                            configuration:[NSWorkspaceOpenConfiguration configuration]
                                        completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [NSApp terminate:nil];
            }];
        }];
    } else {
        [NSWorkspace.sharedWorkspace launchApplicationAtURL:URL options:0 configuration:@{} error:nil];
        [NSApp terminate:nil];
    }
}

@end

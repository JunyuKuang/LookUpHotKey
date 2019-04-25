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
    [NSWorkspace.sharedWorkspace launchApplicationAtURL:URL options:0 configuration:@{} error:nil];
    [NSApp terminate:self];
}

@end

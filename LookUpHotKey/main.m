//
//  main.m
//  LookUpHotKey
//
//  Created by Jonny Kuang on 4/25/19.
//  Copyright © 2019 Jonny Kuang. All rights reserved.
//

@import AppKit;
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    NSApplication *app = NSApplication.sharedApplication;
    AppDelegate *delegate = [[AppDelegate alloc] init];
    
    app.delegate = delegate;
    [app run];
}

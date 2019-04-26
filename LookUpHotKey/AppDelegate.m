//
//  AppDelegate.m
//  LookUpHotKey
//
//  Created by Jonny Kuang on 4/25/19.
//  Copyright © 2019 Jonny Kuang. All rights reserved.
//

#import "AppDelegate.h"
@import Carbon;
@import ServiceManagement;


static OSStatus HotKeyEventCallback(EventHandlerCallRef _, EventRef event, void *context)
{
    CGEventTapLocation tapLocation = kCGHIDEventTap;
    
    CGEventSourceRef eventSource = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    
    CGEventRef keyDownEvent = CGEventCreateKeyboardEvent(eventSource, kVK_ANSI_D, YES);
    CGEventRef keyUpEvent = CGEventCreateKeyboardEvent(eventSource, kVK_ANSI_D, NO);
    
    CGEventFlags flags = kCGEventFlagMaskControl | kCGEventFlagMaskCommand;
    CGEventSetFlags(keyDownEvent, flags);
    CGEventSetFlags(keyUpEvent, flags);
    
    CGEventPost(tapLocation, keyDownEvent);
    CGEventPost(tapLocation, keyUpEvent);
    
    return noErr;
}


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    [self configureHotKeys];
    [self configureLaunchAtLogin];
}

- (void)configureHotKeys
{
    EventTargetRef target = GetApplicationEventTarget();
    EventTypeSpec spec = {
        .eventClass = kEventClassKeyboard,
        .eventKind = kEventHotKeyPressed
    };
    InstallEventHandler(target, HotKeyEventCallback, 1, &spec, nil, nil);
    
    EventHotKeyRef hotKeyRef;
    
    EventHotKeyID hotKeyID = {
        .signature = 'JONY',
        .id = 1
    };
    RegisterEventHotKey(kVK_ANSI_A, optionKey, hotKeyID, target, 0, &hotKeyRef);
    
    hotKeyID.id = 2;
    RegisterEventHotKey(kVK_ANSI_S, optionKey, hotKeyID, target, 0, &hotKeyRef);
    
    hotKeyID.id = 3;
    RegisterEventHotKey(kVK_ANSI_D, optionKey, hotKeyID, target, 0, &hotKeyRef);
}

- (void)configureLaunchAtLogin
{
    SMLoginItemSetEnabled((__bridge CFStringRef)@"com.jonny.LookUpHotKeyLoginHelper", YES);
}

@end

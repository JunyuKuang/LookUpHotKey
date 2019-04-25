//
//  AppDelegate.m
//  LookUpHotKey
//
//  Created by Jonny Kuang on 4/25/19.
//  Copyright © 2019 Jonny Kuang. All rights reserved.
//

#import "AppDelegate.h"
@import Carbon;


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
    EventTargetRef target = GetApplicationEventTarget();
    EventTypeSpec spec = {
        .eventClass = kEventClassKeyboard,
        .eventKind = kEventHotKeyPressed
    };
    InstallEventHandler(target, HotKeyEventCallback, 1, &spec, nil, nil);
    
    EventHotKeyID hotKeyID = {
        .signature = 'JONY',
        .id = 1
    };
    EventHotKeyRef hotKeyRef;
    RegisterEventHotKey(kVK_ANSI_D, optionKey, hotKeyID, target, 0, &hotKeyRef);
}

@end

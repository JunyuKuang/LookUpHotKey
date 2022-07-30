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

static void performDoubleClick()
{
    CGFloat screenHeight = NSScreen.mainScreen.frame.size.height;
    CGPoint mouseLocation = NSEvent.mouseLocation;
    CGPoint convertedMouseLocation = CGPointMake(mouseLocation.x, screenHeight - mouseLocation.y);
    
    CGEventRef event = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, convertedMouseLocation, kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, event);
    CGEventSetType(event, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, event);
    
    CGEventSetIntegerValueField(event, kCGMouseEventClickState, 2);
    
    CGEventSetType(event, kCGEventLeftMouseDown);
    CGEventPost(kCGHIDEventTap, event);
    
    CGEventSetType(event, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, event);
    
    CFRelease(event);
}

static void performLookupKeyboardShortcut()
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
    
    CFRelease(keyDownEvent);
    CFRelease(keyUpEvent);
    CFRelease(eventSource);
}

static void performLookup()
{
    if (@available(macOS 11.3, *)) {
        // workaround the WebKit lookup failure introduced in macOS 11.3
        if (@available(macOS 12.5, *)) {
            // seems no longer an issue on macOS 12.5 with Safari 15.6
        } else {
            performDoubleClick();
        }
    }
    performLookupKeyboardShortcut();
}

static OSStatus HotKeyEventCallback(EventHandlerCallRef _, EventRef event, void *context)
{
    performLookup();
    return noErr;
}


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if (@available(macOS 10.15, *)) {
        CGRequestPostEventAccess();
    }
    [self configureHotKeys];
    [self configureLaunchAtLogin];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    performLookup();
    return NO;
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

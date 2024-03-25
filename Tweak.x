#import <Foundation/Foundation.h>

%group Hooks

%hook BatteryUIController

- (int)BUI_MODE {
    return 2;
}

- (void)setBUI_MODE:(int)arg1 {
    %orig(2);
}

- (BOOL)showRootNodesInInternal {
    return TRUE;
}

- (BOOL)showSaveDemoButtonInInternal {
    return TRUE;
}

- (BOOL)shouldDisplayBugSignatures {
    return TRUE;
}

- (BOOL)isSquished {
    return FALSE;
}

- (int)batteryUIType {
    return 2;
}

- (void)setBatteryUIType:(int)arg1 {
    %orig(2);
}

- (int)batteryUIQueryType {
    return 4;
}

- (void)setBatteryUIQueryType:(int)arg1 {
    %orig(4);
}

%end

%end

// Credit: https://github.com/PoomSmart/Battery-Health-Enabler
char *bundleLoadedObserver = "BM";
void BatteryUsageUIBundleLoadedNotificationFired(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if(objc_getClass("BatteryUIController") == nil)
        return;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        %init(Hooks);
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetLocalCenter(), bundleLoadedObserver, (__bridge CFStringRef)NSBundleDidLoadNotification, NULL);
    });
}

%ctor {
    @autoreleasepool {
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetLocalCenter(),
            bundleLoadedObserver,
            BatteryUsageUIBundleLoadedNotificationFired,
            (__bridge CFStringRef)NSBundleDidLoadNotification,
            (__bridge CFBundleRef)[NSBundle bundleWithPath:@"/System/Library/PreferenceBundles/BatteryUsageUI.bundle"],
            CFNotificationSuspensionBehaviorCoalesce);
    }
}

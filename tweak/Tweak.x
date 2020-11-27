#include <CoreFoundation/CoreFoundation.h>
#include <LightMessaging/LightMessaging.h>
#include <UIKit/UIKit.h>

// handle callback
void clip_callback(CFMachPortRef port, LMMessage *message, CFIndex size, void *info) {
	// Check validity of message
	if (!LMDataWithSizeIsValidMessage(message, size)) {
		LMResponseBufferFree((LMResponseBuffer *)message);
		return;
	}

	// Get the data you received
	void *data = LMMessageGetData(message);
	size_t length = LMMessageGetDataLength(message);
	// Make it into a CFDataRef object
	NSData *msgdata = [NSData dataWithBytes:data length:length];
	NSString *clip = [[NSString alloc] initWithData:msgdata encoding:NSUTF8StringEncoding];

	if (clip)
		[[UIPasteboard generalPasteboard] setString:clip];

	// Free the response buffer
	LMResponseBufferFree((LMResponseBuffer *)message);
}


LMConnection connection = {
	MACH_PORT_NULL,
	"com.1conan.cumsync.daemon"
};
NSInteger changeCount = 0;

void sendClip(CFRunLoopTimerRef timer, void *info) {
	if (changeCount == [UIPasteboard generalPasteboard].changeCount) return;

	changeCount = [UIPasteboard generalPasteboard].changeCount;
	NSString *message = [UIPasteboard generalPasteboard].string;
	if ([message length] == 0) return;
	NSData *data = [(NSString *)message dataUsingEncoding:NSUTF8StringEncoding];
	LMConnectionSendOneWayData(&connection, 0x69, (__bridge CFDataRef)data);
}

%ctor {
	LMStartService("com.1conan.cumsync.springboard", CFRunLoopGetCurrent(), (CFMachPortCallBack)clip_callback);

	CFRunLoopTimerContext ctx = { 0, NULL, NULL, NULL, NULL };
	CFRunLoopTimerRef timer = CFRunLoopTimerCreate(
		kCFAllocatorDefault,
		CFAbsoluteTimeGetCurrent() + 0.2,
		0.2,
		0, 0,
		sendClip,
		&ctx
	);
	CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
}
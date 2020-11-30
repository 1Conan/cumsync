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

%ctor {
	LMStartService("com.1conan.cumsync.springboard", CFRunLoopGetCurrent(), (CFMachPortCallBack)clip_callback);
}
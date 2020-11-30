#include <LightMessaging/LightMessaging.h>
#include <UIKit/UIKit.h>

LMConnection connection = {
	MACH_PORT_NULL,
	"com.1conan.cumsync.daemon"
};

void sendClip() {
	NSString *message = [UIPasteboard generalPasteboard].string;
	if ([message length] == 0) return;
	NSData *data = [(NSString *)message dataUsingEncoding:NSUTF8StringEncoding];
	LMConnectionSendOneWayData(&connection, 0x69, (__bridge CFDataRef)data);
}

%ctor {
	[[NSNotificationCenter defaultCenter] addObserverForName:UIPasteboardChangedNotification
																										object:nil
																										 queue:[NSOperationQueue currentQueue]
																								usingBlock:^(NSNotification *note){
		sendClip();
	}];
}
#include <stdio.h>
#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>
#include <LightMessaging/LightMessaging.h>
#import "PocketSocket/PSWebSocketServer.h"

LMConnection connection = {
	MACH_PORT_NULL,
	"com.1conan.cumsync.springboard"
};

NSString *current;


@interface CumSyncDelegate : NSObject <PSWebSocketServerDelegate>
@property (nonatomic, strong) PSWebSocketServer *server;
@property (nonatomic, strong) NSMutableArray *sockets;
@end

@implementation CumSyncDelegate
- (void)start {
	_server = [PSWebSocketServer serverWithHost:@"127.0.0.1" port:6969];
	_server.delegate = self;
	[_server start];
	_sockets = [[NSMutableArray alloc] init];
}

- (void)broadcastClip:(NSString *)clip {
	[self cleanSockets];
	for (PSWebSocket *ws in _sockets) {
		[ws send:clip];
	}
}

- (void)cleanSockets {
	NSArray *arr = [NSArray arrayWithArray:_sockets];
	[_sockets removeObjectsAtIndexes:[arr indexesOfObjectsPassingTest:^BOOL(PSWebSocket * ws, NSUInteger idx, BOOL *stop) {
		return ws.readyState != PSWebSocketReadyStateOpen;
	}]];
}

#pragma mark - PSWebSocketServerDelegate

- (void)serverDidStart:(PSWebSocketServer *)server {
    NSLog(@"Server did start…");
}
- (void)serverDidStop:(PSWebSocketServer *)server {
    NSLog(@"Server did stop…");
}
- (BOOL)server:(PSWebSocketServer *)server acceptWebSocketWithRequest:(NSURLRequest *)request {
    NSLog(@"Server should accept request: %@", request);
    return YES;
}
- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Server websocket did receive message: %@", message);
		if ((NSString *)message == current) return;
		current = (NSString *)message;
		NSData *data = [(NSString *)message dataUsingEncoding:NSUTF8StringEncoding];
		LMConnectionSendOneWayData(&connection, 0x69, (__bridge CFDataRef)data);
}
- (void)server:(PSWebSocketServer *)server webSocketDidOpen:(PSWebSocket *)webSocket {
    NSLog(@"Server websocket did open");
		[_sockets addObject:webSocket];
}
- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Server websocket did close with code: %@, reason: %@, wasClean: %@", @(code), reason, @(wasClean));
}
- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Server websocket did fail with error: %@", error);
}
- (void)server:(PSWebSocketServer *)server didFailWithError:(NSError *)error {
    NSLog(@"Server websocket did fail with error: %@", error);
}
@end

CumSyncDelegate *shit;

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

	if (clip) {
		if (current == clip) return;
		[shit broadcastClip:clip];
		current = clip;
	}

	// Free the response buffer
	LMResponseBufferFree((LMResponseBuffer *)message);
}

int main(int argc, char *argv[], char *envp[]) {
	@autoreleasepool {
		printf("Cum Sync\n");
		shit = [[CumSyncDelegate alloc] init];
		[shit start];
		LMStartService("com.1conan.cumsync.daemon", CFRunLoopGetCurrent(), (CFMachPortCallBack)clip_callback);

		CFRunLoopRun();
		return 0;
	}
}

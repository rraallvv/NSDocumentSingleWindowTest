//
//  LMAppDelegate.m
//  NSDocumentSingleWindowTest
//
//  Created by Rhody Lugo on 2/13/15.
//  Copyright (c) 2015 Felix Deimel. All rights reserved.
//

#import "LMAppDelegate.h"

#define OPEN_UNTITLED	1

@interface LMAppDelegate ()

@end

@implementation LMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application

#if OPEN_UNTITLED

	// Schedule "Checking whether document exists." into next UI Loop.
	// Because document is not restored yet.
	// So we don't know what do we have to create new one.
	// Opened document can be identified here. (double click document file)
	NSInvocationOperation* op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(openNewDocumentIfNeeded) object:nil];
	[[NSOperationQueue mainQueue] addOperation: op];

#endif

}

#if OPEN_UNTITLED

- (void)openNewDocumentIfNeeded
{
	NSUInteger documentCount = [[[NSDocumentController sharedDocumentController] documents]count];

	// Open an untitled document what if there is no document. (restored, opened).
	if(documentCount == 0){
		[[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error: nil];
	}
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
	return YES;
}

#endif

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return NO;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

@end

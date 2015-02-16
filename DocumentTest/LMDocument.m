//
//  LMDocument.m
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMDocument.h"
#import "LMWindowController.h"

@implementation LMDocument

- (instancetype)init {
	self = [super init];
	if (self) {
		self.textView = [[NSTextView alloc] init];
	}
	return self;
}

-(void)makeWindowControllers {
	[self addWindowController:LMWindowController.instance];
}

+ (BOOL)autosavesInPlace {
	return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
	// Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
	// You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

	return [self.textView.string dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
	// Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
	// You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
	// If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.

	self.textView.string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	return YES;
}

- (void)close {
	[self removeWindowController:LMWindowController.instance];
	[super close];
}

- (void)textDidChange:(NSNotification *)notification {
	NSTextView *textView = notification.object;
	self.textView.string = textView.string;
}

@end

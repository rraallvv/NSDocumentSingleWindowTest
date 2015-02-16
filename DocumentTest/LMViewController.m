//
//  LMViewController.m
//  NSDocumentSingleWindowTest
//
//  Created by Rhody Lugo on 2/16/15.
//  Copyright (c) 2015 Felix Deimel. All rights reserved.
//

#import "LMViewController.h"
#import "LMDocument.h"

@interface LMViewController ()

@end

@implementation LMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)setRepresentedObject:(id)representedObject {

	if (self.representedObject)
		[self.representedObject close];

	LMDocument *doc = representedObject;

	if (doc.dataInMemory)
		self.textView.string = [doc.dataInMemory copy];
	else
		self.textView.string = @"";

	super.representedObject = representedObject;
}

- (void)textDidChange:(NSNotification *)notification {

	NSTextView *textView = [notification object];

	LMDocument *doc = nil;

	if (textView == self.textView)
		doc = self.representedObject;

	if (doc) {
		doc.dataInMemory = [textView string];

		BOOL hasChanges = [doc hasChanges];

		if (hasChanges) {
			[doc updateChangeCount:NSChangeDone];
		} else {
			[doc updateChangeCount:NSChangeCleared];
		}
	}
}

@end

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

	LMDocument *doc = representedObject;

	if (doc.dataInMemory)
		self.textView.string = [doc.dataInMemory copy];
	else
		self.textView.string = @"";

	super.representedObject = representedObject;
}

- (void)textDidChange:(NSNotification *)notification {

	LMDocument *doc = self.representedObject;

	if (doc) {
		doc.dataInMemory = self.textView.string;

		if (doc.hasChanges) {
			[doc updateChangeCount:NSChangeDone];
		} else {
			[doc updateChangeCount:NSChangeCleared];
		}
	}
}

@end

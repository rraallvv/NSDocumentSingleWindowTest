//
//  LMViewController.m
//  NSDocumentSingleWindowTest
//
//  Created by Rhody Lugo on 2/16/15.
//  Copyright (c) 2015 Felix Deimel. All rights reserved.
//

#import "LMViewController.h"
#import "LMDocument.h"

@implementation LMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)setRepresentedObject:(LMDocument *)representedObject {

	if (representedObject)
		self.textView.string = [representedObject.textView.string copy];
	else
		self.textView.string = @"";

	super.representedObject = representedObject;
}

- (void)textDidChange:(NSNotification *)notification {

	LMDocument *doc = self.representedObject;

	if (doc) {
		doc.textView.string = self.textView.string;
	}
}

@end

//
//  LMWindowController.m
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMWindowController.h"
#import "LMViewController.h"
#import "LMDocument.h"

static LMWindowController *aInstance = nil;

@interface LMWindowController ()

@property (weak) IBOutlet LMViewController *viewController;

@end

@implementation LMWindowController

+(LMWindowController *)instance {
	if (!aInstance) {
		aInstance = [[LMWindowController alloc] initWithWindowNibName:@"Window"];
	}
    return aInstance;
}

- (void)windowDidLoad {
	[super windowDidLoad];

	self.contentViewController = _viewController;

	LMDocument *doc = self.document;

	if (doc) {
		_viewController.representedObject = doc;
		_viewController.textView.string = doc.textView.string;
	}
}

- (void)setDocument:(id)document {
	[super setDocument:document];
	if (document != nil && self.contentViewController != nil) {
		if (_viewController.representedObject)
			[_viewController.representedObject close];
		_viewController.representedObject = document;
	}
}

- (void)close {

}

@end

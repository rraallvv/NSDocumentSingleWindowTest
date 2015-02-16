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
		[_viewController.textView setString:doc.dataInMemory];
	}
}

-(void)setDocument:(LMDocument*)docToAdd {

	if (self.document)
		[self.document close];

	_viewController.representedObject = docToAdd;

	if (docToAdd.dataInMemory)
		[_viewController.textView setString:docToAdd.dataInMemory];

	[super setDocument:docToAdd];
}

- (void)close {

}

@end

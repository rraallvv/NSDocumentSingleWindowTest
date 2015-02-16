//
//  LMWindowController.m
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMWindowController.h"
#import "LMDocument.h"

static id aInstance;

@interface LMWindowController ()
@end

@implementation LMWindowController {

    BOOL _closeCalledInternally;
}

-(void)awakeFromNib {

    aInstance = self;

    _closeCalledInternally = NO;
}

+(id)instance {

    return aInstance;
}

-(void)addDocument:(LMDocument*)docToAdd {

	if (self.document) {
		[self.document close];
		self.document = nil;
	}

    // !!!  It's very important to do this before adding the document to the NSArray because Cocoa calls document on NSWindowController to see if there has been a document assigned to this window controller already. if so, it doesn't add the window controller to the NSDocument  !!!
    [docToAdd addWindowController:self];
    
	self.document = docToAdd;

    [self.textViewDocument setString:docToAdd.dataInMemory];
}

-(void)windowWillClose:(NSNotification*) notification {

    NSWindow * window = self.window;
    if (notification.object != window) {
        return;
    }
    
    // TODO: Clean up any views related to documents
    
    // disassociate this window controller from the document
    if (self.document)
        [self.document removeWindowController:self];

    // then any content view
    [window setContentView:nil];
}


- (void)textDidChange:(NSNotification *)notification {

    NSTextView *textView = [notification object];
    
    LMDocument *doc = nil;
    
    if (textView == self.textViewDocument) {
        doc = self.document;
    }

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

- (void)close {

	if (_closeCalledInternally) {
		_closeCalledInternally = NO;
		[super close];
	}
}

@end

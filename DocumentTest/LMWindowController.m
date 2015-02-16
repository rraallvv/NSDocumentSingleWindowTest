//
//  LMWindowController.m
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMWindowController.h"
#import "LMDocument.h"

static LMWindowController *aInstance = nil;

@interface LMWindowController ()
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
	LMDocument *doc = self.document;
	if (doc) {
		[self.textViewDocument setString:doc.dataInMemory];
	}
}

-(void)setDocument:(LMDocument*)docToAdd {

	if (self.document)
		[self.document close];

	if (docToAdd.dataInMemory)
		[self.textViewDocument setString:docToAdd.dataInMemory];

	[super setDocument:docToAdd];
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

}

@end

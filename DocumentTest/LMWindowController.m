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
    LMDocument *_doc;
    BOOL _closeCalledInternally;
}

-(void)awakeFromNib
{
    aInstance = self;
    
	[self setDocument: self.document];

    _closeCalledInternally = NO;
}

+(id)instance
{
    return aInstance;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)dealloc
{
    if (_doc) {
        [_doc release];
        _doc = nil;
    }

    [super dealloc];
}

- (IBAction)closeDocument:(id)sender
{
    [self removeDocument:[self document]];
}

-(void)documentNeedsWindow:(NSNotification*)aNotification
{
    LMDocument* doc = [aNotification object];
    
    [self addDocument:doc];
}

/* -(void)setDocument:(NSDocument*)document
{
    // nothing to do here
} */

-(NSDocument*)document
{
    // TODO: Return current active document
    NSDocument *doc = nil;
    
    NSTextView *tv = [self activeTextView];
    
    if (tv == self.textViewDocument) {
        doc = _doc;
    }
    
    return doc;
}

-(NSTextView*)activeTextView
{
    NSResponder *firstResponder = [[self.textViewDocument window] firstResponder];

    if ([firstResponder isKindOfClass:[NSTextView class]]) {
		
		if ([(NSTextView *)firstResponder delegate] == [self.textViewDocument delegate]) {
			return self.textViewDocument;
        }
    }
    
    return nil;
}

-(void)addDocument:(LMDocument*)docToAdd
{
    NSTextView *tv = [self activeTextView];
    
    LMDocument *closeDoc = nil;
    
    if (!tv) {
        closeDoc = _doc;
        tv = self.textViewDocument;
    } else {
        closeDoc = [self document];
    }
    
    if (closeDoc) {
        [self closeDocument:closeDoc];
    }
    
    // !!!  It's very important to do this before adding the document to the NSArray because Cocoa calls document on NSWindowController to see if there has been a document assigned to this window controller already. if so, it doesn't add the window controller to the NSDocument  !!!
    [docToAdd addWindowController:self];
    
    if (tv == self.textViewDocument) {
        _doc = [docToAdd retain];
    }

    [tv setString:docToAdd.dataInMemory];
	[self setDocument: self.document];

    //[lmDoc setWindow:self.window];
    //[lmDoc setDisplayName:@"MY DOC DISPLAY NAME"];
    
    //[self setDocument:docToAdd];
}

-(void)removeDocument:(LMDocument*)docToRemove
{
    // ... remove the document's view controller and view ...
    
    // finally detach the document from the window controller
    // TODO: Remove any views related to the doc
    
    if (!docToRemove) {
        _closeCalledInternally = YES;
        [self close];
    }
    
    NSTextView *tv = nil;
    
    if (_doc == docToRemove) {
        tv = self.textViewDocument;
        
        if (_doc) {
            [_doc release];
            _doc = nil;
        }
    }
    
    [tv setString:@""];
    
	[self setDocument: self.document];

    //[docToRemove close];
}

-(void)windowWillClose:(NSNotification*) notification
{
    NSWindow * window = self.window;
    if (notification.object != window) {
        return;
    }
    
    // TODO: Clean up any views related to documents
    
    // disassociate this window controller from the document
    if (_doc) {
        [_doc removeWindowController:self];
    }
    
    // then any content view
    [window setContentView:nil];
}


- (void)textDidChange:(NSNotification *)notification
{
    NSTextView *textView = [notification object];
    
    LMDocument *doc = nil;
    
    if (textView == self.textViewDocument) {
        doc = _doc;
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

- (void)textDidEndEditing:(NSNotification *)notification
{
	[self setDocument: self.document];
}

- (void)close
{
    if (_closeCalledInternally) {
        _closeCalledInternally = NO;
        [super close];
    }
}

@end

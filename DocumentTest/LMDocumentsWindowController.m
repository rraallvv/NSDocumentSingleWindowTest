//
//  LMDocumentsWindowController.m
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMDocumentsWindowController.h"
#import "LMDocument.h"

static id aInstance;

@interface LMDocumentsWindowController ()
@end

@implementation LMDocumentsWindowController {
    LMDocument *m_doc;
    BOOL m_closeCalledInternally;
}

-(void)awakeFromNib
{
    aInstance = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentNeedsWindow:) name:LMDocumentNeedWindowNotification object:nil];
    [self setActiveDocument];
    
    m_closeCalledInternally = NO;
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
    if (m_doc) {
        [m_doc release];
        m_doc = nil;
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
        doc = m_doc;
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

-(void)setActiveDocument
{
    [self performSelector:@selector(setActiveDocumentReal) withObject:nil afterDelay:0];
}

-(void)setActiveDocumentReal
{
    LMDocument* doc = [self document];
    
    if (doc) {
        [self setDocument:doc];
    } else {
        [self setDocument:nil];
        [self.window setTitle:@"NO DOCUMENT"];
    }
}

-(void)addDocument:(LMDocument*)docToAdd
{
    NSTextView *tv = [self activeTextView];
    
    LMDocument *closeDoc = nil;
    
    if (!tv) {
        closeDoc = m_doc;
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
        m_doc = [docToAdd retain];
    }

    [tv setString:docToAdd.dataInMemory];
    [self setActiveDocument];

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
        m_closeCalledInternally = YES;
        [self close];
    }
    
    NSTextView *tv = nil;
    
    if (m_doc == docToRemove) {
        tv = self.textViewDocument;
        
        if (m_doc) {
            [m_doc release];
            m_doc = nil;
        }
    }
    
    [tv setString:@""];
    
    [self setActiveDocument];
    
    [docToRemove close];
}

-(void)windowWillClose:(NSNotification*) notification
{
    NSWindow * window = self.window;
    if (notification.object != window) {
        return;
    }
    
    // TODO: Clean up any views related to documents
    
    // disassociate this window controller from the document
    if (m_doc) {
        [m_doc removeWindowController:self];
    }
    
    // then any content view
    [window setContentView:nil];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    NSTextView *textField = [notification object];
    
    LMDocument *doc = nil;
    
    if (textField == self.textViewDocument) {
        doc = m_doc;
    }

    if (doc) {
        doc.dataInMemory = [textField string];
        
        BOOL hasChanges = [doc hasChanges];
        
        if (hasChanges) {
            [doc updateChangeCount:NSChangeDone];
        } else {
            [doc updateChangeCount:NSChangeCleared];
        }
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
    [self setActiveDocument];
}

- (void)close
{
    if (m_closeCalledInternally) {
        m_closeCalledInternally = NO;
        [super close];
    }
}

@end

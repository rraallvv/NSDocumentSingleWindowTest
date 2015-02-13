//
//  LMDocumentsWindowController.h
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMDocumentsWindowController : NSWindowController<NSTextViewDelegate>

+(id)instance;
- (IBAction)closeDocument:(id)sender;

@property (assign) IBOutlet NSTextView *textViewDocument;

@end

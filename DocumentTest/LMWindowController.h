//
//  LMWindowController.h
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LMDocument.h"

@interface LMWindowController : NSWindowController<NSTextViewDelegate>

+(LMWindowController *)instance;

@property (assign) IBOutlet NSTextView *textViewDocument;

@end

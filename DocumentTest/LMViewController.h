//
//  LMViewController.h
//  NSDocumentSingleWindowTest
//
//  Created by Rhody Lugo on 2/16/15.
//  Copyright (c) 2015 Felix Deimel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMViewController : NSViewController <NSTextViewDelegate>

@property (assign) IBOutlet NSTextView *textView;

@end

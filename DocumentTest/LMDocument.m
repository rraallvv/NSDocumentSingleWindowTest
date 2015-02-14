//
//  LMDocument.m
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMDocument.h"
#import "LMDocumentsWindowController.h"

@implementation LMDocument {
    NSString* _dataInMemory;
    NSString* _dataFromLoad;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.dataInMemory = @"";
        _dataFromLoad = [self.dataInMemory copy];
    }
    return self;
}

- (void)dealloc
{
    if (_dataInMemory) {
        [_dataInMemory release];
        _dataInMemory = nil;
    }
    
    if (_dataFromLoad) {
        [_dataFromLoad release];
        _dataFromLoad = nil;
    }
    
    [super dealloc];
}

-(void)setDataInMemory:(NSString *)aDataInMemory
{
    _dataInMemory = [aDataInMemory retain];
}

-(NSString*)dataInMemory
{
    return _dataInMemory;
}

-(void)makeWindowControllers
{
	LMDocumentsWindowController *wc = [LMDocumentsWindowController instance];

	[wc addDocument:self];

    //[[NSNotificationCenter defaultCenter] postNotificationName:LMDocumentNeedWindowNotification object:self];
    
    /* LMDocumentsWindowController *wc = [[LMDocumentsWindowController alloc] initWithWindowNibName:@"LMMultipleDocumentsWindow"];

    //[wc addDocument:self];

    [self addWindowController:wc];

    [wc showWindow:self]; */
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

+ (BOOL)preservesVersions
{
    return YES;
}

/* - (NSString*)displayName
{
    return @"Royal TSX - Filename";
} */

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    
    if (_dataFromLoad) {
        [_dataFromLoad release];
        _dataFromLoad = nil;
    }
    
    _dataFromLoad = [_dataInMemory copy];
    
    return [[self dataInMemory] dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    
    [self setDataInMemory:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]];
    _dataFromLoad = [_dataInMemory copy];
    
    return YES;
}

- (BOOL)hasChanges
{
    return ![_dataInMemory isEqualToString:_dataFromLoad];
}

- (void)close
{
    [super close];
}

@end

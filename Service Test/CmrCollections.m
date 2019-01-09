//
//  CmrCollections.m
//  Service Test
//
//  Created by Thomas Cherry on 2019-01-07.
//  Copyright © 2019 Thomas Cherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "CmrCollections.h"
#import "Service_Test-Swift.h"

@implementation CmrCollections

- (void)convertCollectionId:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    [[ServiceCmr new] convertCollectionId:pboard userData:userData error:error];
}
    
- (NSString*) rotateLettersInString:(NSString*) pboardString
{
    return [pboardString uppercaseString];
}

@end

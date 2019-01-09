//
//  CmrCollections.h
//  Service Test
//
//  Created by Thomas Cherry on 2019-01-07.
//  Copyright © 2019 Thomas Cherry. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef CmrCollections_h
#define CmrCollections_h

#import <AppKit/AppKit.h>

@class ServiceCmr;

@interface CmrCollections : NSObject

- (NSString*) rotateLettersInString:(NSString*) pboardString;
- (void)convertCollectionId:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;

@end

#endif /* CmrCollections_h */

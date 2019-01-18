//
//  ServiceHandler.h
//  Service Test
//
//  Created by Thomas Cherry on 2019-01-07.
//  Copyright © 2019 Thomas Cherry. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef ServiceHandler_h
#define ServiceHandler_h

#import <AppKit/AppKit.h>

@class ActionHandler;

@interface ServiceHandler : NSObject

- (void)lowercase:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;
- (void)uppercase:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;

- (void)replacement:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error;
- (void)rpn:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;
- (void)markdown:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;
- (void)execute:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error;

- (void)cpush:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;
- (void)cput:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;

- (void)nop:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;

@end

#endif /* ServiceHandler_h */

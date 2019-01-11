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

- (void)prefix1:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    //[[ServiceCmr new] convertCollectionId:pboard userData:userData error:error];
    [self handle:@"prefix1" from:pboard userData:userData error:error];

}
- (void)prefix2:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    [self handle:@"prefix2" from:pboard userData:userData error:error];
}

- (void)nop:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    printf ("no operation\n");
}
    
- (void)rpn:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    [self handle:@"rpn" from:pboard userData:userData error:error];
}

- (void)markdown:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    [self handle:@"markdown" from:pboard userData:userData error:error];
}

- (void)cpush:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    printf ("no operation yes\n");
}

- (void)cput:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    [self handle:@"cput" from:pboard userData:userData error:error];
}

/** handle a generic pastboard action */
- (void)handle:(NSString*)task from:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    if (pboard==nil || userData==nil){return;}
    
    NSArray* classArray = [NSArray arrayWithObject:[NSString class]];
    NSDictionary* options = [NSDictionary dictionary];

    if ([pboard canReadObjectForClasses:classArray options:options])
    {
        NSArray* objectsToRead = [pboard readObjectsForClasses:classArray options:options];
        NSString* text = [objectsToRead objectAtIndex:0];
        NSString* ret = [self action_switch:task value:text error:error];
        if (*error==nil)
        {
            [pboard clearContents];
            //ret = [NSString stringWithFormat:@"%@ = %@", text, ret];
            [pboard writeObjects: [NSArray arrayWithObject:ret]];
        }
    }
}

- (NSString*) action_switch:(NSString*)action value:(NSString*)value error:(NSString**)error
{
    NSString* ret = @"";
    ServiceCmr* service = [ServiceCmr new];
    if ([action isEqual:@"rpn"])
    {
        ret = [service routerWithAction:action source:value];
        ret = [NSString stringWithFormat:@"%@ = %@", value, ret];
    }
    else if ([action isEqual:@"prefix1"])
    {
        ret = [service routerWithAction:@"prefix" source:value];
    }
    else if ([action isEqual:@"prefix2"])
    {
        ret = [service routerWithAction:@"prefix2" source:value];
    }
    else if ([action isEqual:@"markdown"])
    {
        ret = [service routerWithAction:@"markdown" source:value];
    }
    else
    {
        *error = @"No action defined";
    }
    return ret;
}

@end

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

/* ************************************************************************** */
// MARK: - public service methods

- (void)prefix1:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
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
    [self handle:@"cpush" from:pboard userData:userData error:error];
}

- (void)cput:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    [self handle:@"cput" from:pboard userData:userData error:error];
}

- (void)lowercase:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    [self handle:@"lowercase" from:pboard userData:userData error:error];
}

- (void)uppercase:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    [self handle:@"uppercase" from:pboard userData:userData error:error];
}

/* ****************************************************************** */
// MARK: - helpers

/**
 Handle a generic pastboard action abstracting away as much as posible the task
 of interfaces with the operating system and then hand off processing to specific
 handlers. The function signature is as close as poseble to the Services
 definition.
 
 * Returns:
 nothing
 
 * Parameters:
    * task: name of the task to execute
    * pboard: pasteboard to read and write from
    * userData: pasteboard user data
    * error: error messages
 
 * Version:
    0.1
 */
- (void)handle:(NSString*)task
        from:(NSPasteboard*)pboard
        userData:(NSString*)userData
        error:(NSString**)error
{
    if (pboard==nil || userData==nil){return;}
    
    //NSArray* classArray = [NSArray arrayWithObject:[NSString class]];
    NSArray* classArray = @[[NSString class]];
    //NSArray* classArray = @[[NSPasteboardItem class]];
    NSDictionary* options = [NSDictionary dictionary];

    NSLog(@"userData=%@ length %lu\n", userData, (unsigned long)userData.length);

    if ([pboard canReadObjectForClasses:classArray options:options])
    {
        //NSArray* objectsToRead = [pboard readObjectsForClasses:classArray options:options];
        NSString* text = [pboard stringForType:NSPasteboardTypeString];
        if (text!=nil)
        {
            text = [text stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            text = [text stringByTrimmingCharactersInSet:
                [NSCharacterSet controlCharacterSet]];
            if (text.length<1){return;}
NSLog(@"text=%@ length %lu\n", text, (unsigned long)text.length);
        }
        /*NSString* text = @"";
        for (id object in objectsToRead)
        {
        
NSLog(@"\nobject: %@=%@\n%@\n", [object className], object, [object types]);
            
            if ([[object types] containsObject: NSPasteboardTypeString])
            {//@"public.utf8-plain-text"
                NSPasteboardItem* item = object;
                text = [item stringForType:NSPasteboardTypeString];
NSLog(@"text from item is '%@'\n", text);
                break;
            }

        }*/
        
        //NSString* text = [objectsToRead objectAtIndex:0];
        NSDictionary* ret = [self action_switch:task value:text error:error];
        if (*error==nil)
        {
            [pboard clearContents];
            NSString* text = [ret objectForKey:@"text/plain"];
            if (text != nil && text.length>0)
            {
NSLog(@"sending text '%@' to pasteboard", text);
                [pboard setString:text forType:NSStringPboardType];
            }
            NSString* html = [ret objectForKey:@"text/html"];
            if (html != nil && html.length>0)
            {
NSLog(@"sending html '%@' to pasteboard", html);
                [pboard setString:html forType:NSPasteboardTypeHTML];
            }
        }
    }
}

/**
  This method will route a set number of actions to the correct handler, all of
  which will be handled outside of this object

  * Parameters:
    * action: action name.
    * value: pasteboard text selected.
    * error: error messages on failure.

  * Returns: NSDictionary containing data keyed at mime/types (text/plain, text/html)

*/
- (NSDictionary*) action_switch:(NSString*)action
        value:(NSString*)value error:(NSString**)error
{
    NSDictionary* dict = nil;
    ServiceCmr* service = [ServiceCmr new];
    NSArray* accaptable = @[@"rpn", @"markdown"
        , @"prefix1", @"prefix2"
        , @"uppercase", @"lowercase"
        , @"cput", @"cpush"];
    
    if ([accaptable doesContain:action])
    {
        dict = [service routerWithAction:action source:value];
    }
    else
    {
        *error = @"No action defined";
    }
    return dict;
}

/* ************************************************************************** */
// MARK: - non-coding dna

/*
- (void) placeHtmlOnPastboard: (NSPasteboard*)pasteboard
{
    NSLog(@"Place HTML on the pasteboard");
    NSString* htmlType = @"Apple Web Archive pasteboard type";

    // example html string
    NSString* htmlString = @"<p style=\"color:gray\"> <a href=@\"http://itunes.apple.com/gb/app/paragraft/id412998778?mt=8\">Paragraft</a><br><em>Less than a word processor, more than plain text</em>";

    NSMutableDictionary* resourceDictionary = [NSMutableDictionary dictionary];

    [resourceDictionary setObject:[htmlString dataUsingEncoding:NSUTF8StringEncoding]  forKey:@"WebResourceData"];

    [resourceDictionary setObject:@"" forKey:@"WebResourceFrameName"];
    [resourceDictionary setObject:@"text/html" forKey:@"WebResourceMIMEType"];
    [resourceDictionary setObject:@"UTF-8" forKey:@"WebResourceTextEncodingName"];
    [resourceDictionary setObject:@"about:blank" forKey:@"WebResourceURL"];

    NSDictionary* containerDictionary = [NSDictionary dictionaryWithObjectsAndKeys:resourceDictionary, @"WebMainResource", nil];

    NSDictionary* htmlItem = [NSDictionary dictionaryWithObjectsAndKeys:containerDictionary,htmlType,nil];

    //[pasteboard setItems: [NSArray arrayWithObjects: htmlItem, nil]];
    [pasteboard writeObjects:[NSArray arrayWithObject:htmlItem]];
    // This approach draws on the blog post and comments at:
    // http://mcmurrym.wordpress.com/2010/08/13/pasting-simplehtml-into-the-mail-app-ios/
}

//- (void) setAttributedString:(NSAttributedString *)attributedString {
    //NSString *htmlString = [attributedString htmlString]; // This uses DTCoreText category NSAttributedString+HTML - https://github.com/Cocoanetics/DTCoreText
- (NSDictionary*) setAttributedString:(NSString*) htmlString plainText:(NSString*)plainText
{
    NSDictionary* resourceDictionary = @{ @"WebResourceData" : [htmlString dataUsingEncoding:NSUTF8StringEncoding],
    @"WebResourceFrameName":  @"",
    @"WebResourceMIMEType" : @"text/html",
    @"WebResourceTextEncodingName" : @"UTF-8",
    @"WebResourceURL" : @"about:blank" };

    NSDictionary* htmlItem = @{ (NSString *)kUTTypeText : plainText,
        @"Apple Web Archive pasteboard type" : @{ @"WebMainResource" : resourceDictionary } };
    return htmlItem;
    //[self setItems:@[ htmlItem ]];

}*/

@end

//
//  GetAddrInfoService.h
//  TemplateProject
//
//  Created by Vladimir Vishnyagov on 26/05/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPv6Validator : NSObject

/**
 This method check
 API domain name
 supporting on IPv6
 
 @param domainString - domain of your API, like apple.com
 @param completionBlock - end of background operation
*/
+ (void)checkIPV6Support:(NSString *)domainString result:(void (^)(BOOL))completionBlock;

@end

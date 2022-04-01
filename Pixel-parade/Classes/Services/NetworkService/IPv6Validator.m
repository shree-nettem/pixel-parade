//
//  GetAddrInfoService.m
//  TemplateProject
//
//  Created by Vladimir Vishnyagov on 26/05/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

#import "IPv6Validator.h"
#import <netinet/in.h>
#import <netdb.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/ethernet.h>
#import <net/if_dl.h>

@implementation IPv6Validator

+ (void)checkIPV6Support:(NSString *)domainString result:(void (^)(BOOL))completionBlock {
    [IPv6Validator addressesForDomain:domainString result:^(NSArray *addresses) {
        for (NSString *addressString in addresses) {
            const char *utf8 = [addressString UTF8String];
            struct in6_addr dst6;
            int success = inet_pton(AF_INET6, utf8, &dst6);
            if (success == 1) {
                completionBlock(YES);
                return;
            }
        }
        completionBlock(NO);
    }];
}

+ (void)addressesForDomain:(NSString *)domain result:(void (^)(NSArray*))completionBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
    dispatch_async(queue, ^{
        const char* domainC = [domain UTF8String];
        
        struct addrinfo hints, *res;
        struct sockaddr_in6 *s6;
        int retval;
        char buf[64];
        NSMutableArray *result; //the array which will be return
        NSString *previousIP = nil;
        
        memset (&hints, 0, sizeof (struct addrinfo));
        hints.ai_family = PF_UNSPEC;
        hints.ai_flags = AI_CANONNAME;
        retval = getaddrinfo(domainC, NULL, &hints, &res);
        if (retval == 0) {
            if (res->ai_canonname) {
                result = [NSMutableArray arrayWithObject:[NSString stringWithUTF8String:res->ai_canonname]];
            } else {
                //it means the DNS didn't know this host
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completionBlock(@[]);
                });
            }
            while (res) {
                switch (res->ai_family){
                    case AF_INET6:
                        s6 = (struct sockaddr_in6 *)res->ai_addr;
                        if(inet_ntop(res->ai_family, (void *)&(s6->sin6_addr), buf, sizeof(buf))
                           == NULL) {
                            NSLog(@"inet_ntop failed for v6!\n");
                        } else {
                            if (![previousIP isEqualToString:[NSString stringWithUTF8String:buf]]) {
                                [result addObject:[NSString stringWithUTF8String:buf]];
                            }
                        }
                        break;
                    default: break; // it means res is IPv4 address
                }
                previousIP = [NSString stringWithUTF8String:buf];
                res = res->ai_next;
            }
        } else {
            NSLog(@"IPv6Validator failed, no IP addreses found on domain: %@", domain);
            dispatch_sync(dispatch_get_main_queue(), ^{
                completionBlock(@[]);
            });
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(result);
        });
    });
}

@end

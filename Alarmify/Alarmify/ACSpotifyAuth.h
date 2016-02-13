//
//  ACSpotifyAuth.h
//
//  Created by Aymeric Gallissot on 29/05/2015.
//  Copyright (c) 2015 Aymeric Gallissot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACSpotifyAuth : NSObject

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSURL *redirectURL;
@property (nonatomic, strong) NSURL *tokenSwapURL;
@property (nonatomic, strong) NSURL *tokenRefreshURL;

+ (instancetype)shared;

- (void)registerClass;
- (void)unregisterClass;

@end

@interface ACSpotifyAuthURLProtocol : NSURLProtocol

@end

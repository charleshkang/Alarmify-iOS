//
//  ACSpotifyAuth.m
//
//  Created by Aymeric Gallissot on 29/05/2015.
//  Copyright (c) 2015 Aymeric Gallissot. All rights reserved.
//

#import "ACSpotifyAuth.h"

#import <AFNetworking/AFNetworking.h>

static NSString * const ACSpotifyAuthURI = @"https://accounts.spotify.com";
static NSString * const ACSpotifyAuthTokenRoute = @"/api/token";

typedef void (^ACSpotifyAuthCallback)(NSError *error, NSDictionary *object);


@implementation ACSpotifyAuth

+ (instancetype)shared
{
    static id shared = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (void)registerClass
{
    [NSURLProtocol registerClass:[ACSpotifyAuthURLProtocol class]];
}

- (void)unregisterClass
{
    [NSURLProtocol unregisterClass:[ACSpotifyAuthURLProtocol class]];
}

@end


@interface ACSpotifyAuthURLProtocol ()

@property (nonatomic, strong) NSString *authorizationCode;
@property (nonatomic, strong) NSString *refreshToken;

@end

@implementation ACSpotifyAuthURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{    
    return ([request.URL.host isEqualToString:[ACSpotifyAuth shared].tokenSwapURL.host] || [request.URL.host isEqualToString:[ACSpotifyAuth shared].tokenRefreshURL.host]);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    id <NSURLProtocolClient> client = self.client;
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"application/json" expectedContentLength:-1 textEncodingName:nil];
    
    if ([self.request.URL.path isEqualToString:[ACSpotifyAuth shared].tokenSwapURL.path]) {
        
        if (self.request.HTTPBody) {
            NSString *string = [NSString stringWithUTF8String:(char*)[self.request.HTTPBody bytes]];

            if (string) {

                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"code=([a-zA-Z\\d-_]+)" options:NSRegularExpressionCaseInsensitive error:nil];
                NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];

                if (match) {
                    self.authorizationCode = [string substringWithRange:[match rangeAtIndex:1]];
                }

                [self swapToken:^(NSError *error, NSDictionary *object) {

                    if (error) {
                        [client URLProtocol:self didFailWithError:error];
                        return;
                    }

                    [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                    [client URLProtocol:self didLoadData:[NSJSONSerialization dataWithJSONObject:object options:0 error:nil]];
                    [client URLProtocolDidFinishLoading:self];
                }];
            }
        }
    }
    else if ([self.request.URL.path isEqualToString:[ACSpotifyAuth shared].tokenRefreshURL.path]) {
        
        if (self.request.HTTPBody) {
            NSString *string = [NSString stringWithUTF8String:(char*)[self.request.HTTPBody bytes]];

            if (string) {
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"refresh_token=([a-zA-Z\\d-_]+)" options:NSRegularExpressionCaseInsensitive error:nil];
                NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];

                if (match) {
                    self.refreshToken = [string substringWithRange:[match rangeAtIndex:1]];
                }

                [self refreshToken:^(NSError *error, NSDictionary *object) {

                    if (error) {
                        [client URLProtocol:self didFailWithError:error];
                        return;
                    }

                    [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                    [client URLProtocol:self didLoadData:[NSJSONSerialization dataWithJSONObject:object options:0 error:nil]];
                    [client URLProtocolDidFinishLoading:self];
                }];
            }
        }
    }
    else {
        [client URLProtocol:self didFailWithError:nil];
    }
}

- (void)stopLoading
{
    
}


#pragma mark - API
- (void)swapToken:(ACSpotifyAuthCallback)block
{
    NSDictionary *params = @{
        @"grant_type":@"authorization_code",
        @"code":self.authorizationCode,
        @"redirect_uri":[ACSpotifyAuth shared].redirectURL.absoluteString,
        @"client_id":[ACSpotifyAuth shared].clientID,
        @"client_secret":[ACSpotifyAuth shared].clientSecret
    };
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:ACSpotifyAuthURI]];
    [manager POST:ACSpotifyAuthTokenRoute parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
        
        if (block) {
            block(nil, response);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block) {
            block(error, nil);
        }
    }];
}

- (void)refreshToken:(ACSpotifyAuthCallback)block
{
    NSDictionary *params = @{
        @"grant_type":@"refresh_token",
        @"refresh_token":self.refreshToken,
        @"client_id":[ACSpotifyAuth shared].clientID,
        @"client_secret":[ACSpotifyAuth shared].clientSecret
    };
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:ACSpotifyAuthURI]];
    [manager POST:ACSpotifyAuthTokenRoute parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
        
        if (block) {
            block(nil, response);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block) {
            block(error, nil);
        }
    }];
}

@end

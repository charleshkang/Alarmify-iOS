/*
 Copyright 2015 Spotify AB

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>

// Adapted from sample code at:
// https://developer.apple.com/library/ios/samplecode/Reachability/Introduction/Intro.html

FOUNDATION_EXPORT NSString * const SPTReachabilityDidChangeNotification;


typedef NS_ENUM(NSUInteger, SPTNetworkStatus) {
	SPTNetworkStatusNotReachable = 0,
	SPTNetworkStatusWiFiReachable,
	SPTNetworkStatusWWANReachable
};


@interface SPTReachability : NSObject

/**
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/**
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

/**
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

/**
 * Checks whether a local WiFi connection is available.
 */
+ (instancetype)reachabilityForLocalWiFi;

/**
 * Start listening for reachability notifications on the current run loop.
 */
- (BOOL)startNotifier;

/**
 * Stop listening for reachability notifications on the current run loop.
 */
- (void)stopNotifier;

- (SPTNetworkStatus)currentReachabilityStatus;

/**
 * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
 */
- (BOOL)connectionRequired;

@end
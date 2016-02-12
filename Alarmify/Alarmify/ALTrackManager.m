//
//  ALTrackManager.m
//  Alarmify
//
//  Created by Charles Kang on 2/12/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALTrackManager.h"
#import "ALTrack.h"

@implementation ALTrackManager

+(void)searchSpotifyForTrack:(NSString *)track WithCompletion:(void (^)(NSArray *trackList))completion
{
    NSString *formattedTrack = [track stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [SPTSearch performSearchWithQuery:formattedTrack queryType:SPTQueryTypeTrack offset:0 accessToken:nil callback:^(NSError *error, SPTListPage *results) {
        
        //NSLog(@"performSearchWithQuery happened!!");
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSArray *songArray = results.items;
            NSMutableArray *trackURIArray = [[NSMutableArray alloc]init];
            for (SPTPartialTrack *songPointer in songArray) {
                NSURL *trackURI = songPointer.playableUri;
                [trackURIArray addObject:trackURI];
            }
            
            completion(trackURIArray);
        }];
        
    }];
}

+(void)getSingleTrackDataFromURI:(NSURL *)trackURI WithCompletion:(void (^)(NSDictionary *trackInfo))completion
{
    NSURLRequest *request = [SPTTrack createRequestForTrack:trackURI withAccessToken:nil market:nil error:nil];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *trackData = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSDictionary *trackDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            completion(trackDict);
            
            
            
        }];
        
        
    }];
    [trackData resume];
}

+(void)generateTracksFromSearch:(NSString *)searchKeyword WithCompletion:(void (^)(NSArray *tracks))completion
{
    [ALTrackManager searchSpotifyForTrack:searchKeyword WithCompletion:^(NSArray *trackList) {
        __block NSMutableArray *songDataArray = [[NSMutableArray alloc]init];
        for (NSURL *url in trackList) {
            [ALTrackManager getSingleTrackDataFromURI:url WithCompletion:^(NSDictionary *trackInfo) {
                
                NSString *songName = trackInfo[@"name"];
                NSString *artistName = trackInfo[@"artists"][0][@"name"];
                NSString *albumName = trackInfo[@"album"][@"name"];
                NSURL *spotifyURL = trackInfo[@"uri"];
                NSNumber *songPopularity = trackInfo[@"popularity"];
                NSData *coverArt = [[NSData alloc]init];
                UIImage *logo = [UIImage imageNamed:@"spotify"];
                NSArray *URLArray = trackInfo[@"album"][@"images"];
                ALTrack *newTrack = [[ALTrack alloc]init];
                
                if (URLArray.count > 1) {
                    NSDictionary *coverArtURLLocation = trackInfo[@"album"][@"images"][1];
                    NSURL *coverArtURL = [NSURL URLWithString: coverArtURLLocation[@"url"]];
                    coverArt = [[NSData alloc] initWithContentsOfURL:coverArtURL];
                    newTrack = [[ALTrack alloc] initWithSongTitle:songName artistName:artistName albumName:albumName spotifyURL:spotifyURL coverArt:coverArt songPopularity:songPopularity spotifyLogo:nil];
                } else {
                    newTrack = [[ALTrack alloc] initWithSongTitle:songName artistName:artistName albumName:albumName spotifyURL:spotifyURL coverArt:nil songPopularity:songPopularity spotifyLogo:logo];
                }
                
                [songDataArray addObject:newTrack];
                if (songDataArray.count == trackList.count) {
                    completion(songDataArray);
                }
            }];
        }
    }];
}


@end

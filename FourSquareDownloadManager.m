//
//  FourSquareDownloadManager.m
//  DriveBy
//
//  Created by Mac on 3/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "FourSquareDownloadManager.h"

const NSString *exploreBaseURL = @"https://api.foursquare.com/v2/venues/explore?";
const NSString *fourSquareClientID = @"CV3N3OGNG2LZLAS0B2G3LWNZ0MQX5LU4UGI24GDWMYY3NIE0";
const NSString *fourSquareSecretKey = @"LFQTJTYY1N0CHWLYER4W4RTVSKLC31S2QAYTQ3VELMWEECJT";

@implementation FourSquareDownloadManager

- (instancetype)initWithCurrentLocation:(CLLocation*) aLocation
{
    self = [super init];
    if (self) {
        _currentLocation = aLocation;
    }
    return self;
}

-(void)downloadPopularVenues{
   /*
https://api.foursquare.com/v2/venues/explore?client_id=CV3N3OGNG2LZLAS0B2G3LWNZ0MQX5LU4UGI24GDWMYY3NIE0%20%20&client_secret=LFQTJTYY1N0CHWLYER4W4RTVSKLC31S2QAYTQ3VELMWEECJT&v=20130815&ll= 33.885032,-84.470590&&radius=1600&time=any&venuePhotos=1&sortByDistance=1&limit=50
*/
    
    //construct URL
    CLLocationDegrees lat = self.currentLocation.coordinate.latitude;
    CLLocationDegrees lon = self.currentLocation.coordinate.longitude;
    
    NSString *url = [NSString stringWithFormat:@"%@client_id=%@&client_secret=%@&ll=%f,%f&radius=1600&time=any&venuePhotos=1&sortByDistance=1&limit=50&v=20130815",exploreBaseURL, fourSquareClientID, fourSquareSecretKey, lat, lon ];
    //NSLog(@"%@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([self.delegate respondsToSelector:@selector(fourSquarePopularVenuesDataReady:)]){
            [self.delegate fourSquarePopularVenuesDataReady:responseObject];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if([self.delegate respondsToSelector:@selector(fourSquarePopularVenuesDataDidFail:)]){
            [self.delegate fourSquarePopularVenuesDataDidFail:error];
 
        }
    }];
    
    

    
}

@end

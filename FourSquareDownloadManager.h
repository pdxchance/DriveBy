//
//  FourSquareDownloadManager.h
//  DriveBy
//
//  Created by Mac on 3/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

@protocol FourSquareDataReadyProtocol <NSObject>

@required
-(void)fourSquarePopularVenuesDataReady:(id)response;
-(void)fourSquarePopularVenuesDataDidFail:(NSError*)error;

@end

@interface FourSquareDownloadManager : NSObject

@property(nonatomic,strong) CLLocation *currentLocation;
@property(nonatomic,weak) id <FourSquareDataReadyProtocol> delegate;

-(instancetype)initWithCurrentLocation:(CLLocation*) aLocation;
-(void)downloadPopularVenues;

@end

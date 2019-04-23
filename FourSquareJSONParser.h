//
//  FourSquareJSONParser.h
//  DriveBy
//
//  Created by Mac on 3/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FourSquarePopularVenues.h"

@protocol FourSquareJSONReadyProtocol <NSObject>

@required
-(void)fourSquarePopularVenuesJSONReady:(NSArray*)data;
-(void)fourSquarePopularVenuesJSONDidFail:(NSError*)error;

@end

@interface FourSquareJSONParser : NSObject

@property(nonatomic,weak) id <FourSquareJSONReadyProtocol> delegate;
-(void)parseJSON:(id)responseObject;

@end

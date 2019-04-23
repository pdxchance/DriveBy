//
//  FourSquarePopularVenues.h
//  DriveBy
//
//  Created by Mac on 3/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquarePopularVenues : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *category;
@property(nonatomic,strong) NSString *photoURL;
@property(nonatomic,strong) NSNumber *distance;
@property(nonatomic) double lattitude;
@property(nonatomic) double longitude;



@end

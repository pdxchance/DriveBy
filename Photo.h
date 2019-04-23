//
//  Photo.h
//  DriveBy
//
//  Created by Mac on 3/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dwelling;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * dwellingImage;
@property (nonatomic, retain) Dwelling *dwelling;

@end

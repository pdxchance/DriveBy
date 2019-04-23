//
//  Dwelling.h
//  DriveBy
//
//  Created by Mac on 3/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Dwelling : NSManagedObject

@property (nonatomic, retain) NSString * dwellingAddres1;
@property (nonatomic, retain) NSString * dwellingAddress2;
@property (nonatomic, retain) NSString * dwellingCity;
@property (nonatomic, retain) NSString * dwellingContactEmail;
@property (nonatomic, retain) NSString * dwellingContactEmal;
@property (nonatomic, retain) NSDate * dwellingContactLastContacted;
@property (nonatomic, retain) NSString * dwellingContactName;
@property (nonatomic, retain) NSString * dwellingContactNotes;
@property (nonatomic, retain) NSString * dwellingContactPhoneNumber;
@property (nonatomic, retain) NSDecimalNumber * dwellingDeposit;
@property (nonatomic, retain) NSNumber * dwellingLatitude;
@property (nonatomic, retain) NSNumber * dwellingLongitude;
@property (nonatomic, retain) NSString * dwellingNeighborhood;
@property (nonatomic, retain) NSNumber * dwellingNumberBathrooms;
@property (nonatomic, retain) NSNumber * dwellingNumberBedrooms;
@property (nonatomic, retain) NSDecimalNumber * dwellingRent;
@property (nonatomic, retain) NSString * dwellingState;
@property (nonatomic, retain) NSString * dwellingType;
@property (nonatomic, retain) NSString * dwellingZipCode;
@property (nonatomic, retain) NSString * dwellingNotes;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Dwelling (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end

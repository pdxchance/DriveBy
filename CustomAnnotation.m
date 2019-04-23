//
//  MyAnnotation.m
//  MapKitCoreLocation
//
//  Created by Mac on 3/18/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)aLocation withTitle:(NSString*)aTitle AndSubtitle:(NSString*)aSubtitle AndPhotoURL:(NSString*)aPhotoURL
{
    self = [super init];
    if (self) {
        _coordinate = aLocation;
        _title = aTitle;
        _subtitle = aSubtitle;
        _photoURL = aPhotoURL;
    }
    return self;
}

@end

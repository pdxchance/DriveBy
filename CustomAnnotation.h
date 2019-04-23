//
//  MyAnnotation.h
//  MapKitCoreLocation
//
//  Created by Mac on 3/18/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject<MKAnnotation>

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;
@property(nonatomic,assign) NSString *photoURL;
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)aLocation withTitle:(NSString*)aTitle AndSubtitle:(NSString*)aSubtitle AndPhotoURL:(NSString*)aPhotoURL;

@end

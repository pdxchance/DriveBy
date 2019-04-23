//
//  LocalSearchViewController.h
//  DriveBy
//
//  Created by Mac on 3/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "LocalTableViewCell.h"
#import "CustomAnnotation.h"
#import "FourSquareDownloadManager.h"
#import "FourSquareJSONParser.h"
#import "FourSquarePopularVenues.h"
#import "LocationImageViewController.h"

@interface LocalSearchViewController : UIViewController<FourSquareDataReadyProtocol, FourSquareJSONReadyProtocol, UITableViewDataSource, UITableViewDelegate>

@property CLLocation *location;


@end

//
//  ViewController.h
//  DriveBy
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MainTableViewCell.h"
#import "DetailViewController.h"
#import "CustomAnnotation.h"

@interface MainViewController : UIViewController<UITabBarDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate>


@end


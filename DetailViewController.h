//
//  DetailViewController.h
//  DriveBy
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HousingPickerViewController.h"
#import "ContactViewController.h"
#import "LocalSearchViewController.h"
#import "NotesViewController.h"
#import "Dwelling.h"
#import "Photo.h"
#import "Constants.h"


@interface DetailViewController : UIViewController<HousingTypeDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property CLLocation *location;
@property DwellingEditMode editMode;
@property(nonatomic,strong) Dwelling *dwelling;

@end

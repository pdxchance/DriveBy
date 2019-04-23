//
//  ContactViewController.h
//  DriveBy
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DateTimePickerViewController.h"
#import "Dwelling.h"


@interface ContactViewController : UIViewController<DateTimePickerDataSource, UITextFieldDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property(nonatomic,strong) Dwelling *dwelling;

@end

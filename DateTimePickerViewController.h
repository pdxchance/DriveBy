//
//  DatTimePickerViewController.h
//  DriveBy
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateTimePickerDataSource <NSObject>

@required
-(void)dateTimeReady:(NSString*)data;

@end

@interface DateTimePickerViewController : UIViewController

@property(nonatomic,assign)id<DateTimePickerDataSource> delegate;

@end

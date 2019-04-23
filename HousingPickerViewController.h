//
//  HousingPickerViewController.h
//  DriveBy
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HousingTypeDataSource <NSObject>

@required
-(void)housingDataReady:(NSString*)data;

@end

@interface HousingPickerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property(nonatomic,assign)id<HousingTypeDataSource> delegate;

@end

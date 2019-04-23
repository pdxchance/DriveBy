//
//  HousingPickerViewController.m
//  DriveBy
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "HousingPickerViewController.h"

@interface HousingPickerViewController ()


@end

NSArray *_pickerData;

@implementation HousingPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pickerData = @[@"Apartment", @"Condo", @"Duplex", @"House", @"Hotel"];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _pickerData.count;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 26)];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial" size:26];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.text = [NSString stringWithFormat:@" %@", _pickerData[row]];
    return label;    
}

- (IBAction)selectBtn:(id)sender {
    
    NSInteger row;
    NSString *data;
    
    row = [self.picker selectedRowInComponent:0];
    data = [_pickerData objectAtIndex:row];
    
    [self.delegate housingDataReady:data];
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

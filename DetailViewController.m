//
//  DetailViewController.m
//  DriveBy
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *address1TextField;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;
@property (weak, nonatomic) IBOutlet UITextField *neighborhoodTextField;

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UILabel *housingTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberBedroomsTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberOfBathroomsTextField;
@property (weak, nonatomic) IBOutlet UITextField *rentTextField;
@property (weak, nonatomic) IBOutlet UITextField *depositTextField;

@property(nonatomic,strong) CLGeocoder *geocoder;
@property(nonatomic,strong) CLPlacemark *placemark;
@property(nonatomic,strong) NSMutableArray *imageViews;
@end



@implementation DetailViewController

#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //init
    self.imageViews = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(captureImage)];
    singleTapGestureRecognizer.numberOfTapsRequired = 2;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    if(self.editMode == kEditingRecord){
        
        CLLocationDegrees lat = [[self.dwelling valueForKey:@"dwellingLatitude"] doubleValue];
        CLLocationDegrees lon = [[self.dwelling valueForKey:@"dwellingLongitude"] doubleValue];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        
        self.location = location;
        
        self.address1TextField.text = [self.dwelling valueForKey:@"dwellingAddres1"];
        self.address2TextField.text = [self.dwelling valueForKey:@"dwellingAddress2"];
        self.cityTextField.text = [self.dwelling valueForKey:@"dwellingCity"];
        self.stateTextField.text = [self.dwelling valueForKey:@"dwellingState"];
        self.neighborhoodTextField.text = [self.dwelling valueForKey:@"dwellingNeighborhood"];
        self.housingTypeLabel.text = [self.dwelling valueForKey:@"dwellingType"];
        self.numberBedroomsTextField.text = [NSString stringWithFormat:@"%@",[self.dwelling valueForKey:@"dwellingNumberBedrooms"]];
        self.numberOfBathroomsTextField.text = [NSString stringWithFormat:@"%@",[self.dwelling valueForKey:@"dwellingNumberBathrooms"]];
        self.rentTextField.text = [NSString stringWithFormat:@"%@",[self.dwelling valueForKey:@"dwellingRent"]];
        self.depositTextField.text = [NSString stringWithFormat:@"%@",[self.dwelling valueForKey:@"dwellingDeposit"]];
        
        NSSet *imageSet = [[NSSet alloc]initWithSet:[self.dwelling valueForKey:@"photos"]];
        NSArray *imageArray = [imageSet allObjects]; //Photo objects
        for (Photo *photo in imageArray) {
            
            UIImage *image = [UIImage imageWithData:photo.dwellingImage];
            UIImageView *imageView;
            imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = image;
            [self.imageViews insertObject:imageView atIndex:0];
            
            //set scroll view
            CGSize pageSize = self.scrollView.frame.size;
            
            NSUInteger page = 0;
            for(UIImageView *view in self.imageViews) {
                view.frame = CGRectMake(pageSize.width * page++ + 10, 0, pageSize.width - 20, pageSize.height);
                [self.scrollView addSubview:view];
                
                
            }
            self.scrollView.contentSize = CGSizeMake(pageSize.width * [self.imageViews count], pageSize.height);
            
        }
        
        
    }else{
        [self reverseGeoCode];
    }

    
}

-(void)viewWillAppear:(BOOL)animated{
    //Set self to start observing for keyboard show/hide notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardAnimating:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardAnimating:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
//

}


-(void)viewWillDisappear:(BOOL)animated{
    //Important to remove observer. Cases may arise where we get rid of this view while still in the app, and said notification goes off, crash will ensue.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardAnimating:(NSNotification *)keyboardNotification{
    
    //Dig for the keyboard size
    CGSize keyboardSize = [[[keyboardNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Dig for duration
    float duration = [[[keyboardNotification userInfo] objectForKey:@"UIKeyboardAnimationurationUserInfoKey"] floatValue];
    
    //Perform animation to factor in screensize
    [UIView animateWithDuration:duration animations:^{
        if( [keyboardNotification.name isEqualToString:@"UIKeyboardWillShowNotification"] ){
            self.view.center = CGPointMake( self.view.center.x, self.view.center.y - keyboardSize.height);
            //NSLog(@"show = %f", self.view.center.y);
        }
        else{
            self.view.center = CGPointMake( self.view.center.x, self.view.center.y + keyboardSize.height);
            //NSLog(@"show = %f", self.view.center.y);
        }
    }];
}

#pragma mark - Textfield Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - GPS
-(void)reverseGeoCode{
    
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            
            if (self.placemark.subThoroughfare != nil) {
                self.address1TextField.text = [NSString stringWithFormat:@"%@ %@", self.placemark.subThoroughfare, self.placemark.thoroughfare];
            }else{
                self.address1TextField.text = [NSString stringWithFormat:@"%@", self. self.placemark.thoroughfare];
            }
            self.neighborhoodTextField.text = self.placemark.subLocality;
            self.cityTextField.text = self.placemark.locality;
            self.stateTextField.text = self.placemark.administrativeArea;
            
        } else {
            //NSLog(@"%@", error.debugDescription);
        }
    } ];
    

    
    
}


#pragma mark - Delegates
-(void)housingDataReady:(NSString*)data{
    
    self.housingTypeLabel.text = data;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"housingTypeViewSegue"]) {
        HousingPickerViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"contactViewSegue"]) {
        ContactViewController *vc = [segue destinationViewController];
        vc.dwelling = self.dwelling;
    }
    
    if ([segue.identifier isEqualToString:@"localSearchViewSegue"]) {
        LocalSearchViewController *vc = [segue destinationViewController];
        vc.location = self.location;
        
    }
    
    if ([segue.identifier isEqualToString:@"NotesViewSegue"]) {
        NotesViewController *vc = [segue destinationViewController];
        vc.dwelling = self.dwelling;
        
    }

    
}
#pragma mark - Images
- (IBAction)cameraBtn:(id)sender {
    [self captureImage];
}

-(void)captureImage{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    

    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //grab image
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    //put in our array
    UIImageView *imageView;
    imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.image = chosenImage;
    imageView.tag = 1; //means this image is new and needs to be saved
    [self.imageViews insertObject:imageView atIndex:0];
    
    //set scroll view
    CGSize pageSize = self.scrollView.frame.size;
    
    NSUInteger page = 0;
    for(UIImageView *view in self.imageViews) {
        view.frame = CGRectMake(pageSize.width * page++ + 10, 0, pageSize.width - 20, pageSize.height);
        [self.scrollView addSubview:view];

        
    }
    self.scrollView.contentSize = CGSizeMake(pageSize.width * [self.imageViews count], pageSize.height);
    
    
    //dismiss
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Core Data
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - IBActions
- (IBAction)doneBtn:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    Dwelling *dwelling;
    
    // add or modify depending on mode
    if(self.editMode == kAddingRecord){
    dwelling = [NSEntityDescription insertNewObjectForEntityForName:@"Dwelling" inManagedObjectContext:context];
    }else{
        dwelling = self.dwelling;
    }
    
    [dwelling setValue:self.address1TextField.text forKey:@"dwellingAddres1"];
    [dwelling setValue:self.address2TextField.text forKey:@"dwellingAddress2"];
    [dwelling setValue:self.neighborhoodTextField.text forKey:@"dwellingNeighborhood"];
    [dwelling setValue:self.cityTextField.text forKey:@"dwellingCity"];
    [dwelling setValue:self.stateTextField.text forKey:@"dwellingState"];
    [dwelling setValue:self.housingTypeLabel.text forKey:@"dwellingType"];
    [dwelling setValue:[NSNumber numberWithInt:[self.numberBedroomsTextField.text intValue]] forKey:@"dwellingNumberBedrooms"];
    [dwelling setValue:[NSNumber numberWithInt:[self.numberBedroomsTextField.text intValue]] forKey:@"dwellingNumberBathrooms"];
    [dwelling setValue:[NSDecimalNumber numberWithFloat:[self.rentTextField.text floatValue]] forKey:@"dwellingRent"];
    [dwelling setValue:[NSDecimalNumber numberWithFloat:[self.depositTextField.text floatValue]] forKey:@"dwellingDeposit"];
    
    if (self.location) {
        [dwelling setValue:[NSNumber numberWithDouble:self.location.coordinate.latitude] forKey:@"dwellingLatitude"];
        
        [dwelling setValue:[NSNumber numberWithDouble:self.location.coordinate.longitude] forKey:@"dwellingLongitude"];
    }
    
    //now images
    for(UIImageView *imgView in self.imageViews){
        
        if(imgView.tag == 1){ //only save new images
            //convert image to binary data
            NSData *imageData = UIImagePNGRepresentation(imgView.image);
            
            //create new photo
            Photo *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
            
            //set and add
            [newPhoto setValue:imageData forKey:@"dwellingImage"];
            [dwelling addPhotosObject:newPhoto];
        }
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        [self showAlertMsg:[NSString stringWithFormat:@"Error saving record! %@ %@",error, [error localizedDescription]]];
    }
    else{
        [self showAlertMsg:@"Record saved successfully"];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlertMsg:(NSString*)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DriveBy" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
}

@end

//
//  ViewController.m
//  DriveBy
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) CLLocationManager *coreLocationManager;
@property CLLocation *currentLocation;

@property(nonatomic,strong) NSMutableArray *dwellings; //managed objects
@end



@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drivebylogo"]];
    self.navigationItem.titleView = imageView;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    self.coreLocationManager = [[CLLocationManager alloc] init];
    self.coreLocationManager.delegate = self;
    
    if([self.coreLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        
        [self.coreLocationManager requestWhenInUseAuthorization];
    }
    
    [self.coreLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.coreLocationManager setActivityType:CLActivityTypeFitness];
    
    [self.coreLocationManager startUpdatingLocation];
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Dwelling"];
    self.dwellings = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //get current location
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;
    
}

#pragma mark - MapView
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pin.enabled = YES;
    pin.canShowCallout = NO;
    [pin setAnimatesDrop:YES];
    
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pin;
    
    
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    //NSLog(@"Display photo here");
}



#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dwellings.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Dwelling *dwelling = [self.dwellings objectAtIndex:indexPath.row];
    CLLocationDegrees lat = [[dwelling valueForKey:@"dwellingLatitude"] doubleValue];
    CLLocationDegrees lon = [[dwelling valueForKey:@"dwellingLongitude"] doubleValue];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];

    
    [self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.00703125, 0.00703125))]; //1/8 mile
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
    
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake(lat, lon) withTitle:[NSString stringWithFormat:@"$%@",[dwelling valueForKey:@"dwellingRent"]] AndSubtitle:[NSString stringWithFormat:@"%@ Bedroom / %@ Bath",[dwelling valueForKey:@"dwellingNumberBedrooms"], [dwelling valueForKey:@"dwellingNumberBathrooms"]] AndPhotoURL:@""];
    
    [self.mapView addAnnotation:annotation];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Dwelling *dwelling = [self.dwellings objectAtIndex:indexPath.row];
    
    cell.propertyTypeLabel.text = [dwelling valueForKey:@"dwellingType"];
    cell.neighborhoodLabel.text = [NSString stringWithFormat:@"%@ (%@, %@) ",[dwelling valueForKey:@"dwellingNeighborhood"], [dwelling valueForKey:@"dwellingCity"], [dwelling valueForKey:@"dwellingState"]];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ Bedroom / %@ Bath",[dwelling valueForKey:@"dwellingNumberBedrooms"], [dwelling valueForKey:@"dwellingNumberBathrooms"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@",[dwelling valueForKey:@"dwellingRent"]];
    
    NSSet *imageSet = [[NSSet alloc]initWithSet:[dwelling valueForKey:@"photos"]];
    NSArray *imageArray = [imageSet allObjects]; //Photo objects
    if(imageArray.count > 0){
        Photo *photo = [imageArray objectAtIndex:0];
        UIImage *image = [UIImage imageWithData:photo.dwellingImage];
        cell.image.image = image;
    }

    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor blueColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
    
    
}

// Swipe to delete.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Dwelling *dwelling = [self.dwellings objectAtIndex:indexPath.row];
        [[self managedObjectContext] deleteObject:dwelling];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![[self managedObjectContext] save:&error]) {
            [self showAlertMsg:[NSString stringWithFormat:@"Error deleting record! %@ %@",error, [error localizedDescription]]];
        }
        else{
            [self showAlertMsg:@"Record deleted successfully"];
        }
        
        
        [self.dwellings removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //get selected cell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:@"detailViewSegue"]) {
        DetailViewController *vc = [segue destinationViewController];
        vc.dwelling = self.dwellings[indexPath.row];
        vc.editMode = kEditingRecord;
        
    }
    
    if ([segue.identifier isEqualToString:@"detailAddSegue"]) {
        DetailViewController *vc = [segue destinationViewController];
        vc.location = self.currentLocation;
        vc.editMode = kAddingRecord;
        
    }
    
    
}

#pragma mark Core Data
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)showAlertMsg:(NSString*)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DriveBy" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
}

@end

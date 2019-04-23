//
//  LocalSearchViewController.m
//  DriveBy
//
//  Created by Mac on 3/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "LocalSearchViewController.h"

@interface LocalSearchViewController ()
@property(nonatomic,strong)FourSquareDownloadManager *manager;
@property(nonatomic,strong)FourSquareJSONParser *parser;
@property(nonatomic,strong)NSArray *placesArray; //dictionary
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LocalSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.manager = [[FourSquareDownloadManager alloc] initWithCurrentLocation:self.location];
    self.parser = [[FourSquareJSONParser alloc] init];
    self.parser.delegate = self;
    
    self.manager.delegate = self;
    [self.manager downloadPopularVenues];

}

-(void)fourSquarePopularVenuesDataReady:(id)response{
    
    dispatch_queue_t queue = dispatch_queue_create("queue",NULL);
    dispatch_async(queue, ^{
 
        [self.parser parseJSON:response];

    }); 
}
-(void)fourSquarePopularVenuesDataDidFail:(NSError*)error{
   
    NSLog(@"Error: %@", error);
}

-(void)fourSquarePopularVenuesJSONReady:(NSArray*)data{
    // Update the UI
    self.placesArray = data;
    [self.tableView reloadData];

}
-(void)fourSquarePopularVenuesJSONDidFail:(NSError*)error{
    
    NSLog(@"Error: %@", error);
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.placesArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSMutableArray *places = [self.placesArray objectAtIndex:section];
    return places.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSDictionary *dict = [self.placesArray objectAtIndex:section];
    NSArray *allKeys = [dict allKeys];
    NSString *category = allKeys[0];
    return category;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LocalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *dict = [self.placesArray objectAtIndex:indexPath.section];
    NSArray *allKeys = [dict allKeys];
    NSString *category = allKeys[0];
    
    NSMutableArray *places = [dict objectForKey:category];
    
    FourSquarePopularVenues *place = [places objectAtIndex:indexPath.row];
    
    float miles = place.distance.floatValue * 0.000621371;
    
    cell.nameLabel.text = place.name;
    cell.addressLabel.text = place.address;
    cell.categoryLabel.text = place.category;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f miles away", miles];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor blueColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
    
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSDictionary *dict = [self.placesArray objectAtIndex:indexPath.section];
//    NSArray *allKeys = [dict allKeys];
//    NSString *category = allKeys[0];
//    
//    NSMutableArray *places = [dict objectForKey:category];
//    
//    FourSquarePopularVenues *place = [places objectAtIndex:indexPath.row];
//    
//    CLLocationDegrees lat = place.lattitude;
//    CLLocationDegrees lon = place.longitude;
//    
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
//    
//    [self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.00703125, 0.00703125))]; //1/8 mile
//    
//    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
//    
//    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) withTitle:place.name AndSubtitle:place.category AndPhotoURL:place.photoURL];
//    
//    [self.mapView addAnnotation:annotation];
//}


- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
#pragma mark - MapView
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pin.enabled = YES;
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [pin setAnimatesDrop:YES];
    
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pin;
    
    
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    CustomAnnotation *annView = view.annotation;
    LocationImageViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationImageViewController"];
    vc.url = annView.photoURL;
    [self showViewController:vc sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"LocationImageViewSegue"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        NSDictionary *dict = [self.placesArray objectAtIndex:indexPath.section];
        NSArray *allKeys = [dict allKeys];
        NSString *category = allKeys[0];
        
        NSMutableArray *places = [dict objectForKey:category];
        
        FourSquarePopularVenues *place = [places objectAtIndex:indexPath.row];
        
        LocationImageViewController *vc = [segue destinationViewController];
        vc.url = place.photoURL;
    }
    
}


@end

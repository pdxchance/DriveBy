//
//  FourSquareJSONParser.m
//  DriveBy
//
//  Created by Mac on 3/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "FourSquareJSONParser.h"

@implementation FourSquareJSONParser

-(void)parseJSON:(id)responseObject{
    
    NSMutableArray *placesArray = [[NSMutableArray alloc] init];

    NSDictionary *root = responseObject;
    NSDictionary *response = [root objectForKey:@"response"];
    NSArray *groups = [response objectForKey:@"groups"];
    NSDictionary *firstGroup = groups[0];
    NSArray *items = [firstGroup objectForKey:@"items"];
    
    for (NSDictionary *dict in items) {
        
        FourSquarePopularVenues *place = [[FourSquarePopularVenues alloc] init];
        
        NSDictionary *venue = [dict objectForKey:@"venue"];
        place.name = [venue objectForKey:@"name"];
        
        NSDictionary *address = [venue objectForKey:@"location"];
        place.address = [address objectForKey:@"address"];
        place.lattitude = [[address objectForKey:@"lat"] doubleValue];
        place.longitude = [[address objectForKey:@"lng"] doubleValue];
        place.distance = [address objectForKey:@"distance"];
        
        NSArray *categories = [venue objectForKey:@"categories"];
        NSDictionary *category = categories[0];
        place.category = [category objectForKey:@"name"];
    
        
        NSDictionary *featuredPhotos = [venue objectForKey:@"featuredPhotos"];
        NSArray *items = [featuredPhotos objectForKey:@"items"];
        NSDictionary *photo = items[0];
        NSString *url = [NSString stringWithFormat:@"%@%@x%@%@",[photo objectForKey:@"prefix"],[photo objectForKey:@"width"],[photo objectForKey:@"height"],[photo objectForKey:@"suffix"]];
        if(url){
            place.photoURL = url;
        }else{
            place.photoURL = @"";
        }
        
        
        //see if dictionary exists for this key if so add item to end of array
        BOOL found = false;
        for(NSDictionary *dict in placesArray){
            if ([[dict allKeys] containsObject:place.category]) {
                NSMutableArray *places = [dict objectForKey:place.category];
                [places addObject:place];
                found = true;
                break;
            }
        }
        
        //see if we need to add dictionary to array
        if(!found){
            NSMutableArray *places = [[NSMutableArray alloc] init];
            [places addObject:place];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:places forKey:place.category];
            [placesArray addObject:dict];
        }
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update the UI
        if ([self.delegate respondsToSelector:@selector(fourSquarePopularVenuesJSONReady:)]) {
            [self.delegate fourSquarePopularVenuesJSONReady:[NSMutableArray arrayWithArray:placesArray]];
        }
        
    });

    
}

@end

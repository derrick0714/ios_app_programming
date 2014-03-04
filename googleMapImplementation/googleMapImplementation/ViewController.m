//
//  ViewController.m
//  googleMapImplementation
//
//  Created by Xu Deng on 3/3/14.
//  Copyright (c) 2014 Xu Deng. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()
@end

@implementation ViewController
{
    GMSMapView *mapView_;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = @"Hello World";
    marker.appearAnimation = YES;
    
    self.view = mapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

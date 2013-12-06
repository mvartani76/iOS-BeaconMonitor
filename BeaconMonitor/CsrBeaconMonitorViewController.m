//
//  CsrBeaconMonitorViewController.m
//  BeaconMonitor
//
//  Created by CSR on 29/10/2013.
//  Copyright (c) 2013 CSR. All rights reserved.
//

#import "CsrBeaconMonitorViewController.h"
#import "CsrBeaconMonitorContents.h"

@interface CsrBeaconMonitorViewController ()

- (void)showPage:(NSString*)page;
@property (weak, nonatomic) IBOutlet UILabel *Label1;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@end

@implementation CsrBeaconMonitorViewController
{
    CLLocationManager* locationManager;
    CLBeaconRegion* beaconRegion;
    IBOutlet UIWebView* descriptionView;
}

- (void)showPage:(NSString *)page
{
    // create a path to the internal resource
    NSString* htmlFile = [[NSBundle mainBundle] pathForResource:page ofType:@"html"];
    
    // read the HTML from it
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    // update the web view
    [descriptionView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    // create a location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;

    // initialise the monitored beacon
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[CsrBeaconMonitorContents bmContents].supportedProximityUUID major:[CsrBeaconMonitorContents bmContents].supportedMajor.shortValue identifier:@"com.csr.BeaconMonitor"];

    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;

    // start monitoring the region
    [locationManager startMonitoringForRegion:beaconRegion];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // show default page
    [self showPage:[CsrBeaconMonitorContents bmContents].defaultPage];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside)
    {
        // start ranging beacons
        [locationManager startRangingBeaconsInRegion:beaconRegion];
    }
    else{
        // show default page
        [self showPage:[CsrBeaconMonitorContents bmContents].defaultPage];

    }
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // check whether any beacons found nearby
    if([beacons count] > 0)
    {
        // select the closest beacon
        CLBeacon* closestBeacon = beacons[0];
        
        // check its proximity
        // TODO: add additional ranging check with RSSI
        
        self.rssiLabel.text = [NSString stringWithFormat:@"RSSI = %i",closestBeacon.rssi];
        
        if((closestBeacon.proximity == CLProximityImmediate) || (closestBeacon.proximity == CLProximityNear)){
            // get beacon minor value
            short beaconMinor = [closestBeacon.minor shortValue];
            
            // try to display corresponding page
            if(beaconMinor < [[CsrBeaconMonitorContents bmContents].contentFiles count]){
                // get the content file
                [self showPage:[CsrBeaconMonitorContents bmContents].contentFiles[beaconMinor]];
                
                // exit
                return;
            }
        }
    }

    // just display default page if no matching page was found
    [self showPage:[CsrBeaconMonitorContents bmContents].defaultPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    // we do want status bar
    return NO;
}

@end

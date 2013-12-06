//
//  CsrBeaconMonitorContents.m
//
//  Contains the default values for beacons and
//  associated information files
//
//  Created by CSR on 29/10/2013.
//  Copyright (c) 2013 CSR. All rights reserved.
//

#import "CsrBeaconMonitorContents.h"

@implementation CsrBeaconMonitorContents

- (id)init
{
    self = [super init];
    if(self)
    {
        // supported beacons
        _supportedProximityUUID = [[NSUUID alloc] initWithUUIDString:@"0001BEAC-D102-11E1-9B23-00025B00A5A5"];
        
        // supported major
        _supportedMajor = @0x0ce5;

        // associated files
        _contentFiles = @[@"uEnergy",
                          @"Audio",
                          @"Location",
                          @"csr"];
        
        // default view page
        _defaultPage = @"Default";

    }
    
    return self;
}

+ (CsrBeaconMonitorContents *)bmContents
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

@end

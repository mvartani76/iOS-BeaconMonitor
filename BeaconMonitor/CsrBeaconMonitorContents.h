//
//  CsrBeaconMonitorContents.h
//  BeaconMonitor
//
//  Created by CSR on 29/10/2013.
//  Copyright (c) 2013 CSR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CsrBeaconMonitorContents : NSObject

+ (CsrBeaconMonitorContents *)bmContents;

@property (nonatomic, copy, readonly) NSUUID *supportedProximityUUID;
@property (nonatomic, copy, readonly) NSNumber *supportedMajor;
@property (nonatomic, copy, readonly) NSArray *contentFiles;
@property (nonatomic, copy, readonly) NSString *defaultPage;

@end

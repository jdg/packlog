//
//  Beacon.h
//  PinchMedia
//
//  Created by Jesse Rohland on 4/6/08.
//  Copyright 2008 PinchMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Beacon : NSObject <CLLocationManagerDelegate> {
	NSString			*applicationCode;
	BOOL				beaconStarted;
	BOOL				uploading;
	BOOL				useCoreLocation;
	CLLocationManager	*locationManager;
	NSURLConnection		*connection;
	NSMutableData		*receivedData;
}


+ (id)initAndStartBeaconWithApplicationCode:(NSString *)theApplicationCode useCoreLocation:(BOOL)coreLocation;
+ (id)shared;
- (void)startSubBeaconWithName:(NSString *)beaconName timeSession:(BOOL)trackSession;
- (void)endSubBeaconWithName:(NSString *)beaconName;
- (void)startBeacon;
- (void)endBeacon;
- (void)setBeaconLocation:(CLLocation *)newLocation;
- (NSDictionary *)getCurrentRunningBeacon;

@end

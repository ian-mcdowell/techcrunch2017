//
//  MQTrafficCamera.h
//
//  Copyright (c) 2013 MapQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "MGLAnnotation.h"

@interface MQTrafficCameraAnnotation : NSObject<MGLAnnotation>

@property(nonatomic, copy) NSString *idString;
@property(nonatomic, copy) NSDecimalNumber *lat;
@property(nonatomic, copy) NSDecimalNumber *lng;
@property(nonatomic, copy) NSString *name;
@property(assign) NSInteger updateFrequency;
@property(nonatomic, copy) NSString *view;
@property(nonatomic, copy) NSURL *cameraImageUrl;

@end

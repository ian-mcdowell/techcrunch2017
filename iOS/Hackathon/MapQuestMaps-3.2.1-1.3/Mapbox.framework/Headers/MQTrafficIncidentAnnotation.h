//
//  MQTrafficIncident.h
//
//  Copyright (c) 2013 MapQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "MGLAnnotation.h"

typedef NS_ENUM(NSInteger, MQTrafficIncidentType) {
    MQTrafficIncidentTypeUnknown,
    MQTrafficIncidentType1,
    MQTrafficIncidentType2,
    MQTrafficIncidentType3,
    MQTrafficIncidentTypeConstruction1,
    MQTrafficIncidentTypeConstruction2,
    MQTrafficIncidentTypeConstruction3
};

@interface MQTrafficIncidentAnnotation : NSObject<MGLAnnotation>

@property(nonatomic, copy) NSString *idString;
@property(nonatomic) NSInteger type;
@property(nonatomic) NSInteger severity;
@property(nonatomic) NSInteger eventCode;
@property(nonatomic, copy) NSNumber *lat;
@property(nonatomic, copy) NSNumber *lng;
@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;
@property(nonatomic, copy) NSString *shortDesc;
@property(nonatomic, copy) NSString *fullDescription;
@property(nonatomic, copy) NSString *iconURL;

@property(nonatomic, readonly) MQTrafficIncidentType incidentType;

@end

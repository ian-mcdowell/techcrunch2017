//
//  MQMapView.h
//
//  Copyright (c) 2016 MapQuest. All rights reserved.
//

#import "MGLMapView.h"
#import "MQMapType.h"
#import "MGLStyle.h"


@protocol MGLMapViewDelegate;
@protocol MQMapViewTrafficDelegate;


@interface MQMapView : MGLMapView

/**
 Delegate for configuring the appearance of traffic annotations and shapes
 */
@property(nonatomic, weak, nullable) IBOutlet id<MQMapViewTrafficDelegate> trafficDelegate;

/**
 Configures whether traffic is currently displayed or not.
 */
@property (nonatomic, assign) BOOL trafficEnabled;

/**
 When trafficEnabled is YES, will display traffic flow data on map. Default is YES.
 */
@property (nonatomic, assign) BOOL shouldShowTrafficFlows;

/**
 When trafficEnabled is YES, will display traffic incidents on map. Default is YES.
 */
@property (nonatomic, assign) BOOL shouldShowTrafficIncidents;

/**
 List of traffic annotations currently on the map
 */
@property (nonatomic, readonly, nonnull) NSArray *trafficAnnotations;

/**
 Can toggle between standard and satellite view. See MQMapType.h for options.
 */
@property (nonatomic, assign) MQMapType mapType;

/**
 Will consume less energy and resources when enabled and when following the user
 (when userTrackingMode is set to something besides MGLUserTrackingModeNone)
 */
@property (nonatomic, assign) BOOL lowPowerModeEnabled;

/*! @abstract logoView property is not supported in the MapQuest SDK. */
@property (nonatomic, readonly, nullable) UIImageView *logoView NS_UNAVAILABLE;

/*! @abstract styleURL property is not supported in the MapQuest SDK. */
- (nonnull NSArray<NSURL *> *)bundledStyleURLs NS_UNAVAILABLE;

/*! @abstract styleURL property is not supported in the MapQuest SDK. */
- (nonnull NSURL *)styleURL NS_UNAVAILABLE;

/*! @abstract styleClasses is not supported in the MapQuest SDK. */
- (nonnull NSString *)styleClasses NS_UNAVAILABLE;

/*! @abstract addStyleClass is not supported in the MapQuest SDK. */
- (void)addStyleClass:(nonnull NSString * __unused)styleClass NS_UNAVAILABLE;

@end

@protocol MQMapViewTrafficDelegate <NSObject>

@optional

- (nullable MGLAnnotationImage *)mapView:(nonnull MGLMapView *)mapView imageForTrafficAnnotation:(nonnull id <MGLAnnotation>)annotation;

- (CGFloat)mapView:(nonnull MGLMapView *)mapView lineWidthForTrafficPolylineAnnotation:(nonnull MGLPolyline *)annotation;

- (nullable UIColor *)mapView:(nonnull MGLMapView *)mapView strokeColorForTrafficShapeAnnotation:(nonnull MGLShape *)annotation;

@end

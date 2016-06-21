//
//  kRESTConstants.h
//  onepagestreak
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybad. All rights reserved.
//

#ifndef kRESTConstants_h
#define kRESTConstants_h

#import <Foundation/Foundation.h>

static NSString *const kRESTLocationKey =       @"location";
static NSString *const kRESTPhotoKey =          @"photo";
static NSString *const kRESTStreakKey =         @"streak";

// streak type keys
static NSString *const kStreakTypeTypeKey =     @"type";
static NSString *const kStreakTypeStartAtKey =  @"start_at";
static NSString *const kStreakTypeStopAtKey =   @"stop_at";

// photo keys
static NSString *const kPhotoURLKey =           @"url";
static NSString *const kPhotoTakenAtKey =       @"taken_at";

// location keys
static NSString *const kLocationArrivedAtKey =  @"arrived_at";
static NSString *const kLocationLatitudeKey =   @"latitude";
static NSString *const kLocationLongitudeKey =  @"longitude";

#endif /* kRESTConstants_h */

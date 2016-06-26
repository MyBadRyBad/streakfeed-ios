//
//  LocationModel.h
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

@property (nonatomic, retain) NSDate *arrived_at;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@end

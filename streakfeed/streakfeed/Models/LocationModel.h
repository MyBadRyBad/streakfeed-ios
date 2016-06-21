//
//  LocationModel.h
//  onepagestreak
//
//  Created by Ryan Badilla on 6/17/16.
//  Copyright © 2016 rybad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

@property (nonatomic, retain) NSDate *arrived_at;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@end

//
//  StreakCardModel.h
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreakTypeModel.h"
#import "PhotoModel.h"
#import "LocationModel.h"

@interface StreakCardModel : NSObject

@property (nonatomic, retain) StreakTypeModel *streakType;
@property (nonatomic, retain) LocationModel *location;
@property (nonatomic, retain) PhotoModel *photo;

@end

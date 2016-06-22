//
//  StreakModel.h
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreakTypeModel : NSObject

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSDate *start_at;
@property (nonatomic, retain) NSDate *stop_at;

@end

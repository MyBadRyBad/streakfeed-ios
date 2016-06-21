//
//  StreakModel.h
//  onepagestreak
//
//  Created by Ryan Badilla on 6/17/16.
//  Copyright © 2016 rybad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreakTypeModel : NSObject

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSDate *start_at;
@property (nonatomic, retain) NSDate *stop_at;

@end

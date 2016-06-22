//
//  PhotoModel.h
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSDate *taken_at;

@end

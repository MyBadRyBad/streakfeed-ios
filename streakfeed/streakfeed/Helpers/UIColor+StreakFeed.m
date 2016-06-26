//
//  UIColor+StreakFeed.m
//  streakfeed
//
//  Created by Ryan Badilla on 6/26/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import "UIColor+StreakFeed.h"

@implementation UIColor (StreakFeed)

#define AGEColorImplement(COLOR_NAME,RED,GREEN,BLUE)    \
+ (UIColor *)COLOR_NAME{    \
static UIColor* COLOR_NAME##_color;    \
static dispatch_once_t COLOR_NAME##_onceToken;   \
dispatch_once(&COLOR_NAME##_onceToken, ^{    \
COLOR_NAME##_color = [UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0];  \
}); \
return COLOR_NAME##_color;  \
}

AGEColorImplement(tenseColor, 227.0/255.0f, 238.0/255.0f, 255.0/255.0f)
AGEColorImplement(calmColor, 232.0/255.0f, 255.0/255.0f, 255.0/255.0f)
AGEColorImplement(focusColor, 237/255.0f, 249.0/255.0f, 255.0/255.0f)

@end

//
//  UIColor+StreakFeed.m
//  streakfeed
//
//  Created by Ryan Badilla on 6/26/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import "UIColor+StreakFeed.h"

@implementation UIColor (StreakFeed)

// See http://blog.alexedge.co.uk/speeding-up-uicolor-categories/
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
AGEColorImplement(tenseFontColor, 68.0/255.0f, 85.0/255.0f, 153.0/255.0f)

AGEColorImplement(calmColor, 232.0/255.0f, 255.0/255.0f, 255.0/255.0f)
AGEColorImplement(calmFontColor, 0.0, 102.0/255.0, 170.0/255.0f)

AGEColorImplement(focusColor, 237/255.0f, 249.0/255.0f, 255.0/255.0f)
AGEColorImplement(focusFontColor, 0.0/255.0f,102/255.0f, 136/255.0f)

AGEColorImplement(globalFontColor, 34.0/255.0f, 102/255.0f, 136/255.0f)
//AGEColorImplement(globalHeaderColor, 236/255.0f, 240/255.0f, 241/255.0f)
AGEColorImplement(globalHeaderColor, 189/255.0f, 195/255.0f, 199/255.0f)

AGEColorImplement(backgroundColor, 255.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f);
AGEColorImplement(navigationBarColor, 0, 102/255.0f, 119/255.0f)
@end

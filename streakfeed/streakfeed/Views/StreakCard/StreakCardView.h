//
//  StreakCardView.h
//  streakfeed
//
//  Created by Ryan Badilla on 6/26/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageViewAligned.h"

@interface StreakCardView : UIView

@property (nonatomic, strong) UILabel *streakTypeLabel;
@property (nonatomic, strong) UILabel *durationTypeLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;

@property (nonatomic, strong) UIImageViewAligned *photoImageView;


- (void)setBackgroundColorWithStreakType:(NSString *)streakType;

@end

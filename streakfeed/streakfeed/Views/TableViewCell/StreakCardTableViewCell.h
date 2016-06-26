//
//  StreakCardTableViewCell.h
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface StreakCardTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *streakTypeLabel;
@property (nonatomic, strong) UILabel *durationTypeLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;

@property (nonatomic, strong) UIImageView *photoImageView;

@end

//
//  StreakCardTableViewCell.h
//  onepagestreak
//
//  Created by Ryan Badilla on 6/19/16.
//  Copyright © 2016 rybad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface StreakCardTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *streakTypeLabel;
@property (nonatomic, strong) UILabel *durationTypeLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) MKMapView *mapView;

@end

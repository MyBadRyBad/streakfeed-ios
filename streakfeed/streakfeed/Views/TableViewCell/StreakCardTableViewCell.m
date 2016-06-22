//
//  StreakCardTableViewCell.m
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import "StreakCardTableViewCell.h"

static CGFloat const kLabelHeight = 16.0f;

@interface StreakCardTableViewCell()

@end

@implementation StreakCardTableViewCell

#pragma mark - 
#pragma mark - initialization
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark -
#pragma mark - setup
- (void)setup {
    [self setupView];
    [self setupConstraints];
}


- (void)setupView {
    [self.contentView addSubview:[self streakTypeLabel]];
    [self.contentView addSubview:[self durationTypeLabel]];
    [self.contentView addSubview:[self startTimeLabel]];
    
    [self.contentView addSubview:[self mapView]];
    [self.contentView addSubview:[self photoImageView]];
}



- (void)setupConstraints {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_streakTypeLabel, _durationTypeLabel, _startTimeLabel, _mapView, _photoImageView);
    NSDictionary *metrics = @{@"vLabel" : @(kLabelHeight)};
    
    // add vertical constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_durationTypeLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_streakTypeLabel(vLabel)][_durationTypeLabel(vLabel)][_startTimeLabel(vLabel)]" options:0 metrics:metrics views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|" options:0 metrics:metrics views:viewDictionary]];
                                      
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_photoImageView]|" options:0 metrics:metrics views:viewDictionary]];
    
    
    // add horizontal constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.50f
                                                                  constant:0.0f]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.50f
                                                                  constant:0.0f]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_mapView]|" options:0 metrics:metrics views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_photoImageView]|" options:0 metrics:metrics views:viewDictionary]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_streakTypeLabel][_photoImageView]" options:0 metrics:metrics views:viewDictionary]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_durationTypeLabel][_photoImageView]" options:0 metrics:metrics views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_startTimeLabel][_photoImageView]" options:0 metrics:metrics views:viewDictionary]];
    
    
}

#pragma mark -
#pragma mark - awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark -
#pragma mark - setSelected
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark - getter methods
- (UILabel *)streakTypeLabel {
    if (!_streakTypeLabel) {
        _streakTypeLabel = [UILabel new];
        _streakTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _streakTypeLabel;
}

- (UILabel *)durationTypeLabel {
    if (!_durationTypeLabel) {
        _durationTypeLabel = [UILabel new];
        _durationTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _durationTypeLabel;
}

- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [UILabel new];
        _startTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _startTimeLabel;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [UIImageView new];
        _photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _photoImageView;
}

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [MKMapView new];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _mapView;
}
@end

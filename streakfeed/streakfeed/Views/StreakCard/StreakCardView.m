//
//  StreakCardView.m
//  streakfeed
//
//  Created by Ryan Badilla on 6/26/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import "StreakCardView.h"
#import "UIColor+StreakFeed.h"
#import "kConstants.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kLabelHeight = 16.0f;

@implementation StreakCardView

#pragma mark -
#pragma mark - initialization
- (instancetype)init {
    self = [super init];
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark -
#pragma mark - layout
- (void)layoutSubviews {
    [self setupShadows];
}


#pragma mark -
#pragma mark - setup
- (void)setup {
    [self setupView];
    [self setupConstraints];
}


- (void)setupView {
    [self addSubview:[self streakTypeLabel]];
    [self addSubview:[self durationTypeLabel]];
    [self addSubview:[self startTimeLabel]];
    
    [self addSubview:[self photoImageView]];
}



- (void)setupConstraints {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_streakTypeLabel, _durationTypeLabel, _startTimeLabel, _photoImageView);
    NSDictionary *metrics = @{@"vLabel" : @(kLabelHeight),
                              @"vBuffer" :@(4),
                              @"hBuffer" :@(10)};
    
    // add vertical constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_durationTypeLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_streakTypeLabel(vLabel)]-vBuffer-[_durationTypeLabel(vLabel)]-vBuffer-[_startTimeLabel(vLabel)]" options:0 metrics:metrics views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_photoImageView]|" options:0 metrics:metrics views:viewDictionary]];
    
    
    // add horizontal constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_photoImageView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.50f
                                                      constant:0.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hBuffer-[_streakTypeLabel][_photoImageView]|" options:0 metrics:metrics views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hBuffer-[_durationTypeLabel][_photoImageView]|" options:0 metrics:metrics views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hBuffer-[_startTimeLabel][_photoImageView]|" options:0 metrics:metrics views:viewDictionary]];
    
    
}

- (void)setupShadows {
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 1;
    self.layer.shadowOffset = CGSizeMake(0, .5f);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.4;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}

#pragma mark -
#pragma mark - set background color with streakType
- (void)setBackgroundColorWithStreakType:(NSString *)streakType {
    if ([streakType isEqualToString:STREAKTYPE_CALM]) self.backgroundColor = [UIColor calmColor];
    else if ([streakType isEqualToString:STREAKTYPE_FOCUS]) self.backgroundColor = [UIColor focusColor];
    else if ([streakType isEqualToString:STREAKTYPE_TENSE]) self.backgroundColor = [UIColor tenseColor];
    else self.backgroundColor = [UIColor whiteColor];
}

#pragma mark -
#pragma mark - getter methods
- (UILabel *)streakTypeLabel {
    if (!_streakTypeLabel) {
        _streakTypeLabel = [UILabel new];
        _streakTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _streakTypeLabel.font = [UIFont fontWithName:GLOBAL_FONT_NAME_REGULAR size:GLOBAL_FONT_SIZE_CARD];
        _streakTypeLabel.textColor = [UIColor globalFontColor];
    }
    
    return _streakTypeLabel;
}

- (UILabel *)durationTypeLabel {
    if (!_durationTypeLabel) {
        _durationTypeLabel = [UILabel new];
        _durationTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _durationTypeLabel.font = [UIFont fontWithName:GLOBAL_FONT_NAME size:GLOBAL_FONT_SIZE_CARD];
        _durationTypeLabel.textColor = [UIColor globalFontColor];
    }
    
    return _durationTypeLabel;
}

- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [UILabel new];
        _startTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _startTimeLabel.font = [UIFont fontWithName:GLOBAL_FONT_NAME size:GLOBAL_FONT_SIZE_CARD];
        _startTimeLabel.textColor = [UIColor globalFontColor];
    }
    
    return _startTimeLabel;
}

- (UIImageViewAligned *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [UIImageViewAligned new];
        _photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _photoImageView;
}

@end

//
//  StreakCardTableViewCell.m
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import "StreakCardTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat kVerticalMargin = 6.0f;
static CGFloat kHorizontalMargin = 8.0f;

@interface StreakCardTableViewCell()

@end

@implementation StreakCardTableViewCell

#pragma mark - 
#pragma mark - initialization
- (instancetype)init {
    self = [super init];
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
#pragma mark - layout
- (void)layoutSubviews {
   // [self setupShadows];
}

#pragma mark -
#pragma mark - setup
- (void)setup {
    [self setupView];
    [self setupConstraints];
}


- (void)setupView {
    [self.contentView addSubview:[self streakCardView]];
}



- (void)setupConstraints {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_streakCardView);
    NSDictionary *metrics = @{@"hStreakCardView" : @(kHorizontalMargin),
                              @"vStreakCardView" : @(kVerticalMargin)};
    
    // setup vertical constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vStreakCardView-[_streakCardView]-vStreakCardView-|" options:0 metrics:metrics views:viewsDictionary]];
    
    
    // setup horizontal constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hStreakCardView-[_streakCardView]|" options:0 metrics:metrics views:viewsDictionary]];
    
}

- (void)setupShadows {
    _streakCardView.layer.masksToBounds = NO;
    _streakCardView.layer.cornerRadius = 1;
    _streakCardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    _streakCardView.layer.shadowRadius = 1;
    _streakCardView.layer.shadowOpacity = 0.2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_streakCardView.bounds];
    _streakCardView.layer.shadowPath = path.CGPath;
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
- (StreakCardView *)streakCardView {
    if (!_streakCardView) {
        _streakCardView = [[StreakCardView alloc] init];
        _streakCardView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _streakCardView;
}
@end

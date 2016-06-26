//
//  StreakFeedViewController.m
//  
//
//  Created by Ryan Badilla on 6/20/16.
//
//

#import "StreakFeedViewController.h"
#import "StreakCardTableViewCell.h"
#import "RESTHelper.h"
#import "kConstants.h"
#import "kErrorConstants.h"
#import "StreakCardModel.h"
#import "UIColor+StreakFeed.h"
#import <MapKit/MapKit.h>
#import <NSDate+Helper.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIScrollView+InfiniteScroll.h>
#import <MBProgressHUD.h>
#import <QuartzCore/QuartzCore.h>

static NSInteger const kDaysFetchCount  = 1;
static CGFloat const kTableCellHeight   = 100.0f;
static CGFloat const kTableHeaderHeight = 40.0f;

static NSString *const kTableViewCellStreakCardID = @"StreakCardCell";
static NSString *const kTableViewCellEmptyID = @"EmptyTableViewCell";

@interface StreakFeedViewController ()

// uiviews for no connection found
@property (nonatomic, strong) UILabel *noConnectionLabel;
@property (nonatomic, strong) UIButton *retryConnectionButton;


// constraints
@property (nonatomic, strong) NSLayoutConstraint *vConstraintNoConnectionLabel;
@property (nonatomic, strong) NSLayoutConstraint *hConstraintRetryConnectionButton;
@property (nonatomic, strong) NSArray *vConstraintsLabelAndButton;
@property (nonatomic, strong) NSArray *hConstraintsNoConnectionLabel;
@property (nonatomic, strong) NSArray *hConstraintsRetryConnectionButton;


@end

@implementation StreakFeedViewController

#pragma mark -
#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark -
#pragma mark - setup
- (void)setup {
    [self setupView];
    [self setupConstraints];
    [self setupNavigationBar];
    [self fetchInitialData];
}

- (void)setupView {
    [self.view addSubview:[self tableView]];
}

- (void)setupConstraints {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView);
    NSDictionary *metrics = @{@"vBuffer" : @(20)};
    
    // setup vertical constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:viewsDictionary]];
    
    // setup horizontal constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:viewsDictionary]];
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor navigationBarColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.title = NSLocalizedString(@"Streak Feed", nil);
    NSShadow *shadow = [[NSShadow alloc] init];
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [UIColor colorWithWhite:1.0f alpha:1.0f], NSForegroundColorAttributeName,
        shadow, NSShadowAttributeName,
        shadow, NSShadowAttributeName,
        [UIFont fontWithName:GLOBAL_FONT_NAME_LIGHT size:GLOBAL_FONT_SIZE_NAV_BAR], NSFontAttributeName,
        nil];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
}


#pragma mark -
#pragma mark - setup no connection views
- (void)addNoConnectionViews {
    // add views to viewcontroller if necessary
    if (!_noConnectionLabel || ![_noConnectionLabel superview])
        [self.view addSubview:[self noConnectionLabel]];
    if (!_retryConnectionButton || ![_retryConnectionButton superview])
        [self.view addSubview:[self retryConnectionButton]];
    
    
    // setup constraints if necessary
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_noConnectionLabel, _retryConnectionButton, self.view);
    NSDictionary *metrics = @{@"vLabel": @(20),
                              @"vButton" : @(36),
                              @"hButton" : @(80),
                              @"vBuffer" : @(12)};
    
    // setup vertical constraints
    if (!_vConstraintNoConnectionLabel) {
        _vConstraintNoConnectionLabel = [NSLayoutConstraint constraintWithItem:_noConnectionLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0.0];
        
        [self.view addConstraint:_vConstraintNoConnectionLabel];
        
    }

    if (!_vConstraintsLabelAndButton) {
        _vConstraintsLabelAndButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_noConnectionLabel(vLabel)]-vBuffer-[_retryConnectionButton(vButton)]" options:0 metrics:metrics views:viewsDictionary];
        
        [self.view addConstraints:_vConstraintsLabelAndButton];
    }

    
    // setup horizontal constraints
    if (!_hConstraintRetryConnectionButton) {
        _hConstraintRetryConnectionButton = [NSLayoutConstraint constraintWithItem:_retryConnectionButton
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0f
                                                                          constant:0.0];
        
        [self.view addConstraint:_hConstraintRetryConnectionButton];
    }
    
    if (!_hConstraintsNoConnectionLabel) {
        _hConstraintsNoConnectionLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_noConnectionLabel]-|" options:0 metrics:metrics views:viewsDictionary];
        
        [self.view addConstraints:_hConstraintsNoConnectionLabel];
    }
    
    if (!_hConstraintsRetryConnectionButton) {
        _hConstraintsRetryConnectionButton = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_retryConnectionButton(hButton)]" options:0 metrics:metrics views:viewsDictionary];
        
        [self.view addConstraints:_hConstraintsRetryConnectionButton];
    }
}

- (void)removeNoConnectionViews {
    if (_vConstraintNoConnectionLabel) {
        [self.view removeConstraint:_vConstraintNoConnectionLabel];
        _vConstraintNoConnectionLabel = nil;
    }
    
    if (_vConstraintsLabelAndButton) {
        [self.view removeConstraints:_vConstraintsLabelAndButton];
        _vConstraintsLabelAndButton = nil;
    }
    
    if (_hConstraintRetryConnectionButton) {
        [self.view removeConstraint:_hConstraintRetryConnectionButton];
        _hConstraintRetryConnectionButton = nil;
    }
    
    if (_hConstraintsNoConnectionLabel) {
        [self.view removeConstraints:_hConstraintsNoConnectionLabel];
        _hConstraintsNoConnectionLabel = nil;
    }
    
    if (_hConstraintsRetryConnectionButton) {
        [self.view removeConstraints:_hConstraintsRetryConnectionButton];
        _hConstraintsRetryConnectionButton = nil;
    }
    
    
    if (_noConnectionLabel) {
        if ([_noConnectionLabel superview]) [_noConnectionLabel removeFromSuperview];
        _noConnectionLabel = nil;
    }
    
    if (_retryConnectionButton) {
        if ([_retryConnectionButton superview]) [_retryConnectionButton removeFromSuperview];
        _retryConnectionButton = nil;
    }
}



#pragma mark -
#pragma mark - loadData
- (void)fetchInitialData {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    progressHud.labelText = NSLocalizedString(@"Loading...", nil);

    NSMutableArray *dates = [self daysDaysFromStartDate:[NSDate date] daysCount:kDaysFetchCount];
    [self fetchDataWithDates:dates onCompletion:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error) {
            _tableView.hidden = YES;
            [self addNoConnectionViews];
        } else {
            _tableView.hidden = NO;
            [self removeNoConnectionViews];
        }
    }];
}


- (void)fetchDataWithDates:(NSArray *)datesArray onCompletion:(CompletionWithErrorBlock)completion{
    [RESTHelper getDictionaryOfStreakCardsAndDateKeysForDates:datesArray onCompletion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if (!_dateArray) _dateArray = [NSMutableArray new];
            if (!_dataDictionary) _dataDictionary = [NSMutableDictionary new];
            
            [_dateArray addObjectsFromArray:datesArray];
            [_dataDictionary addEntriesFromDictionary:dictionary];
            
            [_tableView reloadData];
            
        } else {
            [self showAlertViewControllerWithTitle:kAlertTitle
                                           message:error.localizedDescription
                                       actionTitle:kAlertCancelActionTitle];
        }
        
        if (completion) completion(error);
    }];
}


#pragma mark -
#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - (10 * 2), kTableHeaderHeight)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor navigationBarColor];
    label.text = [_dateArray[section] stringWithFormat:@"MMMM d, yyyy"];
    label.font = [UIFont fontWithName:GLOBAL_FONT_NAME_REGULAR size:GLOBAL_FONT_SIZE_TABLEHEADER];

    UIView *separatorLineBelow = [[UIView alloc] initWithFrame:CGRectMake(10, kTableHeaderHeight, tableView.frame.size.width, 1)];
    separatorLineBelow.backgroundColor = [UIColor navigationBarColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kTableHeaderHeight)];
    view.backgroundColor = [UIColor backgroundColor];
    
    [view addSubview:label];
    [view addSubview:separatorLineBelow];
    
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark - UITableView data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *date = _dateArray[indexPath.section];
    NSArray *cardArray = _dataDictionary[[date string]];
    
    // show streak cards
    if (cardArray && [cardArray count] > 0) {
        StreakCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellStreakCardID];
        
        if (!cell) {
            cell = [[StreakCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:kTableViewCellStreakCardID];
        }
        
        [self setupStreakCardTableViewCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor backgroundColor];
        
        return cell;
    } else { // show no streaks
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellEmptyID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellEmptyID];
        }
    
        [self setupEmptyTableViewCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor backgroundColor];
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dateArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *date = _dateArray[section];
    NSArray *cardArray = _dataDictionary[[date string]];
    
    return (cardArray && [cardArray count] > 0) ? [cardArray count] : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableCellHeight;
}

#pragma mark -
#pragma mark - setup cells
- (void)setupEmptyTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = NSLocalizedString(@"No Streaks for Today", nil);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupStreakCardTableViewCell:(StreakCardTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = _dateArray[indexPath.section];
    NSArray *cardArray = _dataDictionary[[date string]];
    StreakCardModel *streakCard = cardArray[indexPath.row];
    
    if (streakCard) {
        NSString *streakTypeString = streakCard.streakType.type;
        NSString *startTimeString = [streakCard.streakType.start_at stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        
        NSString *durationString = [NSString stringWithFormat:@"%ld min", lround([streakCard.streakType.stop_at timeIntervalSinceDate:streakCard.streakType.start_at] / 60)];
        
        cell.streakCardView.streakTypeLabel.text = streakTypeString;
        cell.streakCardView.startTimeLabel.text = startTimeString;
        cell.streakCardView.durationTypeLabel.text = durationString;
        [cell.streakCardView setBackgroundColorWithStreakType:streakTypeString];

        
        // setup photos if necessary
        if (streakCard.photo && streakCard.photo.url) {
            NSURL *photoURL = [NSURL URLWithString:streakCard.photo.url];
            [cell.streakCardView.photoImageView sd_setImageWithURL:photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    [cell.streakCardView.photoImageView setAlignRight:YES];
                }
            }];

        } else if (streakCard.location) {
            double latitude = [streakCard.location.latitude doubleValue];
            double longitude = [streakCard.location.longitude doubleValue];
            long int mapHeight = lround(floorf(cell.contentView.bounds.size.height));
            long int mapWidth = lround(floorf(cell.contentView.bounds.size.width * 0.5));
            NSString *mapSize = [NSString stringWithFormat:@"zoom=10&size=%ldx%ld", mapWidth, mapHeight];
            
            NSString *staticMapURL = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&%@&sensor=true",latitude, longitude, mapSize];
            
            
            NSURL *mapURL = [NSURL URLWithString:[staticMapURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            
            [cell.streakCardView.photoImageView setShowActivityIndicatorView:YES];
            [cell.streakCardView.photoImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [cell.streakCardView.photoImageView sd_setImageWithURL:mapURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    [cell.streakCardView.photoImageView setAlignRight:YES];
                }
            }];
        } else {
            [cell.streakCardView.photoImageView setImage:nil];
        }
    }
}

#pragma mark -
#pragma mark - date helpers
- (NSMutableArray *)daysDaysFromStartDate:(NSDate *)date daysCount:(NSInteger)days{
    if (days > 0) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *startDate = [date beginningOfDay];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:days];

        for (NSInteger index = 0; index < days; index++) {
            [dateComponents setDay:-index];
            NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:startDate options:0];
            [array addObject:newDate];
        }
        
        return array;
        
    }
    return nil;
}

#pragma mark -
#pragma mark - alertError
- (void)showAlertViewControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                             actionTitle:(NSString *)actionTitle {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:actionTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alertViewController addAction:cancelAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark - didRecieveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - getter method
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[StreakCardTableViewCell class] forCellReuseIdentifier:kTableViewCellStreakCardID];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellEmptyID];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        if (!_dateArray) _dateArray = [NSMutableArray new];
        if (!_dataDictionary) _dataDictionary = [NSMutableDictionary new];
        
        __weak typeof(_dateArray) dateArray = _dateArray;
        __weak typeof(self) weakSelf = self;
        [_tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
            if (dateArray) {
                // get previous days
                NSDate *date = [dateArray lastObject];
                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                [dateComponents setDay:-1];
                NSDate *previousDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
                NSMutableArray *previousDatesArray = [weakSelf daysDaysFromStartDate:previousDate daysCount:kDaysFetchCount];
                
                // fetch data
                [weakSelf fetchDataWithDates:previousDatesArray onCompletion:^(NSError *error) {
                    if (!error) [tableView reloadData];
                    [tableView finishInfiniteScroll];
                }];
                
            } else {
                [tableView finishInfiniteScroll];
            }
            

        }];
    }
    
    return _tableView;
}

- (UILabel *)noConnectionLabel {
    if (!_noConnectionLabel) {
        _noConnectionLabel = [UILabel new];
        _noConnectionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _noConnectionLabel.text = NSLocalizedString(@"Could not connect to server.", nil);
        _noConnectionLabel.textAlignment = NSTextAlignmentCenter;
        _noConnectionLabel.font = [UIFont fontWithName:GLOBAL_FONT_NAME size:GLOBAL_FONT_SIZE_NAV_BAR];
        _noConnectionLabel.textColor = [UIColor navigationBarColor];
        
    }
    
    return _noConnectionLabel;
}

- (UIButton *)retryConnectionButton {
    if (!_retryConnectionButton) {
        _retryConnectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryConnectionButton.translatesAutoresizingMaskIntoConstraints = NO;
        _retryConnectionButton.titleLabel.font = [UIFont fontWithName:GLOBAL_FONT_NAME size:GLOBAL_FONT_SIZE_CARD];
        [_retryConnectionButton setTitle:NSLocalizedString(@"Retry", nil) forState:UIControlStateNormal];
        [_retryConnectionButton setTitle:NSLocalizedString(@"Retry", nil) forState:UIControlStateHighlighted];
        [_retryConnectionButton setTitle:NSLocalizedString(@"Retry", nil) forState:UIControlStateSelected];
        [_retryConnectionButton setTitleColor:[UIColor navigationBarColor] forState:UIControlStateNormal];
        [_retryConnectionButton setTitleColor:[UIColor navigationBarColor] forState:UIControlStateHighlighted];
        [_retryConnectionButton setTitleColor:[UIColor navigationBarColor] forState:UIControlStateSelected];
        
        _retryConnectionButton.layer.borderWidth = 0.5f;
        _retryConnectionButton.layer.cornerRadius = 10.0f;
        _retryConnectionButton.layer.borderColor = [[UIColor navigationBarColor] CGColor];
        
        [_retryConnectionButton addTarget:self
                                   action:@selector(fetchInitialData)
                         forControlEvents:UIControlEventTouchDown];
    }
    
    return _retryConnectionButton;
}

@end


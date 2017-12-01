#import "ExchangeMoneyView.h"
#import "ExchangeMoneyViewData.h"
#import "KeyboardObserverImpl.h"
#import "ExchangeMoneyCurrencyViewData.h"
#import "GalleryPreviewData.h"
#import "GalleryPreviewPageData.h"
#import "KeyboardData.h"
#import "CurrencyRateCell.h"
#import "UIView+Properties.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString * const kCurrencyRateCellId = @"kCurrencyRateCellId";

CGFloat const kFontSize = 34.0;

@interface ExchangeMoneyView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *currencyAmountTextField;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) ExchangeMoneyViewData *viewData;
@end

@implementation ExchangeMoneyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.scrollEnabled = NO;
        [self.tableView registerClass:[CurrencyRateCell class] forCellReuseIdentifier:kCurrencyRateCellId];
        
        self.currencyAmountTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.currencyAmountTextField.font = [UIFont systemFontOfSize:kFontSize];
        self.currencyAmountTextField.textColor = [UIColor whiteColor];
        self.currencyAmountTextField.textAlignment = NSTextAlignmentRight;
        self.currencyAmountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.tableView];
        [self addSubview:self.currencyAmountTextField];
        [self addSubview:self.activityIndicator];
        
        self.backgroundImageView.backgroundColor = [UIColor blueColor];
        
        [self.backgroundImageView setImageWithURL:[NSURL URLWithString:@"https://picsum.photos/800/600"]];
    }
    
    return self;
}

// MARK: - ExchangeMoneyView

- (void)focusOnStart {
    [self.currencyAmountTextField becomeFirstResponder];
}

- (void)updateKeyboardData:(KeyboardData *)keyboardData {
    self.keyboardHeight = keyboardData.size.height;

    [self setNeedsLayout];
    [self.tableView reloadData];
}

- (void)setViewData:(ExchangeMoneyViewData *)viewData {
    _viewData = viewData;
    
    [self.tableView reloadData];
}

- (void)startActivity {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)stopActivity {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
}

// MARK: - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    self.activityIndicator.center = self.center;
    
    self.tableView.frame = [self tableViewFrame];
    
    self.currencyAmountTextField.width = 190;
    self.currencyAmountTextField.height = 70;
    self.currencyAmountTextField.right = 360;
    self.currencyAmountTextField.top = 16;
}

- (CGRect)tableViewFrame {
    CGRect frame = self.bounds;
    frame.size.height = frame.size.height - self.keyboardHeight;
    return frame;
}
    
// MARK: - UITableViewDelegate
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableViewFrame].size.height / 2;
}
    
// MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CurrencyRateCell *cell;
    
    
    if (indexPath.row == 0) {
        cell = [[CurrencyRateCell alloc] initWithStyle:CurrencyRateCellStyleLight reuseIdentifier:kCurrencyRateCellId];
        [self configureCell:cell
                      model:self.viewData.sourceData
               exchangeType:CurrencyExchangeSourceType];
    } else {
        cell = [[CurrencyRateCell alloc] initWithStyle:CurrencyRateCellStyleDark reuseIdentifier:kCurrencyRateCellId];
        [self configureCell:cell
                      model:self.viewData.targetData
               exchangeType:CurrencyExchangeTargetType];
    }
    
    return cell;
}

// MARK: - Private

- (void)configureCell:(CurrencyRateCell *)cell
                model:(GalleryPreviewData *)model
         exchangeType:(CurrencyExchangeType)currencyExchangeType
{
    [cell updateWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    [cell setOnPageChange:^(NSInteger current, NSInteger total) {
        weakSelf.onPageChange(currencyExchangeType, current, total);
    }];
}

@end

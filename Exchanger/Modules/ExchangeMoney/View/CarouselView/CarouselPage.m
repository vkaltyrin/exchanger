#import "ConvenientObjC.h"
#import "CarouselPage.h"
#import "CarouselPageData.h"
#import "UIView+Properties.h"
#import "UITextField+Configuration.h"
#import "ObservableTextField.h"

CGFloat const kBigFontSize = 34.0;
CGFloat const kSmallFontSize = 12.0;

NS_ASSUME_NONNULL_BEGIN

@interface CarouselPage()
@property (nonatomic, strong) UILabel *currencyTitleLabel;
@property (nonatomic, strong) UILabel *remainderLabel;
@property (nonatomic, strong) UILabel *currencyRateLabel;
@property (nonatomic, strong) ObservableTextField *textField;
@end

@implementation CarouselPage
    
// MARK: - Init
    
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.currencyTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.currencyTitleLabel.font = [UIFont systemFontOfSize:kBigFontSize];
        self.currencyTitleLabel.textColor = [UIColor whiteColor];
        self.currencyTitleLabel.accessibilityIdentifier = @"currencyTitle";
        
        self.remainderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.remainderLabel.font = [UIFont systemFontOfSize:kSmallFontSize];
        self.remainderLabel.accessibilityIdentifier = @"remainder";
        
        self.currencyRateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.currencyRateLabel.font = [UIFont systemFontOfSize:kSmallFontSize];
        self.currencyRateLabel.textColor = [UIColor whiteColor];
        self.currencyRateLabel.textAlignment = NSTextAlignmentRight;
        self.currencyRateLabel.accessibilityIdentifier = @"currencyRate";
        
        self.textField = [[ObservableTextField alloc] init];
        [self.textField setConfiguration:[TextFieldConfiguration inputConfiguration]];
        
        __weak typeof(self) welf = self;
        self.textField.onBeginEditing = ^{
            safeBlock(welf.onFocus);
        };
        
        [self addSubview:self.currencyTitleLabel];
        [self addSubview:self.remainderLabel];
        [self addSubview:self.currencyRateLabel];
        [self addSubview:self.textField];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
    
// MARK: - Helpers
    
- (UIEdgeInsets)contentInsets {
    return UIEdgeInsetsMake(16, 16, 16, 16);
}

// MARK: - Public
    
- (void)setViewData:(CarouselPageData *)data {
    self.accessibilityIdentifier = data.accessibilityId;
    self.currencyTitleLabel.text = data.currencyTitle;
    self.remainderLabel.text = data.remainder;
    self.currencyRateLabel.text = data.rate;
    self.textField.onTextChange = data.onTextChange;
    [self.textField setAttributedText:data.input];
    
    switch (data.remainderStyle) {
        case CarouselPageRemainderStyleNormal:
            self.remainderLabel.textColor = [UIColor whiteColor];
            break;
        case CarouselPageRemainderStyleDeficiency:
            self.remainderLabel.textColor = [UIColor redColor];
            break;
    }
}
    
- (void)prepareForReuse {
    self.currencyTitleLabel.text = nil;
    [self.textField setText:nil];
    self.remainderLabel.text = nil;
    self.currencyRateLabel.text = nil;
}

// MARK: - Public

- (void)focus {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.textField becomeFirstResponder];
        safeBlock(self.onFocus);
    }];
}
    
// MARK: - Private
    
- (void)layoutSubviews {
    [super layoutSubviews];
    
    let contentFrame = UIEdgeInsetsInsetRect(self.bounds, [self contentInsets]);
    let verticalOffsetBetweenLabels = 8.f;
    
    let currencyTitleLabelSize = [self.currencyTitleLabel sizeThatFits:contentFrame.size];
    self.currencyTitleLabel.size = currencyTitleLabelSize;
    self.currencyTitleLabel.left = contentFrame.origin.x;
    self.currencyTitleLabel.top = contentFrame.origin.y;
    
    let remainderLabelSize = [self.remainderLabel sizeThatFits:contentFrame.size];
    self.remainderLabel.size = remainderLabelSize;
    self.remainderLabel.top = self.currencyTitleLabel.bottom + verticalOffsetBetweenLabels;
    self.remainderLabel.left = self.currencyTitleLabel.x;
    
    self.textField.width = 190;
    self.textField.height = self.currencyTitleLabel.height;
    self.textField.right = contentFrame.origin.x + contentFrame.size.width;
    self.textField.top = self.currencyTitleLabel.top;
    
    let currencyRateLabelSize = [self.currencyRateLabel sizeThatFits:contentFrame.size];
    self.currencyRateLabel.size = currencyRateLabelSize;
    self.currencyRateLabel.right = self.textField.right;
    self.currencyRateLabel.top = self.remainderLabel.top;
}

@end

NS_ASSUME_NONNULL_END

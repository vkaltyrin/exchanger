#import <UIKit/UIKit.h>
#import "CurrencyExchangeType.h"
#import "CarouselPageData.h"
#import "ExchangeMoneyViewInput.h"

@class KeyboardData;
@class ExchangeMoneyViewData;

@interface ExchangeMoneyView : UIView
@property (nonatomic, assign) UIEdgeInsets contentInsets;

- (void)setOnExchangeTypeChange:(OnExchangeTypeChange _Nullable )onExchangeTypeChange;

- (void)setOnPageChange:(void (^_Nullable)(CurrencyExchangeType, NSInteger))onPageChange;
- (void)setActiveCurrencyExchangeType:(CurrencyExchangeType)exchangeType;
- (void)focusOnStart;
- (void)updateKeyboardData:(nonnull KeyboardData *)keyboardData;
- (void)setViewData:(nonnull ExchangeMoneyViewData *)viewData;
- (void)startActivity;
- (void)stopActivity;
@end

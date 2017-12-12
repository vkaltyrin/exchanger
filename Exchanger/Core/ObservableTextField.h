#import <UIKit/UIKit.h>
#import "TextFieldConfiguration.h"
#import "FormatterResultData.h"

typedef FormatterResultData *(^TextFieldAttributedStringFormatter)(NSString *text);
typedef void(^OnTextChange)(NSString *);

@interface ObservableTextField : UIView
@property (nonatomic, strong) TextFieldAttributedStringFormatter formatter;
@property (nonatomic, strong) OnTextChange onTextChange;

- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("initWithFrame not available")));

- (void)setConfiguration:(TextFieldConfiguration *)configuration;

- (void)setText:(NSString *)text;

@end

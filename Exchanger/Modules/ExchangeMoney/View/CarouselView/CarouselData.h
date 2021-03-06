#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CarouselPageData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarouselData : NSObject
    
@property (nonatomic, strong, readonly) NSArray<CarouselPageData *> *pages;
@property (nonatomic, assign, readonly) NSInteger currentPage;
    
- (instancetype)initWithPages:(NSArray<CarouselPageData *> *)pages
                  currentPage:(NSInteger)currentPage;
    
@end

NS_ASSUME_NONNULL_END

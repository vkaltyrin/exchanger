#import "ExchangeMoneyServiceImpl.h"
#import "Wallet.h"
#import "SafeBlocks.h"

@implementation ExchangeMoneyServiceImpl

// MARK: - ExchangeMoneyService

- (void)exchangeWithUser:(User *)user
             moneyAmount:(NSNumber *)moneyAmount
          sourceCurrency:(Currency *)sourceCurrency
          targetCurrency:(Currency *)targetCurrency
                onResult:(void (^)(ExchangeMoneyResult *))onResult
{
    __weak typeof(self) welf = self;
    [self convertedCurrencyWithSourceCurrency:sourceCurrency
                               targetCurrency:targetCurrency
                                    onConvert:^(Currency *convertedCurrency)
    {
        
        Wallet *sourceWallet = [welf sourceWalletWith:user
                                                 currency:sourceCurrency
                                              moneyAmount:moneyAmount];
        
        Wallet *walletDiff = [welf exchangeMoneyAmount:moneyAmount
                                        withCurrency:convertedCurrency];
        
        Wallet *targetWallet = [welf targetWalletWith:user
                                                 currency:targetCurrency
                                               walletDiff:walletDiff];
        
        ExchangeMoneyResult *result = [[ExchangeMoneyResult alloc] initWithSourceWallet:sourceWallet
                                                                           targetWallet:targetWallet];
        block(onResult, result);
    }];
}

- (void)convertedCurrencyWithSourceCurrency:(Currency *)sourceCurrency
                             targetCurrency:(Currency *)targetCurrency
                                  onConvert:(void (^)(Currency *))onConvert
{
    Currency *result = [[Currency alloc] init];
    result.currencyType = targetCurrency.currencyType;
    result.rate = [self calculateExchangeRateWithSourceCurrency:sourceCurrency targetCurrency:targetCurrency];
    
    block(onConvert, result);
}

- (void)exchangeWallet:(Wallet *)wallet
        targetCurrency:(Currency *)currency
              onResult:(void (^)(Wallet *wallet))onResult
{
    __weak typeof(self) welf = self;
    [self convertedCurrencyWithSourceCurrency:wallet.currency
                               targetCurrency:currency
                                    onConvert:^(Currency *convertedCurrency)
    {
        Wallet *resultWallet = [welf exchangeMoneyAmount:wallet.amount
                                                withCurrency:convertedCurrency];
        
        block(onResult, resultWallet);
    }];
}

// MARK: - Private

- (NSNumber *)calculateExchangeRateWithSourceCurrency:(Currency *)sourceCurrency
                                       targetCurrency:(Currency *)targetCurrency
{
    return @(targetCurrency.rate.floatValue / sourceCurrency.rate.floatValue);
}

- (Wallet *)sourceWalletWith:(User *)user
                    currency:(Currency *)currency
                 moneyAmount:(NSNumber *)moneyAmount
{
    Wallet *userSourceWallet = [user walletWithCurrencyType:currency.currencyType];
    
    return [[Wallet alloc] initWithCurrency:currency
                                    amount:@(userSourceWallet.amount.doubleValue - moneyAmount.doubleValue)];
}

- (Wallet *)targetWalletWith:(User *)user
                    currency:(Currency *)currency
                  walletDiff:(Wallet *)walletDiff
{
    Wallet *userTargetWallet = [user walletWithCurrencyType:currency.currencyType];
    
    return [[Wallet alloc] initWithCurrency:currency
                                     amount:@(userTargetWallet.amount.doubleValue + walletDiff.amount.doubleValue)];
}

- (Wallet *)exchangeMoneyAmount:(NSNumber *)moneyAmount
                   withCurrency:(Currency *)currency
{
    return [[Wallet alloc] initWithCurrency:currency
                                     amount:@(moneyAmount.floatValue * currency.rate.floatValue)];
}


@end

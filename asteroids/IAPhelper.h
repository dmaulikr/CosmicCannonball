//
//  IAPhelper.h
//  Video Roulette
//
//  Created by Eric Schmitt on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

@interface IAPhelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {

    NSSet * _productIdentifiers;    
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
}

@property (retain) NSSet *productIdentifiers;
@property (retain) NSArray * products;
@property (retain) NSMutableSet *purchasedProducts;
@property (retain) SKProductsRequest *request;

- (void)buyProductIdentifier:(NSString *)productIdentifier;
- (void)requestProducts;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;

@end

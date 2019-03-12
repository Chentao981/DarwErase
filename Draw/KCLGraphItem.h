//
//  KCLGraphItem.h
//  Draw
//
//  Created by Chentao on 2019/3/11.
//  Copyright © 2019 Chentao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KCLGraphItemType) {
    KCLGraphItemTypeLine = 1,
    KCLGraphItemTypeText = 2,
    KCLGraphItemTypeErase = 3,
};

@interface KCLGraphItem : NSObject

@property(nonatomic,assign)KCLGraphItemType type;

@property(nonatomic,strong)UIColor *color;


@end

NS_ASSUME_NONNULL_END

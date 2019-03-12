//
//  KCLGraphText.h
//  Draw
//
//  Created by Chentao on 2019/3/12.
//  Copyright © 2019 Chentao. All rights reserved.
//

#import "KCLGraphItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCLGraphText : KCLGraphItem

@property(nonatomic,assign)CGRect frame;

@property(nonatomic,copy)NSString *string;

@end

NS_ASSUME_NONNULL_END

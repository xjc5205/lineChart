//
//  lineChartController.h
//  lineChartDemo
//
//  Created by hxxc on 2020/4/14.
//  Copyright © 2020 xjc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    lineChartTypePositive = 0,
    lineChartTypeDecimal,
    lineChartTypePercentage,
    lineChartTypeNegative
}lineChartType;

NS_ASSUME_NONNULL_BEGIN

@interface lineChartController : UIViewController

@property(nonatomic,assign)lineChartType lineType;

@end

NS_ASSUME_NONNULL_END

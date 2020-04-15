//
//  Helper.m
//
//  Created by hxxc on 2019/2/22.
//  Copyright © 2019年 xjc. All rights reserved.
//

#import "Helper.h"
@implementation Helper

+ (NSString *)notRounding:(NSString *)price afterPoint:(NSInteger)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *roundedOunces;
    roundedOunces = [[NSDecimalNumber decimalNumberWithString:price] decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


@end

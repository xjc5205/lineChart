//
//  Helper.h
//
//  Created by hxxc on 2019/2/22.
//  Copyright © 2019年 xjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

//截取保留两位小数
+(NSString *)notRounding:(NSString *)price afterPoint:(NSInteger)position;

@end

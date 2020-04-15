//
//  FHXTools.h
//  lineChartDemo
//
//  Created by hxxc on 2019/2/22.
//  Copyright © 2019年 xjc. All rights reserved.
//

#ifndef FHXTools_h
#define FHXTools_h


//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//苹方字体
#define PINGFANGSEMIBOLD  @"PingFangSC-Semibold"//苹方中粗体
#define PINGFANGMEDIUM  @"PingFangSC-Medium" //苹方中黑体
//判断设备的操作系统版本
#define IOS_VERSION [[UIDevice currentDevice].systemVersion doubleValue]
//rgb颜色
#define HXRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#endif /* FHXTools_h */

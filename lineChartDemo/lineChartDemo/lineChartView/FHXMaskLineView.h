//
//  FHXMaskLineView.h
//
//  Created by hxxc on 2019/2/22.
//  Copyright © 2019年 xjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FHXMaskLineViewDelegate <NSObject>

-(void)clickTopTypeAction:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FHXMaskLineView : UIView

@property(nonatomic,assign)NSInteger type;//1:人均产能 2:首投比率 3:总绩效 4:绩效比 5:各月份提佣趋势图 12:绩效比单独处理

@property(nonatomic,strong)NSString * titleStr;//标题
@property(nonatomic,strong)NSString * unitStr;//单位
@property(nonatomic,strong)UIColor * baseColor;//线条以及文字颜色
@property(nonatomic,strong)NSMutableArray * lineColorArray;//线条颜色
@property(nonatomic,strong)NSMutableArray * arrayY;//纵坐标
@property(nonatomic,strong)NSMutableArray * arrayX;//横坐标
@property(nonatomic,strong)NSMutableArray * typeArray;//底部类型
@property(nonatomic,strong)UIScrollView * bgScrollView;//滑动背景

@property(nonatomic,weak)id<FHXMaskLineViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

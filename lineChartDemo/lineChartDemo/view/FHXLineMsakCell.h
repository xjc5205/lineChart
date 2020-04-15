//
//  FHXLineMsakCell.h
//
//  Created by hxxc on 2019/2/22.
//  Copyright © 2019年 xjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHXMaskLineView.h"
#import "FHXChartNoDataView.h"

@protocol FHXLineMsakCellDelegate <NSObject>
@optional
-(void)switchSelectTypeAction:(NSInteger)type;
@end

NS_ASSUME_NONNULL_BEGIN

@interface FHXLineMsakCell : UITableViewCell<FHXMaskLineViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *dataBgView;

@property(nonatomic,strong)NSString * title;//标题
@property(nonatomic,strong)NSString * unitStr;//单位

//折线类型
@property(nonatomic,assign)NSInteger type;

@property(nonatomic,strong)NSMutableArray * dataArray;//数据源
@property(nonatomic,weak)id<FHXLineMsakCellDelegate>delegate;

@property(nonatomic,strong)FHXChartNoDataView * noDataView;
@end

NS_ASSUME_NONNULL_END

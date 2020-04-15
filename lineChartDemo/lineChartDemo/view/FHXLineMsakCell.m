//
//  FHXLineMsakCell.m
//  FinancerApp
//
//  Created by hxxc on 2019/2/22.
//  Copyright © 2019年 xjc. All rights reserved.
//

#import "FHXLineMsakCell.h"
#import "FHXSingleTrendModel.h"
#import "Masonry.h"
#import "FHXTools.h"

@implementation FHXLineMsakCell{
    
    FHXMaskLineView * maskLineView;
    NSMutableArray * arrayX;
    NSMutableArray * arrayY;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    
    if (dataArray.count == 0) {
        self.noDataView.hidden = NO;
        return;
    }else{
        
        self.noDataView.hidden = YES;
    }
    
    _dataArray = dataArray;
    for (FHXSingleTrendModel * model in _dataArray) {
        [arrayX addObject:model.x];
        [arrayY addObject:model.y];
    }
    
    CGFloat maxValue = [[arrayY valueForKeyPath:@"@max.floatValue"] floatValue];
    if (maxValue == 0) {
        self.noDataView.hidden = NO;
        return;
    }else{
        
        self.noDataView.hidden = YES;
    }
    maskLineView.arrayX = arrayX;
    maskLineView.arrayY = arrayY;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    arrayX = [NSMutableArray arrayWithCapacity:0];
    arrayY = [NSMutableArray arrayWithCapacity:0];
    maskLineView = [[FHXMaskLineView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 329)];
    maskLineView.delegate = self;
    [self.bgView addSubview:maskLineView];
    // Initialization code
}

-(void)setTitle:(NSString *)title{
    
    _title = title;
    maskLineView.titleStr = _title;
}
-(void)setUnitStr:(NSString *)unitStr{
    
    _unitStr = unitStr;
    maskLineView.unitStr = _unitStr;
}

-(void)setType:(NSInteger)type{
    
    _type = type;
    maskLineView.type = _type;
}

-(void)clickTopTypeAction:(NSInteger)tag{
    
    if ([self.delegate respondsToSelector:@selector(switchSelectTypeAction:)]) {
        [self.delegate switchSelectTypeAction:tag];
    }
}

- (void)setBgViewShadow{
    
    self.bgView.layer.masksToBounds = NO;
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.shadowColor = HXRGB(225, 225, 234).CGColor;//阴影颜色
    self.bgView.layer.shadowOpacity = 1.0;//阴影透明度
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);//阴影偏移量
    self.bgView.layer.shadowRadius = 5;//阴影半径
    self.bgView.layer.shouldRasterize = NO;
    CGRect  roundRect = CGRectMake(0, 0, SCREEN_WIDTH - 30, self.bounds.size.height - 11);
    self.bgView.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:roundRect cornerRadius:5] CGPath];
}

-(void)layoutSubviews{
    
    [self setBgViewShadow];
}

-(FHXChartNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[NSBundle mainBundle]loadNibNamed:@"FHXChartNoDataView" owner:self options:nil][0];
        _noDataView.frame = CGRectMake(0, 0, 128, 128);
        [self.bgView addSubview:_noDataView];
        _noDataView.hidden = YES;
        [_noDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.bgView);
            make.centerY.equalTo(self.bgView);
            make.width.equalTo(@128.0f);
            make.height.equalTo(@128.0f);
        }];
        
    }
    return _noDataView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

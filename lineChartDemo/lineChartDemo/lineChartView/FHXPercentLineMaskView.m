//
//  FHXPercentLineMaskView.m
//
//  Created by hxxc on 2019/2/22.
//  Copyright © 2019年 xjc. All rights reserved.
//

#import "FHXPercentLineMaskView.h"
#import "Masonry.h"
#import "FHXTools.h"
#import "UIColor+Extensions.h"
#import "FHXMaskLineView.h"

static NSInteger baseLineCount = 11;//纵坐标个数
@implementation FHXPercentLineMaskView{
    
    UILabel * titleLabel;//标题
    UIButton * arrowBtn;//标题箭头
    UILabel * unitLabel;//单位
    UILabel * desLabel1;//描述1
    UILabel * IdentifyLabel1;//颜色
    UILabel * desLabel2;//描述2
    UILabel * IdentifyLabel2;//颜色
    UILabel * desLabel3;//描述3
    UILabel * IdentifyLabel3;//颜色
    UIImageView * lastLineView;//最后一条背景线
    NSMutableArray * pointArray;//拐点数据
    NSMutableArray * xLabelArray;//横坐标
    NSMutableArray * btnArray;//按钮
    NSMutableArray * labelArray;//显示标签
    
    CGPoint lastPoint;//最后一个坐标点
    
    CGFloat maxValue;//y轴最大值
}

-(void)setTitleStr:(NSString *)titleStr{
    
    _titleStr = titleStr;
    [arrowBtn setTitle:titleStr forState:UIControlStateNormal];
    //[arrowBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -arrowBtn.imageView.frame.size.width, 0, arrowBtn.imageView.frame.size.width)];
    //[arrowBtn setImageEdgeInsets:UIEdgeInsetsMake(0, arrowBtn.titleLabel.bounds.size.width+5, 0, - arrowBtn.titleLabel.bounds.size.width)];
    //titleLabel.text = _titleStr;
}

-(void)setUnitStr:(NSString *)unitStr{
    
    _unitStr = unitStr;
    unitLabel.text = _unitStr;
}

-(void)setType:(NSInteger)type{
    
    _type = type;
}

-(void)setArrayX:(NSMutableArray *)arrayX{
    
    _arrayX = arrayX;
}

-(void)setArrayY:(NSMutableArray *)arrayY{
    
    _arrayY = arrayY;
    
    maxValue = [[_arrayY valueForKeyPath:@"@max.floatValue"] floatValue];
    if (maxValue <= 1.00) {
        maxValue = 100;
    }else{
        maxValue = maxValue * 100;
        maxValue = ceilf(maxValue);
        int remainder = (int)maxValue%10;
        //确保maxValue能被8整除
        maxValue = maxValue + (10 - remainder);
    }
    
    //背景线条 + Y轴
    [self initBaseLineViewWithArrayY:nil];
    //X轴
    [self initXLineWithArrayX:_arrayX];
    self.bgScrollView.contentSize = CGSizeMake( (_arrayX.count)*50, self.bounds.size.height - 60);
    self.bgScrollView.contentOffset = CGPointMake((_arrayX.count)*50 - CGRectGetWidth(self.bounds), 0);
    //获取拐点
    [self getInflectionPointWithArrayX:nil ArrayY:_arrayY color:0x4162FF];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        labelArray = [NSMutableArray arrayWithCapacity:0];
        btnArray = [NSMutableArray arrayWithCapacity:0];
        pointArray  = [NSMutableArray arrayWithCapacity:0];
        xLabelArray = [NSMutableArray arrayWithCapacity:0];
        //maxValue = 100;
        [self addSubview:self.bgScrollView];
        [self initDescribleLables];
    }
    return self;
}

//显示lable
-(void)initDescribleLables{
    
    //标题
    titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHex:0x000000];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if(IOS_VERSION > 9.0) {
        titleLabel.font = [UIFont fontWithName:PINGFANGSEMIBOLD size:16];
    }
    
    //标题右箭头
    arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[arrowBtn setImage:[UIImage imageNamed:@"icon_down_jiantou"] forState:UIControlStateNormal];
    [arrowBtn setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
    arrowBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    if (IOS_VERSION > 9.0) {
        arrowBtn.titleLabel.font = [UIFont fontWithName:PINGFANGSEMIBOLD size:16];
    }
    arrowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [arrowBtn addTarget:self action:@selector(switchSelectTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:arrowBtn];
    
    //单位
    unitLabel = [[UILabel alloc]init];
    unitLabel.textColor = [UIColor colorWithHex:0x999999];
    unitLabel.textAlignment = NSTextAlignmentCenter;
    unitLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:unitLabel];
    
    //布局约束
    UIEdgeInsets padding = UIEdgeInsetsMake(15, 0, 0, 0);
    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).with.offset(padding.top);
        make.width.greaterThanOrEqualTo(@85.0);
        make.height.equalTo(@30.0f);
        
    }];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).with.offset(33);
        make.height.equalTo(@15.0f);
        make.left.equalTo(self.mas_left).with.offset(0.0f);
        make.right.equalTo(self.bgScrollView.mas_left).with.offset(5.0f);
        
    }];
}

//灰色背景线条 + 纵坐标
-(void)initBaseLineViewWithArrayY:(NSMutableArray *)array{
    
    
    for (int i = 0; i < baseLineCount; i++) {
        
        //灰色背景线条
        UIImageView * lineView = [[UIImageView alloc]init];
        lineView.backgroundColor = [UIColor colorWithHex:0xE2EBF2];
        [self.bgScrollView addSubview:lineView];
        
        if (i == baseLineCount -1) {
            lastLineView = lineView;
        }
        
        //纵坐标
        UILabel * labelY = [[UILabel alloc]init];
        labelY.textAlignment = NSTextAlignmentCenter;
        labelY.textColor = [UIColor colorWithHex:0x999999];
        labelY.font = [UIFont systemFontOfSize:11];
        //y坐标间隔
        int interval = maxValue/(baseLineCount -1);
        labelY.text = [[NSString stringWithFormat:@"%ld",(baseLineCount - i -1)*interval] stringByAppendingString:@"%"];
        [self addSubview:labelY];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.bgScrollView.mas_top).with.offset(8+i*23);
            make.left.equalTo(self.bgScrollView.mas_left).with.offset(0.0f);
            make.right.equalTo(self.mas_right).with.offset(22.0f);
            make.height.equalTo(@0.5f);
        }];
        
        [labelY mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).with.offset(0.0f);
            make.right.equalTo(self.bgScrollView.mas_left).with.offset(5.0f);
            make.centerY.equalTo(lineView);
            make.height.equalTo(@17.0f);
            
        }];
    }
}

//横坐标
-(void)initXLineWithArrayX:(NSMutableArray *)array{
    
    //横坐标
    for (int i = 0; i < array.count; i++) {
        
        UILabel * labelX = [[UILabel alloc]init];
        labelX.textAlignment = NSTextAlignmentCenter;
        labelX.textColor = [UIColor colorWithHex:0x999999];
        labelX.font = [UIFont systemFontOfSize:12];
        labelX.text = [NSString stringWithFormat:@"%@",array[i]];
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 40);
        transform = CGAffineTransformTranslate(transform, 20, 0);
        labelX.layer.affineTransform = transform;
        [self.bgScrollView addSubview:labelX];
        
        [labelX mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.bgScrollView.mas_left).with.offset(i * (45));
            make.top.equalTo(lastLineView.mas_bottom).with.offset(14.0f);
            make.width.greaterThanOrEqualTo(@0.0f);
            make.height.equalTo(@17.0);
        }];
        [xLabelArray addObject:labelX];
    }
    
}

//获取拐点--注册
-(void)getInflectionPointWithArrayX:(NSMutableArray *)xArray ArrayY:(NSMutableArray *)yArray color:(long)color{
    
    [self layoutIfNeeded];
    NSMutableArray * midPointArray = [NSMutableArray arrayWithCapacity:0];
    for (UILabel * label in xLabelArray) {
        
        NSValue *  point = [NSValue valueWithCGPoint:CGPointMake(label.center.x, 0)];
        [midPointArray addObject:point];
    }
    for (int i = 0; i < yArray.count; i++) {
        
        CGFloat currentData = [yArray[i] floatValue];
        CGFloat possionY = (230/maxValue)*(maxValue - currentData * 100) + 8;
        NSValue * point = midPointArray[i];
        CGPoint  OriginPoint = point.CGPointValue;
        OriginPoint.y = possionY;
        NSValue * newPoint = [NSValue valueWithCGPoint:OriginPoint];
        [pointArray addObject:newPoint];
        
        //点击buton
        UIButton * pointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pointBtn.frame = CGRectMake(0, 0, 30, 30);
        [pointBtn setImage:[UIImage imageNamed:@"dpoint_blue"] forState:UIControlStateNormal];
        [pointBtn setImage:[UIImage imageNamed:@"dpoint_blue_select"] forState:UIControlStateSelected];
        [pointBtn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        pointBtn.center = OriginPoint;
        pointBtn.tag = i + 1000;
        [btnArray addObject:pointBtn];
        
        UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        messageBtn.frame = CGRectMake(0, 0, 65, 39);
        messageBtn.tag = i + 2000;
        messageBtn.hidden = YES;
        messageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        messageBtn.userInteractionEnabled = NO;
        CGFloat  displayMessage = [_arrayY[i] floatValue] * 100;
        NSString * displayStr = nil;
        if ((displayMessage < 1 && displayMessage > 0) || (displayMessage < 0 && displayMessage > -1)) {
            displayStr = [NSString stringWithFormat:@"%.4f",displayMessage];
        }else{
            displayStr = [NSString stringWithFormat:@"%.2f",displayMessage];
        }
        [messageBtn setTitle:[displayStr stringByAppendingString:@"%"] forState:UIControlStateNormal];
        
        if ([yArray[i] floatValue]*100 > maxValue/2.0f) {
            
            [messageBtn setBackgroundImage:[UIImage imageNamed:@"icon_message_top"] forState:UIControlStateNormal];
            messageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -8, 0);
            messageBtn.center = CGPointMake(OriginPoint.x, OriginPoint.y + 25);
        }else{
            
            [messageBtn setBackgroundImage:[UIImage imageNamed:@"icon_message_down"] forState:UIControlStateNormal];
            messageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
            messageBtn.center = CGPointMake(OriginPoint.x, OriginPoint.y-25);
        }
        
        [labelArray addObject:messageBtn];
    }
    
    //曲线
    //起点往前偏移
    CGPoint  originP = [[pointArray objectAtIndex:0] CGPointValue];
    CGPoint p1 = CGPointMake(originP.x - 27.5, originP.y);
    NSMutableArray * newPointArray = [NSMutableArray arrayWithArray:pointArray];
    NSValue *  point = [NSValue valueWithCGPoint:p1];
    [newPointArray insertObject:point atIndex:0];
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    //beizer.
    [beizer moveToPoint:p1];
    
    /*遮罩*/
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    
    for (int i = 0;i<newPointArray.count;i++ ) {
        if (i != 0) {
            
            CGPoint prePoint = [[newPointArray objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[newPointArray objectAtIndex:i] CGPointValue];
            
            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            if (i == newPointArray.count-1) {
                [beizer moveToPoint:nowPoint];//添加连线
                lastPoint = nowPoint;
            }
        }
    }
    
    /*遮罩*/
    CGFloat bgViewHeight = self.bgScrollView.bounds.size.height;
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    //最后一个点对应的X轴的值
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    [bezier1 addLineToPoint:lastPointX1];
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    [bezier1 addLineToPoint:p1];
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.bgScrollView.bounds.size.height- 50 - 60 - 50);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHex:0x81aeff alpha:0.25].CGColor,(__bridge id)[UIColor colorWithHex:0xb0ccff alpha:0.25].CGColor,(__bridge id)[UIColor colorWithHex:0xffffff alpha:0.25].CGColor];
    gradientLayer.locations = @[@(0.33f),@(0.66f),@(1.00f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [self.bgScrollView.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 1.0f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*lastPoint.x, self.bgScrollView.bounds.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithHex:color].CGColor;
    shapeLayer.lineWidth = 4.0f;
    [self.bgScrollView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration =1.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    //添加点击btn
    for (UIButton * btn in btnArray) {
        [self.bgScrollView addSubview:btn];
    }
    
}

-(void)clickButtonAction:(UIButton *)sender{
    
    
    for (UIButton*btn in btnArray) {
        if (sender.tag == btn.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    [self showDeslLabel:sender];
}

-(void)showDeslLabel:(UIButton *)sender{
    
    for (int i = 0; i < labelArray.count; i++) {
        
        UIButton * btn = labelArray[i];
        
        if (![self.bgScrollView.subviews containsObject:btn]) {
            
            [self.bgScrollView addSubview:btn];
        }
        
        if (sender.tag + 1000 == btn.tag) {
            btn.hidden = NO;
        }else{
            btn.hidden = YES;
        }
    }
    
}

-(void)switchSelectTypeAction{
    
    if ([self.delegate respondsToSelector:@selector(clickTopTypeAction:)]) {
        
        [self.delegate clickTopTypeAction:_type];
    }
    
}

-(UIScrollView *)bgScrollView{
    
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(48, 60, self.bounds.size.width - 15 - 48, self.bounds.size.height - 60)];
        _bgScrollView.backgroundColor = [UIColor redColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.backgroundColor = [UIColor whiteColor];
        _bgScrollView.contentSize = CGSizeMake((self.bounds.size.width - 15) * 3, self.bounds.size.height - 60);
        _bgScrollView.layer.cornerRadius = 6;
    }
    return _bgScrollView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  lineChartController.m
//  lineChartDemo
//
//  Created by hxxc on 2020/4/14.
//  Copyright © 2020 xjc. All rights reserved.
//

#import "lineChartController.h"
#import "FHXLineMsakCell.h"
#import "FHXPercentLineMaskCell.h"
#import "FHXSingleTrendModel.h"
#import "FHXTools.h"
@interface lineChartController ()<UITableViewDataSource,UITableViewDelegate,FHXLineMsakCellDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * achieveArray;//总绩效

@property(nonatomic,strong)NSMutableArray * ratioArray;//绩效比

@end

@implementation lineChartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.lineType) {
        case lineChartTypePositive:
            
            self.navigationItem.title = @"正数类型";
            break;
        case lineChartTypeDecimal:
            
            self.navigationItem.title = @"小数类型";
            break;
        case lineChartTypePercentage:
            
            self.navigationItem.title = @"百分比类型";
            break;
        case lineChartTypeNegative:
            
            self.navigationItem.title = @"正负数类型";
            break;
        default:
            break;
    }
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.lineType == lineChartTypePercentage) {
        
        FHXPercentLineMaskCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FHXPercentLineMaskCell"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FHXPercentLineMaskCell" owner:self options:nil] lastObject];
        }
        cell.title = @"目标达成率";
        cell.unitStr = @"";
        cell.type = 1;
        cell.dataArray = [self simulationDecimalData];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        FHXLineMsakCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FHXLineMsakCell"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FHXLineMsakCell" owner:self options:nil] lastObject];
        }
        
        if (self.lineType == lineChartTypePositive) {
            cell.title = @"每件均额";
            cell.unitStr = @"万元";
            cell.type = 3;

            cell.dataArray = [self simulationData];
        }
        
        if (self.lineType == lineChartTypeDecimal) {
            
            cell.title = @"绩效比";
            cell.unitStr = @"";
            cell.type = 12;
            
            cell.dataArray = [self simulationDecimalData];
            
        }
        
        if (self.lineType == lineChartTypeNegative) {
            
            cell.title = @"净增长额";
            cell.unitStr = @"万元";
            cell.type = 1;
            
            cell.dataArray = [self simulationNegative];
        }
        
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.lineType == lineChartTypePercentage) {
        return 390;
    }
    return 345;
}

#pragma mark -- 模拟数据(正数)
-(NSMutableArray *)simulationData{
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 20; i++) {
        FHXSingleTrendModel * model = [[FHXSingleTrendModel alloc]init];
        
        if (i < 10) {
            
            model.x = [NSString stringWithFormat:@"2019010%d",i + 1];
        }else{
            
            model.x = [NSString stringWithFormat:@"201901%d",i + 1];
        }
        if (i % 2) {
            
            model.y = [NSString stringWithFormat:@"%d",arc4random()%100];
        }else{
            
            model.y = [NSString stringWithFormat:@"%d",100 + arc4random()%100];
        }
        
        [array addObject:model];
    }
    
    return array;
}

#pragma mark -- 模拟数据(小数)
-(NSMutableArray *)simulationDecimalData{
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 20; i++) {
        FHXSingleTrendModel * model = [[FHXSingleTrendModel alloc]init];
        
        if (i < 10) {
            
            model.x = [NSString stringWithFormat:@"2019010%d",i + 1];
        }else{
            
            model.x = [NSString stringWithFormat:@"201901%d",i + 1];
        }
        
        
        if (i % 2) {
         
            model.y = [NSString stringWithFormat:@"%f",(double)((50 + arc4random()%50))/100];
        }else{
            
            model.y = [NSString stringWithFormat:@"%f",(double)(arc4random()%50)/100];
        }
        
        
        [array addObject:model];
    }
    
    return array;
}

#pragma mark -- 模拟数据(正负数)
-(NSMutableArray *)simulationNegative{
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 20; i++) {
        FHXSingleTrendModel * model = [[FHXSingleTrendModel alloc]init];
        
        if (i < 10) {
            
            model.x = [NSString stringWithFormat:@"2019010%d",i + 1];
        }else{
            
            model.x = [NSString stringWithFormat:@"201901%d",i + 1];
        }
        
        if (i % 2) {
           
            model.y = [NSString stringWithFormat:@"%d",100 - arc4random()%400];
        }else{
            
            model.y = [NSString stringWithFormat:@"%d",300 - arc4random()%400];
        }
        
        
        [array addObject:model];
    }
    
    return array;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

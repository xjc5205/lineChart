//
//  ViewController.m
//  lineChartDemo
//
//  Created by hxxc on 2020/4/13.
//  Copyright © 2020 xjc. All rights reserved.
//

#import "ViewController.h"
#import "lineTypeCell.h"
#import "lineChartController.h"
#import "FHXTools.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * achieveArray;//总绩效

@property(nonatomic,strong)NSMutableArray * ratioArray;//绩效比

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"图表类型";
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
    
    lineTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"lineTypeCell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"lineTypeCell" owner:self options:nil] lastObject];
    }
    switch (indexPath.row) {
        case 0:
            cell.desLabel.text = @"正整数类型";
            break;
        case 1:
            cell.desLabel.text = @"小数类型";
            break;
        case 2:
            cell.desLabel.text = @"百分比类型";
            break;
        case 3:
            cell.desLabel.text = @"正负数类型";
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    lineChartController * chartVC = [[lineChartController alloc]init];
    switch (indexPath.row) {
    case 0:
        chartVC.lineType = lineChartTypePositive;
        break;
    case 1:
        chartVC.lineType = lineChartTypeDecimal;
        break;
    case 2:
        chartVC.lineType = lineChartTypePercentage;
        break;
    case 3:
        chartVC.lineType = lineChartTypeNegative;
        break;
        
    default:
        break;
    }
    [self.navigationController pushViewController:chartVC animated:YES];
}

@end

//
//  ViewController.m
//  learnGPUImage
//
//  Created by chenchao on 2017/2/23.
//  Copyright © 2017年 chenchao. All rights reserved.
//

#import "ViewController.h"
#import "CCRecorderViewController.h"
#import "CCOutputMovieViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *array;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"GPUImage";
    
    [self.view addSubview:self.tableView];
    _array = [NSMutableArray arrayWithObjects:@"滤镜",@"视频输出", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        UITableView *tableview = [UITableView new];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.frame = self.view.frame;
        tableview.tableFooterView = [UIView new];
        tableview.backgroundColor = [UIColor clearColor];
        [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _tableView = tableview;
        
    }
    return _tableView;
}
#pragma mark - table-delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _array[indexPath.row];
    
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _array.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            CCRecorderViewController *recorder = [CCRecorderViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:recorder];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
        }
            break;
        case 1:{
            CCOutputMovieViewController *recorder = [CCOutputMovieViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:recorder];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
        }
            break;
            
        default:
            break;
    }
    
}



@end

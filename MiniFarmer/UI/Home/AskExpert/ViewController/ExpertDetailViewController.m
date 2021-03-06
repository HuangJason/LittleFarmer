//
//  ExpertDetailViewController.m
//  MiniFarmer
//
//  Created by 牛筋草 on 15/12/17.
//  Copyright © 2015年 enbs. All rights reserved.
//

#import "ExpertDetailViewController.h"
#import "ParallaxHeaderView.h"
#import "UIViewAdditions.h"
#import "BaseViewController+Navigation.h"
#import "ExpertDetailHearView.h"
#import "BusinessCardCell.h"
#import "UserInfo.h"
#import "ExpertDetailModel.h"
#import "QuestionInfo.h"
#import "QuestionCellSource.h"
#import "MyAnswerCell.h"


@interface ExpertDetailViewController ()

@property (nonatomic,strong) UIView *navigaView;

@property(nonatomic,strong) ExpertDetailModel *model;

@end

@implementation ExpertDetailViewController{

    NSString *_identify1;
    NSString *_identify2;
    NSMutableArray *_sourceArr;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = [UIColor  whiteColor];
    [self commonInit];
    [self initNavigationView];
    

}
- (void)commonInit
{
    _sourceArr = [NSMutableArray arrayWithCapacity:1];
    
}

- (void)initTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    //注册第一种单元格
    UINib *nib1 = [UINib nibWithNibName:@"BusinessCardCell" bundle:nil];
    _identify1 = @"BusinessCardCell";
    [_tableView registerNib:nib1 forCellReuseIdentifier:_identify1];
    
    //注册第二种单元格
    _identify2 = @"MyAnswerCell";
    [_tableView registerClass:[MyAnswerCell class] forCellReuseIdentifier:_identify2];
    
    
    

    [self.view insertSubview:_tableView atIndex:0];
    
    //添加子视图
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(kScreenSizeWidth, 300)];
    headerView.model = _model;
    headerView.headerImage = [UIImage imageNamed:@"home_expert_detail_header_bg"];
    _tableView.tableHeaderView = headerView;
    
}
- (void)initNavigationView{
    _navigaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kNavigationBarHeight+kStatusBarHeight)];
    _navigaView.hidden = YES;
    _navigaView.backgroundColor = [UIColor whiteColor];
    _navigaView.alpha = 1.0f;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenSizeWidth, kNavigationBarHeight)];
    titleLabel.text = @"专家详情";
    titleLabel.font = kTextFont18;
    titleLabel.textColor =[UIColor colorWithHexString:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //2.导航栏返回按钮
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0,kStatusBarHeight,44, 44)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"home_navigation_back_btn"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [_navigaView addSubview:backButton];
    //3.导航栏底部分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,kStatusBarHeight+kNavigationBarHeight-0.5, kScreenSizeWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [_navigaView addSubview:line];
    [_navigaView addSubview:titleLabel];

    [self.view addSubview:_navigaView];
    
}
- (void)back:(UIButton *)button{

    [self.navigationController popViewControllerAnimated:YES];


}
#pragma mark---数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
    
        return _sourceArr.count;
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        BusinessCardCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify1 forIndexPath:indexPath];
        cell.model = self.model;
        cell.expermodel = self.expertmodel;
        return cell;
    }
    
    MyAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify2 forIndexPath:indexPath];
    [cell refreshWithQuestionCellSource:(QuestionCellSource *)_sourceArr[indexPath.row]];
    
    
    
    return cell;

}
#pragma mark----UITableView的代理方法
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    QuestionCellSource *curSource = [_sourceArr objectAtIndex:indexPath.row];
    
    
    return curSource.cellTotalHeight;

    

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section ==0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, 12)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, 0.5)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [view addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0,11.5, kScreenSizeWidth, 0.5)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [view addSubview:line2];

        return view;
        
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ExpertDetailHearView *view = [[ExpertDetailHearView alloc] init];
    //view.backgroundColor = [UIColor redColor];
    if (section ==0) {
        view.imageString = @"home_expert_detail_expert_card";
        view.titleString = @"专家名片";
    }else {
        view.imageString = @"home_expert_detail_answer";
        view.titleString = @"专家回答过的问题";
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 12;
}
#pragma mark-----滚动视图的协议方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
        
        NSLog(@"偏移量为%lf",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y > 0)
        {
            CGFloat delta = 0.0f;
            self.navigaView.hidden = NO;
            delta =scrollView.contentOffset.y;
            
            self.navigaView.alpha =(delta) * 1 /100;
            NSLog(@"透明度为%lf",self.navigaView.alpha);
            
        }else if (scrollView.contentOffset.y ==0){
        
            self.navigaView.hidden = YES;
        
        }
    }
}
#pragma mark ---数据处理
- (void)setZjid:(NSString *)zjid{
   
    _zjid = zjid;
    
    [self requesteData:_zjid];
    
    NSDictionary *dic = @{
                          @"userid":_zjid,
                          @"id":@"0",
                          @"pagesize":@"10"
                          };
    [self requestequestionData:dic];

    
}
//获取专家的信息
- (void)requesteData:(NSString *)zjid{
    NSString *local_userid = [UserInfo shareUserInfo].userId;
    
    if (local_userid == nil) {
        local_userid = @"0";
    }
    
    NSDictionary *dic = @{
                          @"local_userid":local_userid,
                          @"userid":zjid
                          };
    __weak ExpertDetailViewController *wself = self;
    
    [[SHHttpClient defaultClient] requestWithMethod:SHHttpRequestGet subUrl:@"?c=user&m=get_center_userinfo" parameters:dic prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *code = [responseObject objectForKey:@"code"];
        if ([code integerValue]==1) {//成功
        
         wself.model = [[ExpertDetailModel alloc] initContentWithDic:responseObject];
        
        };//回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self initTableView];
        });


        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
- (void)requestequestionData:(NSDictionary *)dic{
    
    
    __weak ExpertDetailViewController *wself = self;
    [[SHHttpClient defaultClient] requestWithMethod:SHHttpRequestGet subUrl:@"?c=tw&m=gethdtw4userid" parameters:dic prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dicResult = responseObject;
            BOOL code = [[dicResult objectForKey:@"code"] boolValue];
            NSString *msg = [dicResult objectForKey:@"msg"];
            DLOG(@"code = %d,msg = %@",code,msg);
            if (!code) {
                //显示加载错误提示
                return;
            }else{
                //加载数据成功
                NSMutableArray *curQuestions = [QuestionInfo arrayOfModelsFromDictionaries:[dicResult objectForKey:@"list"]];
                for (int i =0; i<curQuestions.count; i++) {
                    QuestionInfo *info = [curQuestions objectAtIndex:i];
                    QuestionCellSource *item = [[QuestionCellSource alloc] initWithQuestionInfo:info];
                    [_sourceArr addObject:item];
                }
                
                //回到主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself.tableView reloadData];
                    
                });
                
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
   
}


@end

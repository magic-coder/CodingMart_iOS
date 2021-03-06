//
//  CodingTestResultViewController.m
//  CodingMart
//
//  Created by HuiYang on 15/11/17.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "CodingTestResultViewController.h"
#import "FlexibleAlignButton.h"

#import "RDHCollectionViewGridLayout.h"
#import "AnswsCollectionCell.h"
#import "CodingExamModel.h"
#import "ExamViewController.h"


@interface CodingTestResultViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UIButton *configBtn;
@property(nonatomic,strong)FlexibleAlignButton *titleNoticeButton;
@property(nonatomic,strong)UILabel *detailLabel;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,assign)int correctCount;

@property(nonatomic,strong)NSMutableDictionary *userSelectDic;

@end

@implementation CodingTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"测试结果";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    if (self.isPass){
        [self.titleNoticeButton setTitle:@"恭喜您，成功通过本次秘籍测试" forState:UIControlStateNormal];
        
        [self.titleNoticeButton setImage:[UIImage imageNamed:@"fill_checked"] forState:UIControlStateNormal];
        [self.view addSubview:self.titleNoticeButton];
        
        self.detailLabel =[UILabel new];
        self.detailLabel.text=@"马上开始报名码市需求吧";
        self.detailLabel.font=[UIFont systemFontOfSize:14];
        self.detailLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:self.detailLabel];
        
        [self.view addSubview:self.configBtn];
        [self.configBtn setTitle:@"查看需求" forState:UIControlStateNormal];
        
        [self.titleNoticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(82 + 64);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@45);
        }];
        
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.titleNoticeButton.mas_bottom).offset(17);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@18);
            
        }];
        
        [self.configBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.detailLabel.mas_bottom).offset(82);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.equalTo(@45);
        }];
    }else{
        [self.titleNoticeButton setTitle:@"您未能通过本次秘笈测试" forState:UIControlStateNormal];
        [self.titleNoticeButton setImage:[UIImage imageNamed:@"fail_pass"] forState:UIControlStateNormal];
        [self.view addSubview:self.titleNoticeButton];
        
        self.detailLabel =[UILabel new];
        
        self.detailLabel.font=[UIFont systemFontOfSize:14];
        self.detailLabel.textAlignment=NSTextAlignmentCenter;
        self.detailLabel.numberOfLines=0;
        [self.view addSubview:self.detailLabel];
        
        [self.view addSubview:self.configBtn];
        [self.configBtn setTitle:@"重新答题" forState:UIControlStateNormal];
        
        [self.view addSubview:self.collectionView];
        
        
        
        [self.titleNoticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(17 + 64);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@25);
        }];
        
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleNoticeButton.mas_bottom).offset(16);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.equalTo(@35);
        }];
        
        UIView *line =[UIView new];
        line.backgroundColor=[UIColor colorWithHexString:@"F3F3F3"];
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailLabel.mas_bottom).offset(16);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@20);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(20);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.equalTo(self.collectionView.mas_width);
        }];
        
        [self.configBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view.mas_bottom).offset(-30);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.equalTo(@45);
        }];
    }
}

-(void)setIsPass:(BOOL)isPass
{
    _isPass=isPass;
    [self buildUI];
}

-(void)setCorrectCount:(int)correctCount
{
    _correctCount =correctCount;
    [self updateNoticeLabel];
}

-(void)updateNoticeLabel
{
    NSString *tips =[NSString stringWithFormat:@"您有%d个问题回答错误，请点击回答错误的问题并查看正确答案，然后重新答题。",self.correctCount];
    self.detailLabel.text=tips;
}

-(UIButton*)configBtn
{
    if (!_configBtn)
    {
        _configBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_configBtn setBackgroundColor:[UIColor colorWithHexString:@"0x4289DB"]];
        [_configBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _configBtn.layer.masksToBounds=YES;
        _configBtn.layer.cornerRadius=5;
        [_configBtn addTarget:self action:@selector(configAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _configBtn;
}

-(FlexibleAlignButton*)titleNoticeButton
{
    if (!_titleNoticeButton)
    {
        _titleNoticeButton =[[FlexibleAlignButton alloc]init];
        [_titleNoticeButton setTitle:@"评论" forState:UIControlStateNormal];
        [_titleNoticeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleNoticeButton.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [_titleNoticeButton setImage:[UIImage imageNamed:@"fill_checked"] forState:UIControlStateNormal];
   
        _titleNoticeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _titleNoticeButton.alignment = kButtonAlignmentImageLeft;
        _titleNoticeButton.gap=10;
    }
    return _titleNoticeButton;
}

-(UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        RDHCollectionViewGridLayout* layout= [RDHCollectionViewGridLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionsStartOnNewLine = YES;
        layout.lineSpacing = 10;
        layout.itemSpacing = 10;
        layout.lineItemCount = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[AnswsCollectionCell class] forCellWithReuseIdentifier:@"AnswsCollectionCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
    //    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnswsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnswsCollectionCell" forIndexPath:indexPath];
    
    CodingExamModel *mode =[self.dataSource objectAtIndex:indexPath.row];
    
    cell.ansModel=AnswerModel_ShowFail;

    
    if (!mode.isRight)
    {
        cell.isMark=YES;
        self.correctCount=self.correctCount+1;
    }else
    {
        cell.isMark=NO;
    }
    
    cell.aTitle=[NSString stringWithFormat:@"%d",mode.sort.intValue];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    ExamViewController *av =[ExamViewController new];
    av.dataSource=[NSMutableArray arrayWithArray:self.dataSource];
    av.viewerModel=YES;
    av.scorIndex=indexPath.row;
    av.userSelectAnswers=self.userSelectDic;
    [self.navigationController pushViewController:av animated:YES];
}

-(void)setUserSelectAnswers:(NSMutableDictionary *)userSelectAnswers
{
    _userSelectAnswers=userSelectAnswers;
    self.userSelectDic=[NSMutableDictionary dictionaryWithDictionary:userSelectAnswers];
}

-(void)configAction
{
    if (self.isPass)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        NSArray * ctrlArray = self.navigationController.viewControllers;
        
        [self.navigationController popToViewController:[ctrlArray objectAtIndex:3] animated:YES];
    }
    
}

@end

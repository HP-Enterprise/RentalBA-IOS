//
//  DBExplainView.m
//  GJCAR.COM
//
//  Created by 段博 on 2016/11/2.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBExplainView.h"



//原始尺寸
static CGRect oldframe;



@implementation DBExplainView



-(instancetype)initWithFrame:(CGRect)frame withData:(DBUserInfoModel*)model{
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInfo = model ;
        [self createUI];
    }
    return self ;
}

-(void)createUI{
    
    self.myScrollView.delegate = self ;
    
    
    //用户头像
    UIImageView * userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 25 , 30, 50, 50)];
    
    userImageView.image = [UIImage imageNamed:@"newUserImage"];
    userImageView.layer.cornerRadius = 25 ;
    userImageView.layer.masksToBounds = YES ;
    [self.contenView addSubview:userImageView];
    
    //会员等级
    UILabel * lvlLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(userImageView.frame) +15, ScreenWidth,20)];
    
    switch ([_userInfo.lvl integerValue])
    {
        case 1:
            lvlLabel.text = @"普卡会员";
            break;
        case 2:
            lvlLabel.text = @"银卡会员";
            break;
        case 3:
            lvlLabel.text = @"金卡会员";
            break;
        case 4:
            lvlLabel.text = @"铂金卡会员";
            break;
            
            
        default:
            break;
    }
    
    lvlLabel.font = [UIFont systemFontOfSize:14];
    lvlLabel.textAlignment = 1 ;
    [self.contenView addSubview:lvlLabel];

    //等级经验值
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lvlLabel.frame)+40, ScreenWidth - 40, 2)];
    backView.backgroundColor = [UIColor colorWithRed:0.77 green:0.78 blue:0.77 alpha:1] ;
    [self.contenView addSubview:backView];
    

    UIView *lvlView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width * [_userInfo.lvl integerValue]/4, backView.frame.size.height)];
    lvlView.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [backView addSubview:lvlView];
    
    
    //    13 * 16

    CGFloat w = (ScreenWidth - 60 - 13 * 4)/3 ;
    
    //等级图片
    UIImageView * lvl1 =[[UIImageView alloc]initWithFrame:CGRectMake(30, backView.frame.origin.y - 20, 13, 16)];
    
    if ([_userInfo.lvl integerValue]>=1)
    {
        lvl1.image = [UIImage imageNamed:@"lvlImage"];
        
    }
    else
    {
        lvl1.image = [UIImage imageNamed:@"lvlImage-1"];
    }
    [self.contenView addSubview:lvl1];
    
    UIImageView * lvl2 =[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lvl1.frame)+w, backView.frame.origin.y - 20, 13, 16)];
    if ([_userInfo.lvl integerValue]>=2)
    {
        lvl2.image = [UIImage imageNamed:@"lvlImage"];
        
    }
    else
    {
        lvl2.image = [UIImage imageNamed:@"lvlImage-1"];
    }
    [self.contenView addSubview:lvl2];
    
    UIImageView * lvl3 =[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lvl2.frame)+w, backView.frame.origin.y - 20, 13, 16)];
    if ([_userInfo.lvl integerValue]>=3)
    {
        lvl3.image = [UIImage imageNamed:@"lvlImage"];
        
    }
    else
    {
        lvl3.image = [UIImage imageNamed:@"lvlImage-1"];
    }
    
    [self.contenView addSubview:lvl3];
    
    UIImageView * lvl4 =[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lvl3.frame)+w, backView.frame.origin.y - 20, 13, 16)];
    if ([_userInfo.lvl integerValue]>=4)
    {
        lvl4.image = [UIImage imageNamed:@"lvlImage"];
    }
    else
    {
        lvl4.image = [UIImage imageNamed:@"lvlImage-1"];
    }
    
    [self.contenView addSubview:lvl4];
    
    //等级分类
    UILabel * lvlkind1 = [[UILabel alloc]initWithFrame:CGRectMake(lvl1.frame.origin.x - 20, CGRectGetMaxY(backView.frame)+5, 53, 20)];
    lvlkind1.text = @"普卡会员"  ;
    lvlkind1.textAlignment = 1 ;
    lvlkind1.font = [UIFont systemFontOfSize:10];
    [self.contenView addSubview:lvlkind1];
    
    
    UILabel * lvlkind2 = [[UILabel alloc]initWithFrame:CGRectMake(lvl2.frame.origin.x - 20, CGRectGetMaxY(backView.frame)+5, 53, 20)];
    lvlkind2.text = @"银卡会员"  ;
    lvlkind2.textAlignment = 1 ;
    lvlkind2.font = [UIFont systemFontOfSize:10];
    [self.contenView addSubview:lvlkind2];
    
    
    UILabel * lvlkind3 = [[UILabel alloc]initWithFrame:CGRectMake(lvl3.frame.origin.x - 20, CGRectGetMaxY(backView.frame)+5, 53, 20)];
    lvlkind3.text = @"金卡会员"  ;
    lvlkind3.textAlignment = 1 ;
    lvlkind3.font = [UIFont systemFontOfSize:10];
    [self.contenView addSubview:lvlkind3];
    
    UILabel * lvlkind4 = [[UILabel alloc]initWithFrame:CGRectMake(lvl4.frame.origin.x - 20, CGRectGetMaxY(backView.frame)+5, 53, 20)];
    lvlkind4.text = @"铂金卡会员"  ;
    lvlkind4.textAlignment = 1 ;
    lvlkind4.font = [UIFont systemFontOfSize:10];
    [self.contenView addSubview:lvlkind4];

    DBLog(@"%f",CGRectGetMaxY(lvlkind4.frame));
    [self createExplainView];
}

-(void)createExplainView{
    
    //积分说明
    UILabel * lvlkind1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 200, ScreenWidth - 30, 20)];
    lvlkind1.text = @"会员等级说明:"  ;
    lvlkind1.textColor =  BascColor ;
    lvlkind1.font = [UIFont systemFontOfSize:12];
    [self.contenView addSubview:lvlkind1];
    
    
    NSString * explainStr = @"1.	会员等级\n赶脚会员级别分为4个等级，分别为：普卡会员、银卡会员、金卡会员、铂金卡会员。上线初期，仅推出普通会员卡，银卡、金卡和铂金卡稍后推出，敬请期待。\n2.	积分细则\n普卡会员消费金额以积分形式计入会员账户，积分可用于租车的消费抵扣及兑换指定的产品。\n◆	积分获取\n积分获取仅针对每次成功租车所产生的租金费用和超时费。（不含保险费、手续费、维修费、违章罚单、预授权、违约/滞纳金等其他费用）\n会员积分比例为1:1，即会员每消费1元可相应获得1积分。\n例：普卡会员王先生此次成功租车的消费租金费用为48元，无超时费，该用户新增48积分。\n◆	每张订单消费产生积分将于用户成功还车当日生成，并自动充入用户注册的帐户中。\n◆	如预订人与承租人不一致，消费积分计入预订人会员账户。\n3.	积分使用\n兑换：\n1)	用户可以在“我的赶脚”内的“我的积分”查询积分。\n2)	可在“我的积分”一栏中，点击“兑换”按钮兑换赶脚发布的优惠券。\n3)	兑换完成后，可在“我的优惠券”中查询。\n抵扣：\n1)	将积分兑换成定额代金券后进行消费抵扣\n2)	兑换赶脚提供的相关服务。\n3)	兑换赶脚提供的相关礼品。"  ;
    
        
    
    
    UILabel * explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lvlkind1.frame)+10 , ScreenWidth - 30, 300)];
    explainLabel.text = explainStr ;
    explainLabel.numberOfLines = 0 ;
    explainLabel.font = [UIFont systemFontOfSize:11];
//    [self.contenView addSubview:explainLabel];

//    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lvlkind1.frame)+10 , ScreenWidth - 30, 300)];
//    imageView.image = [UIImage imageNamed:@"level001"];
//    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
//    [imageView addGestureRecognizer:tapGestureRecognizer1];
//    //让UIImageView和它的父类开启用户交互属性
//    [imageView setUserInteractionEnabled:YES];
//    
//    [self.contenView addSubview:imageView];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:explainStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
   
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [explainStr          length])];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalAmount.length + 2)];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(0, 7)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(80, 7)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(341, 7)];

    
    explainLabel.attributedText = attributedString;
    

    [explainLabel sizeToFit];
    
    

}

-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    NSLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [self scanBigImageWithImageView:clickedImageView];
}




-(void)scanBigImageWithImageView:(UIImageView *)currentImageview{
    //当前imageview的图片
    UIImage *image = currentImageview.image;
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];

    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    [imageView setTag:0];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:0];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}

-(UIScrollView*)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
        _myScrollView.showsVerticalScrollIndicator = NO ;
        _myScrollView.showsHorizontalScrollIndicator = NO ;
        _myScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height+ 350);
        [self addSubview:self.myScrollView];
    
    }
    return _myScrollView ;
}


-(UIView*)contenView{
    if (!_contenView) {
        _contenView = [[UIView alloc]initWithFrame:self.myScrollView.frame];
        [self.myScrollView addSubview:_contenView];
        _contenView.userInteractionEnabled = YES  ;
    }
    return _contenView;
}


@end

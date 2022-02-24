//
//  homePage-TableViewCell.m
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/1/22.
//

#import "HMTableViewCell.h"
#import <Masonry.h>
#import <SDWebImage.h>

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
@implementation HMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//重写cell的方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置图片
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        self.imgView.backgroundColor = [UIColor redColor];
        //contentView是cell自带的view，
        [self.contentView addSubview:self.imgView];
        //设置标题
        self.tLable = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.tLable.backgroundColor = [UIColor grayColor];
        self.tLable.numberOfLines = 0;//换行
        self.tLable.font = [UIFont boldSystemFontOfSize:18];
        self.tLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.tLable];
        //设置作者
        self.atLable = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.atLable.backgroundColor = [UIColor blueColor];
        self.atLable.font = [UIFont systemFontOfSize:15];
        self.atLable.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.atLable];
    }
    return self;
}

//在这个方法写子视图的布局代码
- (void)layoutSubviews {
    //调用父类的方法
    [super layoutSubviews];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-SCREEN_WIDTH/20);
    }];
    [_tLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView);
        make.right.equalTo(self.imgView.mas_left).offset(-10);
        make.left.equalTo(self.imgView.mas_left).offset(-SCREEN_WIDTH/1.5);
    }];
    [_atLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView);
        make.left.equalTo(self.tLable);
        make.top.equalTo(self.tLable.mas_bottom).offset(10);
    }];
}

//重写setter方法。
-(void)setNews:(Model *)news {
    if (_news != news) {
        _news = news;
        //给视图赋值，
        self.tLable.text = news.title;
        self.atLable.text = news.hint;
        //判断有无图片
        if (news.images != nil) {
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:news.images[0]]];
        }
    }
    //注意：这里不能写成 self.tLable = tLable;
    //因为这样会无限的调用自己，叫做递归；
}

@end

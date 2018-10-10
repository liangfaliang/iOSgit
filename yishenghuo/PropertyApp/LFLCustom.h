
//
//  LFLCustom.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/7.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

//支付宝
#define Partnera @"2088221258146593"
#define Sellera @"wwzs2016@163.com"
#define Privatea @""
#define plublicRSA @""

#define AppScheme @"pay2088221258146593mianyang"

#define Appliaynotify_url @"http://39.104.86.19/ecmobile/payment/alipay/sdk/notify_url.php"
//微信
#define WeiXinCbackUrl @"http://www.shequyun.cc/masterpm/ecmobile/index.php?url=test"

//金融
#define FinancialUrl @"https://wap.95559.com.cn/mobs/main.html#public/index/index"
//登陆
#define LoginUrl @"user/signin"
//注册
#define RegisterUrl @"user/signup"
//用户信息
#define UserInfoUrl @"user/info"
//头像上传
#define UserIconImageUrl @"user/edit/headimage"
//修改昵称
#define UserNicknameUrl @"user/edit/nickname"
//修改性别
#define UserSexUrl @"user/edit/sex"
//官方信息
#define ConfigUrl @"config"

//物业项目
#define PropertyProjectUrl @"property/authentication/getProject"

//首页
#define HomeWheelUrl @"property/data/banner"//首页轮播图
#define HomeMenuUrl @"property/data/menu"//首页菜单
#define HomeServiceUrl @"property/data/life"//首页服务
#define HomeInformationUrl @"property/information/getone"//首页社区资讯
#define HomeInformationListUrl @"property/information/list"//首页社区资讯列表
#define HomeInformationDetailUrl @"property/information/detail"//首页社区资讯详情
//商城首页
//商城轮播图
#define wheelUrl @"home/data"
//分类请求
#define navUrl @"home/nav"
#define navNewUrl @"home/nav/shop_new"
//热门请求
#define hotUrl @"home/hot"
//广告位
#define ShopAdsUrl @"home/shopads"
//供应商列表
#define ShopSupplierListUrl @"suppliers/list"//供应商列表
//一级分类列表
#define CategoryFirstUrl @"category/toplevel"
//二级分类列表
#define CategorySecondUrl @"category/secondlevel"
//搜索
#define searchUrl @"search"//搜索
#define searchDeleteUrl @"shop/search_log/clear"//删除搜索记录
//热门搜索 历史记录
#define searchHistoryAndHotUrl @"shop/search_log/log"//热门搜索 历史记录
//商品详情请求
#define goodsUrl @"shop/goods"
//单个商品详情请求
#define ShopSingleGoodsUrl @"cart/get_cart_goods"//单个商品详情请求
//商品描述请求
#define goodsDescUrl @"goods/desc"
//商品订单请求
#define goodsOrderUrl @"flow/checkOrder"
//商城轮播图
#define ShopListWheelUrl @"shop/shopads"
//商品店铺请求
#define storelistUrl @"suppliers/list"//店铺
//商品直购
#define ShopDirectlistUrl @"shop/search"//直购
//商品店铺商品请求
#define storeGoodsUrl @"suppliers/goods"//店铺商品
//商品店铺详情请求
#define storeInfoUrl @"suppliers/info"//店铺详情
//商品店铺商品销量请求
#define storeGoodsSaleDescUrl @"sale_desc"//店铺商品销量升
//商品店铺商品销量请求
#define storeGoodsSaleAscUrl @"sale_asc"//店铺商品销量降
//商品列表筛选条件
#define FilterPriceUrl @"filter/price_range"//筛选条件-价格
#define FilterBrandUrl @"filter/brand"//筛选条件-品牌
//商品列表标签
#define ShopListSortUrl @"filter/keywords"//标签
//商品列表请求
#define SaleslistDescUrl @"sale_asc"//销量低到高
//商品列表请求
#define SaleslistAscUrl @"sale_desc"//销量高到低
//商品列表请求
#define storelistDescUrl @"suppliers_desc"//销量
//商品列表请求
#define storelistAscUrl @"suppliers_asc"//销量
//商品列表请求
#define price_desclistUrl @"price_desc"//价格升
//商品列表请求
#define price_asclistUrl @"price_asc"//价格降
//商品列表请求
#define is_hotlistUrl @"is_hot"//热销
//添加购物车请求
#define createCartUrl @"cart/create"
//购物车列表请求
#define CartListUrl @"cart/list"
//购物车更新请求
#define CartUpdateUrl @"cart/update"
//商业街购物车更新请求
#define BusinessCartUpdateUrl @"bustreet/cart/update"
//购物车删除请求
#define CartDeleteUrl @"cart/delete"
//收货人地址列表
#define AddressListUrl @"address/list"
//设置默认地址
#define AddressDefaultUrl @"address/setDefault"
//删除地址
#define AddressDeleteUrl @"address/delete"
//编辑地址
#define AddressEditUrl @"address/info"
//编辑保存地址
#define AddressEditSaveUrl @"address/update"
//地区列表
#define RegionListUrl @"region"
//添加地址
#define AddAddressUrl @"address/add"
//提交订单
#define SubmitOrdersUrl @"flow/done"

//订单详情
#define OrderDetailUrl @"order/info"
//订单支付
#define OrderPayUrl @"order/pay"
//取消订单
#define OrderCancelUrl @"order/cancel"
//确认订单
#define OrderAffirmUrl @"order/affirmReceived"
//订单列表
#define OrderListUrl @"order/list"
#define appraiseUrl @"order/goods_list"//待评价
//商品评论点赞
#define OrderEvaluateLikeUrl @"shop/comments/agree"
//评论商品
#define OrderEvaluateUrl @"comments/add"
//商品评论列表
#define OrderEvaluateListUrl @"shop/comments/list"
//商品评论个数统计
#define OrderEvaluateCountStatiUrl @"shop/comments/stati"
//商品评论回复列表
#define OrderEvaluateReplyListUrl @"shop/comments/info"
#define await_payUrl @"await_pay"//待付款
#define await_shipUrl @"await_ship"//待发货
#define shippedUrl @"shipped"//待收货
#define OrderfinishedUrl @"finished"// 历史订单

//商业首页
#define BusinessBannerBUrl @"bustreet/banner"//轮播图
#define BusinessRentListBUrl @"bustreet/house/list"//招租信息
#define BusinessRentDetailBUrl @"bustreet/house/detail"//招租信息详情
#define BusinessPromotionListBUrl @"bustreet/activity/promotion"//促销活动
#define BusinessListBUrl @"bustreet/shop/list"//商业
#define BusinessHotSalegoodUrl @"bustreet/goods/hot_goods"//热卖商品

//积分商城
#define ShopIntegraListlUrl @"exchange/index/goods_list"//商品列表
#define ShopIntegraBannerlUrl @"exchange/index/banner"//商品banner
#define ShopIntegraDetailUrl @"exchange/index/goods_info"//商品详情
#define ShopIntegraOrderListUrl @"exchange/order/list"//订单列表
#define ShopIntegraOrderDetailUrl @"exchange/order/info"//订单详情

//志愿者
#define volunteersBannerUrl @"volunteer/home/banner"//轮播图
#define volunteersActivityUrl @"volunteer/home/activity"// 首页活动列表
#define volunteersActivityDatilUrl @"volunteer/activity/info"// 首页活动详情
#define volunteersInfoUrl @"volunteer/enroll/info"// 志愿者个人信息
#define volunteersActivityJionUrl @"volunteer/activity/join"// 志愿者参加活动
#define volunteersActivityJionlogUrl @"volunteer/activity/joinlog"// 志愿者参加过活动的列表
#define volunteersServiceUrl @"volunteer/home/menu"// 首页服务列表
#define volunteersSelectUrl @"volunteer/enroll/fitting"// 志愿者选项
#define volunteersSaveUrl @"volunteer/enroll/join"// 志愿者信息提交
#define volunteersConfirmUrl @"volunteer/enroll/edit"// 志愿者信息确认
#define volunteersRegulationsUrl @"volunteer/enroll/system"// 志愿者管理条例
#define CommitteeUrl @"http://39.104.86.19/mobile/index.php?m=default&c=committee&a=index&u="// 业主委员会


//行业监管
#define IndustryCategoryUrl @"article/regulation/category"//分类
#define IndustryArticleListUrl @"article/regulation/list"// 文章
#define IndustryAddArticleUrl @"article/regulation/add_article"//发表文章
#define IndustryAddReviewUrl @"article/regulation/add_comment"//添加评论
#define IndustryPraiseTreadUrl @"article/regulation/like"// 赞/踩
#define IndustryArticleInfoUrl @"article/regulation/info"//文章详情
#define IndustryArticleCommentListUrl @"article/regulation/comment_list"//文章评论列表

//投票表决
#define CastVotelistUrl @"property/committee/list"//列表
#define CastVoteDetailUrl @"property/committee/detail"//详情
#define CastVoteSubmitUrl @"property/committee/add"//投票

//周边商业
#define PBusinessCategoryUrl @"surround/category"//分类
#define PBusinesslistUrl @"surround/shop/list"//列表
#define PBusinessdetailUrl @"surround/shop/info"//详情
#define PBusyCommentListUrl @"surround/comments/list"//评论列表
#define PBusyCommentListCountUrl @"surround/comments/statistics"//评论列表统计
#define PBusyCommentClickUrl @"surround/comments/add_agree"//评论点赞
#define PBusyCommentAddUrl @"surround/comments/add"//写评论

//商业街
#define BusinessUrl @"bustreet/shop/bustreet"//商业街
#define BusinessCategoryUrl @"bustreet/category"//分类
#define BusinessShopCategoryUrl @"bustreet/shop/category"//店铺内商品分类
#define BusinessShopGoodsUrl @"bustreet/goods/list"//店铺内商品列表
#define BusinesslistUrl @"bustreet/shop/list"//列表
#define BusinessdetailUrl @"bustreet/shop/info"//详情
#define BusyCommentListUrl @"surround/comments/list"//评论列表
#define BusyCommentListCountUrl @"surround/comments/statistics"//评论列表统计
#define BusyCommentClickUrl @"surround/comments/add_agree"//评论点赞
#define BusyCommentAddUrl @"surround/comments/add"//写评论
#define BusinessInfoListUrl @"shop/information/shop_article_list"//商业社区资讯列表
#define BusinessInfoDetailUrl @"shop/information/detail"//商业社区资讯详情

//嘉年华
#define CarnivalCategoryUrl @"carnival/category"//分类
#define CarnivallistUrl @"carnival/shop/list"//列表
#define CarnivaldetailUrl @"carnival/shop/info"//详情
#define CarnivalCommentListUrl @"carnival/comments/list"//评论列表
#define CarnivalCommentListCountUrl @"carnival/comments/statistics"//评论列表统计
#define CarnivalCommentClickUrl @"carnival/comments/add_agree"//评论点赞
#define CarnivalCommentAddUrl @"carnival/comments/add"//写评论

//幼教
#define PreschoolBannerUrl @"school/index/banner"//轮播图
#define PreschoolGuideUrl @"school/index/enroll_desc"//招生简章
#define PreschoolTypeUrl @"school/index/en_type"//类型
#define PreschoolSubmitUrl @"school/index/submit"//提交
#define PreschoolInfoListUrl @"school/article/list"//幼儿园动态列表
#define PreschoolInfoDetailUrl @"school/article/detail"//幼儿园动态详情
//城市新闻
#define CityNewslistUrl @"property/news/list"//列表
#define CityNewsdetailUrl @"property/news/detail"//详情
//个人中心
#define PersonalCenterGrUrl @"home/personal/gr"//列表
#define PersonalCenterFwUrl @"home/personal/fw"//详情
#define PersonalCenterBottomMenuUrl @"home/personal/menu"//详情

//推送消息
#define PushMessageListUrl @"push/log/list"//推送消息记录
#define PushMessageReadUrl @"push/log/read"//推送消息已读

//社区活动
#define ActivityJionListUrl @"property/activity/my_join"//参加过的活动
#define ActivityListUrl @"property/activity/list"//列表
#define ActivityDetailUrl @"property/activity/detail"//详情
#define ActivitySubmitUrl @"property/activity/join"//提交
#define ActivitySubmitListUrl @"property/activity/join_list"//参加人列表
#define ActivityIsjionUrl @"property/activity/check_join"//检测是否参加过
//房屋租赁
#define HouseRentingListUrl @"property/house/list"//列表
#define HouseRentingDetailUrl @"property/house/detail"//详情

//发布房屋租赁
#define ReleaseRentingLeaseUrl @"property/house/lease"//户型列表
#define ReleaseRentingSubmitUrl @"property/house/submit"//提交
#define ReleaseRentingDetailUrl @"property/house/lease_info"//详情
#define ReleaseRentinDeleteUrl @"property/house/delete"//删除
//满意度调查
#define SatisfactionListUrl @"property/stfc/list"//列表
#define SatisfactionDetailUrl @"property/stfc/detail"//详情
#define SatisfactionSubmitUrl @"property/stfc/add"//提交
#define SatisfactionSubmitResultUrl @"property/stfc/summarty"//统计结果
#define SatisfactionIsJionUrl @"property/stfc/is_join"//是否参加
//物业缴费订单信息
#define PropertyOrderInfoUrl @"property/pay"//列表
#define PropertyPayCodeUrl @"property/pay_code"//支付方式
//APP头条
#define HeadlineListUrl @"property/headline/list"//列表
#define HeadlineDetailUrl @"property/headline/detail"//详情

//论坛模块
#define BBSDeletePostUrl @"forum/post/delete"//删除发帖
#define BBSMyPostUrl @"forum/my/list"//我的发帖
#define BBSHomeListUrl @"forum/post/list"//首页列表
#define BBSbannerListUrl @"forum/banner/list"//首页轮播图
#define BBSLikeUrl @"forum/agree/add_agree"//点赞 取消点赞
#define BBSSendPostUrl @"forum/post/add"//发帖
#define BBSMenuListUrl @"forum/category/list"//分类标签
#define BBSPostDetailUrl @"forum/post/detail"//帖子详情
#define BBSReplyListUrl @"forum/comment/list"//评论列表
#define BBSReplyUrl @"forum/comment/add"//用户评论
#define BBSReportPostUrl @"forum/report/submit"//举报
#define BBSReportPostTypeUrl @"forum/report/type"//举报类型
//政府在线
#define GovernmentHomeMenuUrl @"regulation/home/data"//首页菜单
#define GovernmentHomeListUrl @"regulation/home/list"//首页列表
#define GovernmentSearchListUrl @"regulation/search/list"//搜索
#define GovernmentIndustryUrl @"regulation/trends/list"//行业动态
#define GovernmentIndustryDetailUrl @"regulation/trends/detail"//行业动态详情
#define GovernmentGuidelineUrl @"regulation/guide/list"//办事指南
#define GovernmentGuidelineDetaiUrl @"regulation/guide/detail"//办事指南详情
#define GovernmentPoliciesUrl @"regulation/policy/list"//政策法规
#define GovernmentPoliciesDetaiUrl @"regulation/policy/detail"//政策法规详情
#define GovernmentMaintainSubmitUrl @"regulation/repair/search"//维修基金查询

#define GovernmentLikeUrl @"regulation/article/add_agree"//点赞 取消点赞
#define GovernmentReplyListUrl @"regulation/comment/list"//评论列表
#define GovernmentReplyUrl @"regulation/article/add_comment"//用户评论
#define GovernmentPostDetailUrl @"regulation//article/detail"//评论详情
#define GovernmentSendPostUrl @"regulation/article/add_article"//发帖
#define GovernmentSuggestListUrl @"regulation/suggest/list"//投诉与建议
#define GovernmentAdvisoryListUrl @"regulation/consult/list"//在线咨询
#define GovernmentReportPostUrl @"regulation/report/submit"//举报
#define GovernmentReportPostTypeUrl @"regulation/report/type"//举报类型
#define GovernmentDeletePostUrl @"regulation/article/del_article"//删除帖子

//上传文件
#define ImagePath_FileUrl @"loan/index/upload"

//信用贷
#define CreditLoanHomeUrl @"loan/index/data"//信用贷首页

//车辆管理
#define VehicleImageUrl @"property/vehicle/banner"//图片
#define VehicleTypeUrl @"property/vehicle/type_list"//车辆类型
#define VehicleInfoSubmitUrl @"property/vehicle/add"//车辆信息提交
#define VehicleRecordListUrl @"property/vehicle/list"//车辆预约列表

//充值
#define RechargeRecordingUrl @"user/recharge/delta_list"//余额充值/消费 记录
#define RechargeListUrl @"user/recharge/delta_price"//余额充值金额、支付方式接口
#define RechargeOderUrl @"user/recharge/delta"//余额充值
//优惠券
#define MyCouponListUrl @"user/bonus/list"//优惠券
#define CouponCateUrl @"activity/coupon/config"//优惠券banner
#define CouponListUrl @"activity/coupon/list"//优惠券列表
#define CouponRushUrl @"activity/coupon/receive"//优惠券抢卷
#define CouponRushListUrl @"user/bonus/list"//优惠券兑换列表
//送积分
#define OperationSendPoints @"integral/index/give"//送积分
//积分商城
#define IntegralShopListUrl @"user/bonus/list"//优惠券

//邀请好友
#define InviteFriendsUrl @"user/recommend/code"//邀请好友

//短信验证
#define SMSsendUrl @"message/index/send"//短信发送
#define SMSVerificationUrl @"message/index/check"//短信验证

//医疗
#define MedicalHomeUrl @"medical/med_menu/menu"//医疗首页
#define MedicalInfoListUrl @"medical/information/information_article_list"//医疗社区资讯列表
#define MedicalInfoDetailUrl @"school/article/detail"//医疗社区资讯列表
#define MedicalManListUrl @"medical/information/chronic_article_list"//慢病知识列表
#define MedicalYunListUrl @"medical/information/gravida_article_list"//孕妇知识列表
#define MedicalYingListUrl @"medical/information/child_article_list"//婴幼知识列表
#define MedicalLectureListUrl @"medical/information/lecture_article_list"//讲座列表
#define MedicalLectureDetailUrl @"school/article/detail"//讲座详情
#define MedicalGoodsListUrl @"medical/goods"//健康商城

//档案查询
#define MyFileQueryListUrl @"medical/archives/my_archives"//我的档案列表查询
#define ERPMyFileQueryListUrl @"85"//我的档案列表查询
#define MyFileQueryRecordListUrl @"medical/archives/archives_info"//我的档案记录
#define ERPMyFileQueryRecordListUrl @"108"//我的档案记录
#define MyFilePersonalFormUrl @"archives_manage/archives_gr"//个人基本表
#define MyFileHealthCoveUrl @"medical/archives/archives_fm"//健康档案封面
#define ERPMyFileHealthCoveUrl @"103"//健康档案封面
#define MyFileHealthInfoUrl @"archives_manage/archives_card"//健康档案信息卡
#define MyFileHealthCheckFormUrl @"archives_manage/archives_tj"//健康体检表
#define MyFileHealthReceiveRUrl @"archives_manage/archives_jz"//接诊信息
#define MyFileHealthConsultationUrl @"archives_manage/archives_hz"//会诊信息
#define MyFileHealthNewbornVisitUrl @"archives_manage/archives_xinshenger"//新生儿访规记录表
#define MyFileHealthPostpartum42Url @"archives_manage/archives_chfs42"//产后42天
//建档
#define FileCenterSubmitUrl @"medical/archives/service_archives"//服务中心建档
#define ERPFileCenterSubmitUrl @"reserveArchives"//预约建档
#define ERPFileBasicSetupUrl @"createArchives"//个人信息建档
#define MyAppointmentListUrl @"medical/archives/service_archives_list"//我的预约
//孕妇建册
#define ERPYunSubmitUrl @"reserveGravida"//孕妇建册
//激活建档
#define ActivateFileQueryUrl @"medical/archives/search_archives"//激活建档查询
#define ERPActivateFileQueryUrl @"82"//激活建档查询
#define ActivateFileSelectUrl @"medical/archives/partake_archives_expand"//个人参与建档选项
#define ActivateSubmitUrl @"medical/archives/partake_archives"//档案认证、激活建档
//健康教育
#define HealthEducateCategoryUrl @"medical/healthEducation_category/list"//健康教育分类列表
#define HealthEducateListUrl @"medical/healthEducation_article/list"//健康教育列表
#define HealthEducateDetailUrl @"medical/healthEducation_article/detail"//健康教育详情
//体检预约
#define MedicalExaminationListUrl @"medical/phyexa/list"//体检预约列表
#define MedicalExaminationDetailUrl @"medical/phyexa/detail"//体检预约详情
#define MedicalExaminationItemlUrl @"medical/phyexa/additional_list"//体检预约项目选择
#define MedicalExaminationSubmitUrl @"medical/phyexa/submit"//体检预约提交

//儿童保健
#define ChildCareListUrl @"medical/child/child_list"//儿童保健列表
#define ChildCareHomePictureUrl @"medical/child/imgurl_list"//儿童保健首页图片
#define RecommendArticleListUrl @"medical/child/article_list"//推荐文章
#define RecommendArticleDetailUrl @"medical/child/article_detail"//推荐文章详情
#define ChildRelationUrl @"medical/child/relationship"//宝宝关系
#define ChildRelationSumbitUrl @"medical/child/submit"//宝宝提交
#define VaccinationPlanUrl @"medical/child/vaccinate"//接种计划
#define ERPVaccinationPlanUrl @"114"//接种计划
#define VaccinationSubmitDetailUrl @"medical/child/vaccinate_info"//接种计划提交详情
#define VaccinationSubmitUrl @"medical/child/vaccinate_submit"//接种计划提交
#define VaccinationListUrl @"medical/child/vaccinate_record"//接种计划记录
#define ERPVaccinationListUrl @"91"//接种计划记录
#define UnderstandMoreUrl @"medical/child/more"//了解更多

//孕妇
#define PregnantListUrl @"medical/gravida/info"//孕妇列表
#define PregnantHomePictureUrl @"medical/gravida/imgurl_list"//孕妇首页图片
#define PregnantRecommendArticleListUrl @"medical/gravida/article_list"//推荐文章
#define PregnantRecommendArticleDetailUrl @"medical/gravida/article_detail"//推荐文章详情
#define ArticleCommentListUrl @"medical/comments/list"//文章详情评论
#define ArticleCommentDetailUrl @"medical/comments/info"//文章详情评论详情
#define ArticleAddCommentUrl @"medical/comments/add"//文章添加评论
#define ArticleAddLikeUrl @"medical/agree/edit"//文章点赞
#define ArticleAddCollectionUrl @"collection/add"//文章收藏
#define PregnantInfoSumbitUrl @"medical/gravida/gravida_submit"//提交
#define PregnantCheckPlanUrl @"medical/gravida/antenatal_care"//产检计划
#define PregnantCheckPlanDetailUrl @"medical/gravida/antenatal_info"//产检计划
#define PregnantCheckPlanSumbitDetailUrl @"medical/gravida/antenatal_detail"//产检计划提交详情
#define PregnantCheckPlanSumbitUrl @"medical/gravida/submit"//产检计划提交
#define PregnantCheckPlanRecordUrl @"medical/gravida/vaccinate_record"//产检计划记录
//门禁相关
#define AccessGetDeviceNoUrl @"property/control_door/list"//获取设备号
#define AccessGetCodeUrl @"oauth/authorize"//获取code
#define AccessGetTokenUrl @"oauth/token"//获取token
#define AccessGetKeyUrl @"api/v1/generate_key"//获取key
#define AccessOpenUrl @"api/v1/open_door"//开门
//金钥匙
#define GoldenGoodsListUrl @"sanjin/goods"//三金服务商品列表
#define GoldenHomeBannerUrl @"sanjin/banner"//三金首页banner
#define GoldenInfoListUrl @"sanjin/information/sanjin_article_list"//三金社区资讯列表
#define GoldenInfoDetailUrl @"sanjin/information/detail"//三金社区资讯详情
#ifdef DEBUG //测试阶段


//版本信息
#define AppStoreUrl @"http://itunes.apple.com/cn/lookup?id="
//大庆高新
#define ZJguokaihangBaseUrl @"http://39.104.86.19/mobile/api/Appinterface.php?type="
//大庆高新论坛
#define ZJBBsBaseUrl @"http://39.104.86.19/mobile/api/Appforum.php?type="
//大庆高新ERP接口
#define ZJERPBaseUrl @"http://120.26.112.117/weixin/?id=32&n_type="
//大庆高新ERP接口
#define ZJERPIDBaseUrl @"http://120.26.112.117/weixin/?id="
//全国车辆违章查询
#define ZJnationalViolationBaseUrl @"http://v.juhe.cn/wz/"
//全国车辆违章城市列表
#define NationalViolationCityurl @"citys?key=d73e26f033c28f25258cf98017d23e4f"
//全国车辆违章查询
#define NationalViolationQuery @"query?key=d73e26f033c28f25258cf98017d23e4f"

//商城接口
#define ZJShopBaseUrl @"http://39.104.86.19/ecmobile/index.php?url="
//#define ZJShopBaseUrl @"http://39.104.86.19/ecmobile/index.php?url="
//YY天气接口
#define ZJYYWeatherUrl @"http://api.yytianqi.com/forecast7d?key=dljl0r8nfm4948e9&city="
//聚合天气接口
#define ZJJHWeatherUrl @"http://v.juhe.cn/weather/geo?format=2&key=2d35db3fadfd2ff7040eacac18613294&"
//门禁域名
#define AccessBaseUrl @"http://koalaparking.cn/"
#else


#define AppStoreUrl @"http://itunes.apple.com/cn/lookup?id="
//大庆高新
#define ZJguokaihangBaseUrl @"http://39.104.86.19/mobile/api/Appinterface.php?type="
//大庆高新论坛
#define ZJBBsBaseUrl @"http://39.104.86.19/mobile/api/Appforum.php?type="
//大庆高新ERP接口
#define ZJERPBaseUrl @"http://120.26.112.117/weixin/?id=32&n_type="
//大庆高新ERP接口
#define ZJERPIDBaseUrl @"http://120.26.112.117/weixin/?id="
//全国车辆违章查询
#define ZJnationalViolationBaseUrl @"http://v.juhe.cn/wz/"
//全国车辆违章城市列表
#define NationalViolationCityurl @"citys?key=d73e26f033c28f25258cf98017d23e4f"
//全国车辆违章查询
#define NationalViolationQuery @"query?key=d73e26f033c28f25258cf98017d23e4f"
//商城接口
#define ZJShopBaseUrl @"http://39.104.86.19/ecmobile/index.php?url="
//#define ZJShopBaseUrl @"http://39.104.86.19/ecmobile/index.php?url="
//YY天气接口
#define ZJYYWeatherUrl @"http://api.yytianqi.com/forecast7d?key=dljl0r8nfm4948e9&city="
//聚合天气接口
#define ZJJHWeatherUrl @"http://v.juhe.cn/weather/geo?format=2&key=2d35db3fadfd2ff7040eacac18613294&"
//门禁域名
#define AccessBaseUrl @"http://koalaparking.cn/"
#endif

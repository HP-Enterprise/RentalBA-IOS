//*2016/11/30
// WarringCe
//include herder.foot

window.onload = function() {
	//------------------------------------------header------------------------------------------------------
	//header
	//var header = document.getElementById("header");
	//header.innerHTML = "<div class='x-inner clearfix'><div class='mrtop16 fl x-icons x-icons-logo'><a href='/' class='x-icons x-icons-logo'></a></div><div class='header-right fr'><div class='header-right-top'><a class='a-default'><i class='x-icons x-icons-phone fl mrtop10'></i>400-653-6600（09:00-20:00）</a>|<a>帮助中心</a></div><div class='header-sign' id='sign'></div></div><div class='header-nav fr clearfix' id='nav'></div></div>"
	//sign
	//var sign = document.getElementById("sign");
	//sign.innerHTML = "<a href='http://www.gjcar.com/web/login' class='colormain'>登录/注册</a>";
	//nav---此处修改导航
	//var nav = document.getElementById("nav");
	//nav.innerHTML = "<a href='http://www.gjcar.com/' class='cur'>首页</a><a href='http://www.gjcar.com/web/shortRentCarList'>短租自驾</a><a href='http://www.gjcar.com/web/longRent'>长租</a><a href='http://www.gjcar.com/web/active'>优惠活动</a>";
	//增加导航代码：<a href='链接地址' class='cur'>导航名称：例如短租自驾</a>
	//新增代码插入nav.innerHTML里面
	
	
	var header = document.getElementById("header");
	header.innerHTML = "<div class='header-nav clearfix' id='nav'></div>"
	// var header = document.getElementById("header");
	// header.innerHTML = "<div class='x-inner clearfix'><div class='mrtop16 fl x-icons x-icons-logo'><a id='url6' class='urll1' href='http://m.gjcar.com/wap/activity/' class='x-icons x-icons-logo '></a></div><div class='header-right fr'><div class='header-right-top'><a href='http://m.gjcar.com/' class='a-default'><i class='x-icons x-icons-phone fl mrtop10'></i></a><a></a></div><div class='header-sign' id='sign'></div></div><div class='header-nav fr clearfix' id='nav'></div></div>"
	
	//var header = document.getElementById("header");
	//header.innerHTML = "<div class='x-inner clearfix'><div class='mrtop16 fl x-icons x-icons-logo'><a href='/' class='x-icons x-icons-logo'></a></div><div class='header-right fr'><div class='header-right-top'><a class='a-default'><i class='x-icons x-icons-phone fl mrtop10'>test</i></a><a></a></div><div class='header-sign' id='sign'></div></div><div class='header-nav fr clearfix' id='nav'></div></div>"
	//sign

	// var sign = document.getElementById("sign");
	// sign.innerHTML = "<a href='http://m.gjcar.com/wap/shortRent' class='colormain'></a>";

	//return
	//var fanhui = document.getElementById("fanhui");
	//fanhui.innerHTML = "<a href=''><span class="icon-active icon-activeList" ></span></a>";
	//nav---此处修改导航
	var nav = document.getElementById("nav");
	nav.innerHTML = "<a id='url3' class='urll1'  href='http://m.gjcar.com/wap/shortRent'>短租自驾</a><a id='url4' class='urll2' href='http://m.gjcar.com/wap/longCarRental'>长租车</a><a id ='url5' class='urll3' href='http://m.gjcar.com/wap/activity' class='cur'>活动</a>";
		var aa = document.getElementsByClassName('urll1');
		for(var i =0;i<aa.length;i++){
			
			if(getUrl('channelID')!=null){
				var hrefs = aa[i].getAttribute('href')+"?channelID="+ getUrl('channelID'); 
				aa[i].setAttribute('href',hrefs);
				document.getElementsByClassName('urll2')[0].setAttribute('href','http://m.gjcar.com/wap/activity/?channelID='+getUrl('channelID'));
				document.getElementsByClassName('urll2')[0].setAttribute('href','http://m.gjcar.com/wap/longCarRental/?channelID='+getUrl('channelID'));
			}else{
				aa[i].setAttribute('href','http://m.gjcar.com/wap/shortRent');
				document.getElementsByClassName('urll2')[0].setAttribute('href','http://m.gjcar.com/wap/longCarRental');
				document.getElementsByClassName('urll3')[0].setAttribute('href','http://m.gjcar.com/wap/activity');
			}
		 
		}
		
		
		
	
	

	
	//增加导航代码：<a href='链接地址' class='cur'>导航名称：例如短租自驾</a>
	//新增代码插入nav.innerHTML里面

	//------------------------------------------footer------------------------------------------------------
	//footer
	// var footer = document.getElementById("footer");
	// footer.innerHTML = "<div class='bg1'><div class='x-indexinner x-webmap clearfix' id='footmap'></div></div><div class='footer-bottom'><div class='footer-bottomh4 tcenter'>Copyright@2008-2016 www.gjcar.com All Rights Reserved.</div><div class='footer-bottomh4 tcenter'>如果您对赶脚租车网站有任何意见，欢迎发送邮件到400_kf@gjcar.com</div><div class='footer-bottomh4 tcenter'>赶脚租车官网 沪ICP备14002670号-5 上海华晨汽车租赁有限公司 上海市杨浦区凤城路1号</div></div>"
	//footer-网站地图
	// var footmap = document.getElementById("footmap");
	// footmap.innerHTML = "<dl id='footmap01'></dl><dl id='footmap02'></dl><dl id='footmap03'></dl><dl id='footmap04'></dl><dl id='footmap05'></dl>"
	// //footer-网站地图-新手指南
	// var footmap01 = document.getElementById("footmap01");
	// footmap01.innerHTML ="<dt>新手指南</dt><dd></dd><dd><a href='http://www.gjcar.com/web/help/2/2'>自驾产品说明</a></dd><dd><a href='http://www.gjcar.com/web/help/2/3'>门到门服务说明</a></dd><dd><a href='http://www.gjcar.com/web/help/2/4'>租车条件</a></dd><dd><a href='http://www.gjcar.com/web/help/2/5'>预订方式</a></dd>"
	// //footer-网站地图-租车费用及结算
	// var footmap02 = document.getElementById("footmap02");
	// footmap02.innerHTML ="<dt>租车费用及结算</dt><dd><a href='http://www.gjcar.com/web/help/3/6'>收费项目说明</a></dd><dd><a href='http://www.gjcar.com/web/help/3/7'>支付方式</a></dd><dd><a href='http://www.gjcar.com/web/help/3/8'>结算流程</a></dd>"
	// //footer-网站地图-紧急事务处理
	// var footmap03 = document.getElementById("footmap03");
	// footmap03.innerHTML ="<dt>紧急事务处理</dt><dd><a href='http://www.gjcar.com/web/help/4/9'>保险责任</a></dd><dd><a href='http://www.gjcar.com/web/help/4/10'>事故处理</a></dd><dd><a href='http://www.gjcar.com/web/help/4/11'>救援及备用车</a></dd><dd><a href='http://www.gjcar.com/web/help/4/12'>理赔说明</a></dd>"
	// //footer-网站地图-会员管理
	// var footmap04 = document.getElementById("footmap04");
	// footmap04.innerHTML ="<dt>会员管理</dt><dd><a href='http://www.gjcar.com/web/help/5/13'>会员细则</a></dd><dd><a href='http://www.gjcar.com/web/help/5/14'>积分规则</a></dd><dd><a href='http://www.gjcar.com/web/help/5/15'>会员资格</a></dd>"
	// //footer-网站地图-关于我们
	// var footmap05 = document.getElementById("footmap05");
	// footmap05.innerHTML ="<dt>关于我们</dt><dd><a href='http://www.gjcar.com/web/help/6/16'>赶脚简介</a></dd><dd><a href='http://www.gjcar.com/web/help/6/17'>品牌故事</a></dd><dd><a href='http://www.gjcar.com/web/help/6/18'>合作伙伴</a></dd><dd><a href='http://www.gjcar.com/web/help/6/19'>联系我们</a></dd>"

		

};
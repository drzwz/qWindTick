system "l wapi.q";

//配置开始：配置需要订阅行情的代码，代码格式为Wind代码格式；可以用wset函数读取代码列表，如wset[`IndexConstituent;`$"date=20150615;windcode=000300.SH"]`data。。。

wind_sub_syms:`000001.SH`399001.SZ`600036.SH`000001.SZ`RB1801.SHF`I1801.DCE`CF1801.CZC`EURUSD.FX;   //

//配置结束

qconn:{[myport]if[not type[myport] in(-6h;-7h);:`para_error_type];
    h:@[hopen;(`$"::",string[myport],":",(first read0 `$":",getenv[`qhome],"\\qusers"); 2000);0i];
    :h;}; 
h:neg qconn[5010];if[h=0;'`tickerplant_conn_error];0N!(.z.Z;`connected_to_tickerplant;h);
 
taq:([sym:`$()]time:`time$();prevclose:`real$();open:`real$();high:`real$();low:`real$();close:`real$();volume:`real$();openint:`real$();bid:`real$();bsize:`real$();ask:`real$();asize:`real$()); /trade & quote

windtaq:([sym:`$()]rt_time:`float$();rt_pre_close:`float$();rt_open:`float$();rt_high:`float$();rt_low:`float$();rt_latest:`float$();rt_vol:`float$();rt_amt:`float$();rt_oi:`float$();rt_bid1:`float$();rt_bsize1:`float$();rt_ask1:`float$();rt_asize1:`float$());

onwsqsub:{[x]A::x;if[x[`errid]<>0;:()];mysyms:exec sym from x[`data];
	{`windtaq upsert x} each delete dt from x`data;
	taq0:taq;
    `taq upsert 1!select sym,time:num2time each rt_time,prevclose:`real$rt_pre_close,open:`real$rt_open,high:`real$rt_high,low:`real$rt_low,close:`real$rt_latest,        volume:`real$rt_vol,openint:`real$?[rt_oi>0;rt_oi;rt_amt],bid:`real$rt_bid1,bsize:`real$rt_bsize1,ask:`real$rt_ask1,asize:`real$rt_asize1  from windtaq;
    mybar::{select from x where (volume>0) or sym like "*.FX"}select time,sym,close,volume:`real$volume-0^lastvol from lj[select from taq where sym in mysyms;`sym xkey select sym,lastvol:volume from taq0 where sym in mysyms];
    {[x](`.[`h])(`.u.upd;`taq;value x);}each select time,sym,prevclose,open,high,low,close,volume,openint,bid,bsize,ask,asize from taq where sym in mysyms; 
    {[x](`.[`h])(`.u.upd;`bar;value x);}each select time,sym,close,volume from mybar;
  };
r:start[`;`];
$[0=r[`errid];
	[0N!(.z.Z;`wind_started;r[`errmsg]);wsqsub[wind_sub_syms;`$"rt_time,rt_pre_close,rt_open,rt_high,rt_low,rt_latest,rt_vol,rt_amt,rt_oi,rt_bid1,rt_bsize1,rt_ask1,rt_asize1";`]];
	0N!(.z.Z;`wind_start_error;r[`errmsg])];

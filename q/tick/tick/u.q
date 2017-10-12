/2008.09.09 .k -> .q
/2006.05.08 add

\d .u
init:{w::t!(count t::tables`.)#()}; //创建.u.t和.u.w

del:{w[x]_:w[x;;0]?y};	//del[x;y] 把连接句柄y从.z.w[x]删除
.z.pc:{del[;x]each t};  //订阅客户端连接关闭时，把它的所有订阅删除

sel:{$[`~y;x;select from x where sym in y]};   //sel[x;y] 从x表选择sym in y的记录

pub:{[t;x]{[t;x;w]if[count x:sel[x]w 1;(neg first w)(`upd;t;x)]}[t;x]each w t};  //发布名为t、值为x的表

add:{$[(count w x)>i:w[x;;0]?.z.w;.[`.u.w;(x;i;1);union;y];w[x],:enlist(.z.w;y)];(x;$[99=type v:value x;sel[v]y;0#v])};

sub:{if[x~`;:sub[;y]each t];if[not x in t;'x];del[x].z.w;add[x;y]};  //sub[x;y]订阅表名x的sym in y

end:{(neg union/[w[;;0]])@\:(`.u.end;x)};   //向所有连接句柄发送`.u.end消息

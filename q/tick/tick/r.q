/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q

if[not system"p";system"p 5011"];

.z.zd:17 3 0;   //z.
if[not "w"=first string .z.o;system "sleep 1"];

//upd:insert;
upd:{[t;x]$[t=`taq;`taq upsert `sym xkey x;t insert x];};  //z.

/ get the ticker plant and history ports, defaults are 5010,5012
//.u.x:.z.x,(count .z.x)_(":5010";":5012");
.u.x:.z.x,(count .z.x)_(":5010:kdbuser:kdbpassword";":5012:kdbuser:kdbpassword"); //z.

/ end of day: save, clear, hdb reload
//z.:At end of day, the tickerplant sends messages to all its real time subscribers, telling them to execute their monadic end of day function called `.u.end. The tickerplant supplies a date which is typically the previous day’s date. When customizing your RTS, define .u.end to achieve whatever behavior you deem appropriate at end of day. 
//z.:t@:where `g=attr each t@\:`sym;: This line obtains the subset of tables in t that have the grouped attribute on their sym column. This is done because later these tables will be emptied out and their attribute information will be lost. Therefore we store this attribute information now so the attributes can be re-applied after the clear out.
//z.:.Q.hdpf is a high level function which saves all in memory tables to disk in partitioned format, empties them out and then instructs the HDB to reload. Its inputs at runtime will be: (1)location of HDB,(2) `:. (current working directory – root of on-disk partitioned database),(3) x=2016.07.12 (input to .u.end as supplied by TP. This is the partition to write to),(4) `sym (column on which to sort/part the tables prior to persisting)
//z.:@[;`sym;`g#] each t;  applies the g attribute to the sym column of each table as previously discussed
//.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;}; //orginal

k)hdpft:{[h;d;p;f;t](@[`.;;0#].Q.dpft[d;p;f]@)'t@>(#.:)'t;if[h:@[<:;h;0];h"\\l .";>h]}; //z. added;changed from .Q.hdpf
.u.end:{t:enlist`bar;t@:where `g=attr each t@\:`sym;hdpft[`$":",.u.x 1;hsym[`$ssr[ssr[getenv[`qhome];"\\";"/"];"/q";"/hdb"]];x;`sym;t];@[;`sym;`g#] each t;};  // changed by z.; 修改保存路径；修改为只保存bar表；若要保存taq,请参照修改，并删除本文件最后一行）

/ init schema and sync up from log file;cd to hdb(so client save can run)
//z.:This function is invoked at startup once the RDB has connected/subscribed to the TP. .u.rep takes two inputs. The first input, x, is a list of two-element lists, each containing a table name (as a symbol) and an empty schema for that table. The second argument to .u.rep, y, is a single two-element list. These inputs are supplied by the TP upon subscription.y is a pair where the last element is the TP logfile and the first element is the number of messages written to this logfile so far.
//z.:(.[;();:;].)each x; ==((set[;].) each x;)This line just loops over the table name/empty table pairs and initializes these tables accordingly within the current working namespace (default namespace).
//z.:-11!y;   This line simply replays an appropriate number of messages from the start of the TP logfile. 
//z.:system "cd ",1_-10_string first reverse y;    This changes the current working directory of the RDB to the root of the on-disk partitioned database. Therefore, when .Q.hdpf is invoked at EOD, the day’s records will be written to the correct place.
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!y;system "cd ",1_-10_string first reverse y};
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
//z.:kicks the RDB into life.   hopen `$":",.u.x 0    Reading this from the right, we obtain the location of the tickerplant process which is then passed into the hopen function. hopen returns a handle (connection) to the tickerplant. Through this handle, we then send a synchronous message to the tickerplant, telling it to do two things:1. Subscribe to all tables and to all symbols. 2. Obtain name/location of TP logfile and number of messages written by TP to said logfile .  `.u `i:  .u.i - msg count in log file    `.u `L: .u.L - tp log filename, e.g. `:./sym2008.09.11

//z.:.u.sub is a dyadic function defined on the tickerplant. If passed null symbols (as is the case here), it will return a list of pairs (table name/empty table), consistent with the first input to .u.rep
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)"; //original


//z.: ref: Building Real Time Tick Subscribers q_for_Gods_Aug_2014.pdf  http://www.firstderivatives.com/downloads/q_for_Gods_July_2014.pdf

if[`taq in key `.;taq:`sym xkey taq];  //z.
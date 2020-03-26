# keepalived + nginx 高可用
[参考文献](https://www.jianshu.com/p/da26df4f7d60)


## keepalived介绍
Keepalived 是一种高性能的服务器高可用或热备解决方案,Keepalived 可以用来防止服务器单点故障的发生,通过配合 Nginx 可以实现 web 前端服务的高可用。
Keepalived 以 VRRP 协议为实现基础,用 VRRP 协议来实现高可用性(HA)。VRRP(Virtual RouterRedundancy Protocol)协议是用于实现路由器冗余的协议,
VRRP 协议将两台或多台路由器设备虚拟成一个 设备,对外提供虚拟路由器 IP(一个或多个),而在路由器组内部,如果实际拥有这个对外 IP 的路由器如果工作正常的话就是 MASTER,
或者是通过算法选举产生,MASTER 实现针对虚拟路由器 IP 的各种网络功能, 如 ARP 请求,ICMP,以及数据的转发等;其他设备不拥有该虚拟 IP,状态是 BACKUP,
除了接收 MASTER 的 VRRP 状态通告信息外,不执行对外的网络功能。当主机失效时,BACKUP 将接管原先 MASTER 的网络功能。
VRRP 协议使用多播数据来传输 VRRP 数据,VRRP 数据使用特殊的虚拟源 MAC 地址发送数据而不是自身 网卡的 MAC 地址,VRRP 运行时只有 MASTER 路由器定时发送 VRRP 通告信息,
表示 MASTER 工作正常以及虚 拟路由器 IP(组),BACKUP 只接收 VRRP 数据,不发送数据,如果一定时间内没有接收到 MASTER 的通告信 息,各 BACKUP 将宣告自己成为 MASTER,
发送通告信息,重新进行 MASTER 选举状态。

## VRRP协议
VRRP全称 Virtual Router Redundancy Protocol，即 虚拟路由冗余协议。 可以认为它是实现路由器高可用的容错协议，即将N台提供相同功能的路由器组成一个路由器组(Router Group)，这个组里面有一个master和多个backup，但在外界看来就像一台一样，构成虚拟路由器，拥有一个虚拟IP（vip，也就是路由器所在局域网内其他机器的默认路由），占有这个IP的master实际负责ARP相应和转发IP数据包，组中的其它路由器作为备份的角色处于待命状态。 master会发组播消息，当backup在超时时间内收不到vrrp包时就认为master宕掉了，这时就需要根据VRRP的优先级来选举一个 backup当master，保证路由器的高可用。
在VRRP协议实现里，虚拟路由器使用 00-00-5E-00-01-XX 作为虚拟MAC地址，XX就是唯一的 VRID （Virtual Router IDentifier），这个地址同一时间只有一个物理路由器占用。在虚拟路由器里面的物理路由器组里面通过多播IP地址 224.0.0.18 来定时发送通告消息。每个Router都有一个 1-255 之间的优先级别，级别最高的（highest priority）将成为主控（master）路由器。通过降低master的优先权可以让处于backup状态的路由器抢占（pro-empt）主路由 器的状态，两个backup优先级相同的IP地址较大者为master，接管虚拟IP。

## 虚拟IP
[参考文献](https://blog.csdn.net/whycold/article/details/11898249)
就是一个未分配给真实主机的IP，也就是说对外提供数据库服务器的主机除了有一个真实IP外还有一个虚IP，使用这两个IP中的 任意一个都可以连接到这台主机，所有项目中数据库链接一项配置的都是这个虚IP，当服务器发生故障无法对外提供服务时，动态将这个虚IP切换到备用主机。
实现原理主要是靠TCP/IP的ARP协议。因为ip地址只是一个逻辑 地址，在以太网中MAC地址才是真正用来进行数据传输的物理地址，每台主机中都有一个ARP高速缓存，存储同一个网络内的IP地址与MAC地址的对应关 系，以太网中的主机发送数据时会先从这个缓存中查询目标IP对应的MAC地址，会向这个MAC地址发送数据。操作系统会自动维护这个缓存。这就是整个实现的关键。

## 单播、多播、广播
[参考文献](https://blog.csdn.net/freestyle4568world/article/details/50609435)
- 单播：主机之间“一对一”的通讯模式，网络中的交换机和路由器对数据只进行转发不进行复制。如果10个客户机需要相同的数据，则服务器需要逐一传送，重复10次相同的工作。但由于其能够针对每个客户的及时响应，所以现在的网页浏览全部都是采用IP单播协议。网络中的路由器和交换机根据其目标地址选择传输路径，将IP单播数据传送到其指定的目的地。
    + 优点
        * 服务器及时响应客户机的请求
        * 服务器针对每个客户不通的请求发送不通的数据，容易实现个性化服务
    + 缺点
        * 服务器针对每个客户机发送数据流，服务器流量＝客户机数量×客户机流量；在客户数量大、每个客户机流量大的流媒体应用中服务器不堪重负。
        * 现有的网络带宽是金字塔结构，城际省际主干带宽仅仅相当于其所有用户带宽之和的5％。如果全部使用单播协议，将造成网络主干不堪重负。现在的P2P应用就已经使主干经常阻塞，只要有5％的客户在全速使用网络，其他人就不要玩了。而将主干扩展20倍几乎是不可能。
- 广播：有时一个主机要向网上的所有其他主机发送帧，这就是广播。（常见的ARP协议就是利用的广播）。
    + 优点：
        * 网络设备简单，维护简单，布网成本低廉
        * 由于服务器不用向每个客户机单独发送数据，所以服务器流量负载极低。
    + 缺点：
        * 无法针对每个客户的要求和时间及时提供个性化服务。
        * 网络允许服务器提供数据的带宽有限，客户端的最大带宽＝服务总带宽。例如有线电视的客户端的线路支持100个频道（如果采用数字压缩技术，理论上可以提供500个频道），即使服务商有更大的财力配置更多的发送设备、改成光纤主干，也无法超过此极限。也就是说无法向众多客户提供更多样化、更加个性化的服务。
    + **广播禁止在Internet宽带网上传输(防止引起广播风暴)**
- 多播：也可以称为“组播”，在网络技术的应用并不是很多，网上视频会议、网上视频点播特别适合采用多播方式。因为如果采用单播方式，逐个节点传输，有多少个目标节点，就会有多少次传送过程，这种方式显然效率极低，是不可取的；如果采用不区分目标、全部发送的广播方式，虽然一次可以传送完数据，但是显然达不到区分特定数据接收对象的目的。采用多播方式，既可以实现一次传送所有目标节点的数据，也可以达到只对特定对象传送数据的目的。IP网络的多播一般通过多播IP地址来实现。多播IP地址就是D类IP地址，即224.0.0.0至239.255.255.255之间的IP地址。Windows 2000中的DHCP管理器支持多播IP地址的自动分配。  
    + 优点
        * 需要相同数据流的客户端加入相同的组共享一条数据流，节省了服务器的负载。具备广播所具备的优点。 
        * 由于组播协议是根据接受者的需要对数据流进行复制转发，所以服务端的服务总带宽不受客户接入端带宽的限制。IP协议允许有2亿6千多万个（268435456）组播，所以其提供的服务可以非常丰富。 
        * 此协议和单播协议一样允许在Internet宽带网上传输。 
    + 缺点
        * 与单播协议相比没有纠错机制，发生丢包错包后难以弥补，但可以通过一定的容错机制和QOS加以弥补。
        * 现行网络虽然都支持组播的传输，但在客户认证、QOS等方面还需要完善，这些缺点在理论上都有成熟的解决方案，只是需要逐步推广应用到现存网络当中。  

##  Keepalived + nginx
keepalived可以认为是VRRP协议在Linux上的实现，主要有三个模块，分别是core、check和vrrp。core模块为keepalived的核心，负责主进程的启动、维护以及全局配置文件的加载和解析。check负责健康检查，包括常见的各种检查方式。vrrp模块是来实现VRRP协议的。本文基于如下的拓扑图：
```
                   +-------------+
                   |    uplink   |
                   +-------------+
                          |
                          +
    MASTER            keep|alived         BACKUP
172.29.88.224      172.29.88.222      172.29.88.225
+-------------+    +-------------+    +-------------+
|   nginx01   |----|  virtualIP  |----|   nginx02   |
+-------------+    +-------------+    +-------------+
                          |
       +------------------+------------------+
       |                  |                  |
+-------------+    +-------------+    +-------------+
|    web01    |    |    web02    |    |    web03    |
+-------------+    +-------------+    +-------------+

```

### 安装
```
# yum install -y keepalived
# keepalived -v
```

### nginx监控脚本
该脚本检测ngnix的运行状态，并在nginx进程不存在时尝试重新启动ngnix，如果启动失败则停止keepalived，准备让其它机器接管。可以根据自己的业务需求，总结出在什么情形下关闭keepalived，如 curl 主页连续2个3s没有响应则切换
```
#!/bin/bash
# curl -IL http://localhost/member/login.htm
# curl --data "memberName=fengkan&password=22" http://localhost/member/login.htm

count=0
for (( k=0; k<2; k++ ))
do
    check_code=$( curl --connect-timeout 3 -sL -w "%{http_code}\\n" http://localhost/login.html -o /dev/null )
    if [ "$check_code" != "200" ]; then
        count=$(expr $count + 1)
        sleep 3
        continue
    else
        count=0
        break
    fi
done
if [ "$count" != "0" ]; then
#   /etc/init.d/keepalived stop
    exit 1
else
    exit 0
fi
```

### keepalived.conf
```
! Configuration File for keepalived
global_defs {
    notification_email {
        zhouxiao@example.com
        itsection@example.com
    }
    notification_email_from itsection@example.com
    smtp_server mail.example.com
    smtp_connect_timeout 30
    router_id LVS_DEVEL
}

vrrp_script chk_nginx {
#    script "killall -0 nginx"
    script "/etc/keepalived/check_nginx.sh"
    interval 2
    weight -5
    fall 3  
    rise 2
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    mcast_src_ip 172.29.88.224
    virtual_router_id 51
    priority 101
    advert_int 2
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        172.29.88.222
    }
    track_script {
       chk_nginx
    }
}
```
在其它备机BACKUP上，只需要改变 state MASTER -> state BACKUP，priority 101 -> priority 100，mcast_src_ip 172.29.88.224 -> mcast_src_ip 172.29.88.225即可。

### 启动keepalived服务
```
service keepalived restart
```

### 配置选项说明
```
global_defs

notification_email ： keepalived在发生诸如切换操作时需要发送email通知地址，后面的 smtp_server 相比也都知道是邮件服务器地址。也可以通过其它方式报警，毕竟邮件不是实时通知的。
router_id ： 机器标识，通常可设为hostname。故障发生时，邮件通知会用到
vrrp_instance

state ： 指定instance(Initial)的初始状态，就是说在配置好后，这台服务器的初始状态就是这里指定的，但这里指定的不算，还是得要通过竞选通过优先级来确定。如果这里设置为MASTER，但如若他的优先级不及另外一台，那么这台在发送通告时，会发送自己的优先级，另外一台发现优先级不如自己的高，那么他会就回抢占为MASTER
interface ： 实例绑定的网卡，因为在配置虚拟IP的时候必须是在已有的网卡上添加的
mcast_src_ip ： 发送多播数据包时的源IP地址，这里注意了，这里实际上就是在那个地址上发送VRRP通告，这个非常重要，一定要选择稳定的网卡端口来发送，这里相当于heartbeat的心跳端口，如果没有设置那么就用默认的绑定的网卡的IP，也就是interface指定的IP地址
virtual_router_id ： 这里设置VRID，这里非常重要，相同的VRID为一个组，他将决定多播的MAC地址
priority ： 设置本节点的优先级，优先级高的为master
advert_int ： 检查间隔，默认为1秒。这就是VRRP的定时器，MASTER每隔这样一个时间间隔，就会发送一个advertisement报文以通知组内其他路由器自己工作正常
authentication ： 定义认证方式和密码，主从必须一样
virtual_ipaddress ： 这里设置的就是VIP，也就是虚拟IP地址，他随着state的变化而增加删除，当state为master的时候就添加，当state为backup的时候删除，这里主要是有优先级来决定的，和state设置的值没有多大关系，这里可以设置多个IP地址
track_script ： 引用VRRP脚本，即在 vrrp_script 部分指定的名字。定期运行它们来改变优先级，并最终引发主备切换。
vrrp_script
告诉 keepalived 在什么情况下切换，所以尤为重要。可以有多个 vrrp_script

script ： 自己写的检测脚本。也可以是一行命令如killall -0 nginx
interval 2 ： 每2s检测一次
weight -5 ： 检测失败（脚本返回非0）则优先级 -5
fall 2 ： 检测连续 2 次失败才算确定是真失败。会用weight减少优先级（1-255之间）
rise 1 ： 检测 1 次成功就算成功。但不修改优先级
这里要提示一下script一般有2种写法：

通过脚本执行的返回结果，改变优先级，keepalived继续发送通告消息，backup比较优先级再决定
脚本里面检测到异常，直接关闭keepalived进程，backup机器接收不到advertisement会抢占IP
上文 vrrp_script 配置部分，killall -0 nginx属于第1种情况，/etc/keepalived/check_nginx.sh属于第2种情况（脚本中关闭keepalived）。个人更倾向于通过shell脚本判断，但有异常时exit 1，正常退出exit 0，然后keepalived根据动态调整的 vrrp_instance 优先级选举决定是否抢占VIP：

如果脚本执行结果为0，并且weight配置的值大于0，则优先级相应的增加
如果脚本执行结果非0，并且weight配置的值小于0，则优先级相应的减少
其他情况，原本配置的优先级不变，即配置文件中priority对应的值。

提示：

优先级不会不断的提高或者降低
可以编写多个检测脚本并为每个检测脚本设置不同的weight（在配置中列出就行）
不管提高优先级还是降低优先级，最终优先级的范围是在[1,254]，不会出现优先级小于等于0或者优先级大于等于255的情况
在MASTER节点的 vrrp_instance 中 配置 nopreempt ，当它异常恢复后，即使它 prio 更高也不会抢占，这样可以避免正常情况下做无谓的切换
以上可以做到利用脚本检测业务进程的状态，并动态调整优先级从而实现主备切换。

配置结束

在默认的keepalive.conf里面还有 virtual_server,real_server 这样的配置，我们这用不到，它是为lvs准备的。 notify 可以定义在切换成MASTER或BACKUP时执行的脚本，如有需求请自行google。
```

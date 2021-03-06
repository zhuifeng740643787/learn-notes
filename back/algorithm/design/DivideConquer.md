# 分治法

## 概念
- 分而治之，就是把一个复杂的问题分成两个或更多的相同或相似的子问题，再把子问题分成更小的子问题……直到最后子问题可以简单的直接求解，原问题的解即子问题的解的合并

## 思想
- 将一个难以直接解决的大问题，分割成一些规模较小的相同问题，以便各个击破，分而治之

## 策略
- 对于一个规模为n的问题，若该问题可以容易地解决（比如说规模n较小）则直接解决，否则将其分解为k个规模较小的子问题，这些子问题互相独立且与原问题形式相同，递归地解这些子问题，然后将各子问题的解合并得到原问题的解。这种算法设计策略叫做分治法

## 所能解决问题的特征
1. 该问题的规模缩小到一定的程度就可以容易地解决
1. 该问题可以分解为若干个规模较小的相同问题，即该问题具有最优子结构性质（前提）
1. **利用该问题分解出的子问题的解可以合并为该问题的解（最关键的一点）**
1. 该问题所分解出的各个子问题是相互独立的，即子问题之间不包含公共的子子问题

上述的第一条特征是绝大多数问题都可以满足的，因为问题的计算复杂性一般是随着问题规模的增加而增加；第二条特征是应用分治法的前提它也是大多数问题可以满足的，此特征反映了递归思想的应用；第三条特征是关键，能否利用分治法完全取决于问题是否具有第三条特征，如果具备了第一条和第二条特征，而不具备第三条特征，则可以考虑用贪心法或动态规划法。第四条特征涉及到分治法的效率，如果各子问题是不独立的则分治法要做许多不必要的工作，重复地解公共的子问题，此时虽然可用分治法，但一般用动态规划法较好


## 基本步骤
分治法在每一层递归上都有三个步骤：
1. 分解：将原问题分解为若干个规模较小，相互独立，与原问题形式相同的子问题
1. 解决：若子问题规模较小而容易被解决则直接解，否则递归地解各个子问题
1. 合并：将各个子问题的解合并为原问题的解

## 设计模式

    Divide-and-Conquer(P)

    if |P|≤n0 {

      then return(ADHOC(P))

    } else {

      将P继续分解为较小的子问题 P1 ,P2 ,...,Pk

      for i←1 to k

      do yi ← Divide-and-Conquer(Pi) △ 递归解决Pi

      T ← MERGE(y1,y2,...,yk) △ 合并子问题

    }

    return(T)

其中|P|表示问题P的规模；n0为一阈值，表示当问题P的规模不超过n0时，问题已容易直接解出，不必再继续分解。
ADHOC(P)是该分治法中的基本子算法，用于直接解小规模的问题P。因此，当P的规模不超过n0时直接用算法ADHOC(P)求解。
算法MERGE(y1,y2,...,yk)是该分治法中的合并子算法，用于将P的子问题P1 ,P2 ,...,Pk的相应的解y1,y2,...,yk合并为P的解

## 应用
- 二分查找
- 大整数乘法
- 棋盘覆盖
- 归并排序
- 快速排序
- 求最大值和最小值
- 线性时间选择
- 最接近点对问题
- 循环赛日程表
- 汉诺塔


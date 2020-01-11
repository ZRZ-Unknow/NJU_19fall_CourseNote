

# 人工智能导论期末复习
___
## 搜索

+ A search problem is defined by 5 components: 
  + initial state 
  + possible actions (and state associated actions) 
  + transition model taking an action will cause a state change 
  + goal test judge if the goal state is found 
  + path cost constitute the cost of a solution

+ 评价：

  + completeness: does it always ﬁnd a solution if one exists?  
  + time complexity : number of nodes generated/expanded
  + space complexity: maximum number of nodes in memory 
  + optimality: does it always ﬁnd a least-cost solution?
___
+ (无信息搜索)Uninformed strategies use only the information available in the problem deﬁnition，除了问题定义中提供的状态信息外没有任何附加信息

  + Breadth-ﬁrst search

    用先进先出队列(FIFO)实现

  + Uniform-cost search

    优先队列，扩展路径消耗最小的结点，若每一步路径消耗相同的话，就成了宽度优先

  + Depth-ﬁrst search

    用后进先出队列(LIFO)实现

  + Depth-limited search

    设置最大深度，当到达最大深度而还未找到goal时，返回

  + Iterative deepening search

    迭代最大深度，从1~n,然后调用深度受限搜索
___
+ Informed search
  + 贪婪搜索，扩展离目标最近的结点，启发式函数为到目标的距离
  + A*搜索， f(n)=g(n)+h(n):已花费的代价+到目标的最小路径估计值
    + 可采纳性：不过高估计到达结点的代价，比如用两点间直线距离来估计，真实距离要大于等于它
    + 一致性：只作用于图搜索，对于每个结点n和通过任意行动a生成的后继结点n'，h(n)<=c(n,a,n')+h(n')，c为消耗的单步代价
___
+ 博弈
  + 初始状态，玩家，状态下可执行动作，转移模型，终止测试，效用函数
  + Minimax Algorithm:

    + max结点要选取从下面返回来的result中最大的那个，min结点相反
    + alpha-beta剪枝：
      1. α = the value of the best(i.e.,highest-value) choice we have found so far at any choice point along the path for MAX. 
      2. β = the value of the best (i.e., lowest-value) choice wehave found so farat any choice point along the path for MIN
   
___
+ bandit search
  + 多臂赌博机，K个摇臂，未知的分布，T trails
  
  + 可以每个摇臂尝试T/K次，或者都先尝试一次，然后对值最大的那个尝试剩下的
  
  + 平衡 exploration and exploitation：
    
    + with ε probability, try a random arm
    + with 1-ε probability, try the best arm
    
  +  softmax
  
  +   upper-confidence count
  
    + Choose arm with the largest value of average reward + upper confidence bound:
  
      $Q(k)+(\frac{2\ln n}{n_k})^{1/2}$  
  
      其中加号前面是这个臂到目前的收益均值，后面的叫做bonus，本质上是均值的标准差，t是目前的试验次数，Tjt是这个臂被试次数。这个公式反映一个特点：均值越大，标准差越小，被选中的概率会越来越大，同时哪些被选次数较少的臂也会得到试验机会。
___
+ Monte-Carlo Tree Search(MCTS)
  + 也叫做Upper-Confidence Tree (UCT)
  + 选择（Selection）：从根节点R开始，选择合适的子节点向下至叶子节点L（怎样选择合适的点后面再说）。
    扩展（Expansion）：除非任意一方的输赢使得游戏在L结束，否则创建一个或多个子节点并选取其中一个节点C。
    仿真（Simulation）：在从节点C开始，用随机策略进行游戏，又称为playout或者rollout。
    反向传播（Backpropagation）：把模拟的结果加到它所有的父节点上。


+ 爬山法：不断向值增加的方向持续移动
+ 模拟退火：在寻找到一个局部最优解时，赋予了它一个跳出去的概率，也就有更大的机会能找到全局最优解。
+ 遗传算法：

+ CSP问题：states deﬁned by values of a ﬁxed set of variables， goal test deﬁned by constraints on variable values
___
## Knowledge

+ 蕴含 means that one thing follows from another: 

  KB |= α： Knowledge base KB entails sentence α if and only if α is true in all worlds where KB is true

+  m is a model of a sentence α if α is true in m， M(α) is the set of all models of α。  Then KB |= α if and only if M(KB)⊆M(α) 

+ Horn子句：至多只有一个正文字的析取式如 not L1 析取 not L2 析取 L3

+ 一阶逻辑，有常量，等号，变量，函数，谓词
___
## Uncertainty

## Learning

+ 归纳学习


  选取使信息熵最大的属性：$H(V)=-\sum_{k}P(v_k)\log P(v_k)$.

+ 最近邻，用来聚类

+ 贝叶斯分类：fast, good accuracy in many cases,output a probability,无参数，naturally handle multi-class， 缺点：参数独立假设可能会损害精确度，具体过程见实验报告3

___
+ 独立同分布假设：all training examples and future (test) examples are drawn independently from an identical distribution, the label is assigned by a fixed ground-truth function

+ 方差与偏差：![](C:\Users\Jaqen\Desktop\pic\7.png)

  大的假设空间，则偏差较小，方差较大

+ 泛化误差：‣more examples

   ‣smaller hypothesis space

  ‣smaller training error

+ PAC可学习：
___
+ 线性模型：$f(x)=w^Tx+b$ , $y=w_1x+w_2x^2+w_3x^3$ ,也可写成这种形式，所以是线性模型

  求均方误差，可有闭式解 $\frac{1}{m}\sum_{i=1}^n(w^Tx_i+b-y_i)^2$, 使用范数来正则化：

  $argmin \frac{1}{m}\sum_{i=1}^n(w^Tx_i+b-y_i)^2 +\lambda ||w||$


___
+ 逻辑斯蒂回归：最小化对数似然


___
## 强化学习

<A,S,R,P>:

+ Actionspace: A
+ Statespace: S 
+ Reward: R : S x A x S -> R 
+ Transition: P : S x A->S

RL和规划的不同：Planing: ﬁnd an optimal solution ，RL: ﬁnd an optimal policy from samples

RL和监督学习：SL从带标签的数据中学习，开环，RL闭环，从延迟的奖赏学习

马尔可夫过程：

Q函数：



## 深度学习

CNN:
___
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>XiyouLinux Group图书借阅</title>
    <meta name="viewport" content="width=device-width,inital-scale=1,maxmum-scale=1,user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="HandleFriendly" content="true">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/img/xiyoulinux.png">
    <!--font-awesome矢量图标-->
    <link href="${pageContext.request.contextPath}/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/index.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/index1.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/showtype.css" rel="stylesheet">
</head>

<body>
<header>
    <div id="hea">
        <img id="index_head" src="${pageContext.request.contextPath}/img/index_head.png"/>
        <a id="head" href="${pageContext.request.contextPath}/auth/">XiyouLinux Group 图书借阅</a>
        <form id="index1_input" action="${pageContext.request.contextPath}/auth/search" method="post">
            <input type="text" placeholder="搜索书名/作者/归属者" name="keyword">
            <button class="btn btn-link">搜索</button>
            <a href="${pageContext.request.contextPath}/auth/mybook/"><i class="fa fa-file-text fa-fw"></i>我的书籍</a>
            <a href="${pageContext.request.contextPath}/auth/upload"><i class="fa fa-tags fa-fw"></i>上传书籍</a>
        </form>
        <a id="index1_sign" href="${pageContext.request.contextPath}/logout.do">退出登录</a>
    </div>
</header>
<div id="main">
    <div id="main_head"><a href="${pageContext.request.contextPath}/auth/">首页</a><i class="fa fa-lg fa-angle-right"></i>搜索
        <i class="fa fa-lg fa-angle-right"></i>${keyword}
    </div>

    <c:forEach items="${books}" var="book">
        <div class="rows" id="con">
            <div class="col-xs-12 col-md-2 book_img">
                <img src="${book.key.bookPicture}">
            </div>
            <div class="book_info col-xs-12 col-md-8">
                <p>《${book.key.ugkName}》----- ${book.key.author}</p>
                <p>${book.key.describ}</p>
                <p><span><i class="fa fa-user"></i>${book.value}</span>
                    <span><i class="fa fa-book"></i>${book.key.amount}本</span>
                    <span><i class="fa  fa-clock-o"></i>${book.key.uploadDate}</span>
                </p>
            </div>
            <div class="col-xs-12 col-md-2">
                <button class="btn"><a href="/auth/showBook/${book.key.pkId}">点我借阅</a></button>
            </div>
            <div style="clear:both"></div>
        </div>
    </c:forEach>

    <div id="index_pingination">
        <ul class="pagination">
            <%--当当前页面不是第一页的时候, 要显示"首页"和"<<"按钮--%>
            <c:if test="${pageInfo.currentPage != 1 && pageInfo.totalPage != 0}">
                <li><a href="${pageContext.request.contextPath}/auth/search?keyword=${keyword}&page=${1}">首页</a></li>
                <li>
                    <a href="${pageContext.request.contextPath}/auth/search?keyword=${keyword}&page=${pageInfo.currentPage-1}">&laquo;</a>
                </li>
            </c:if>

            <%--当当前页面大于等于6页的时候, 要显示"[...]"按钮--返回到前一个5页--%>
            <c:if test="${pageInfo.currentPage >= 6}">
                <li>
                    <a href="${pageContext.request.contextPath}/auth/search?keyword=${keyword}&page=${returnPreFivePage}">[...]</a>
                </li>
            </c:if>

            <%--显示当前页面所有应显示的页码--%>
            <c:forEach varStatus="i" begin="${ELPageValue+1}"
                       end="${ELPageValue+5}" step="${1}">
                <c:if test="${i.current <= pageInfo.totalPage}">
                    <%--当前页的超链接处理为不可点击--%>
                    <c:if test="${i.current == pageInfo.currentPage}">
                        <li class="pa_in"><a disabled="true">${pageInfo.currentPage}</a></li>
                    </c:if>
                    <c:if test="${i.current != pageInfo.currentPage}">
                        <li>
                            <a href="${pageContext.request.contextPath}/auth/search?keyword=${keyword}&page=${i.current}">${i.current}</a>
                        </li>
                    </c:if>
                </c:if>
            </c:forEach>

            <%--如果不是最后一个五页中的页码, 要在后面显示[...]按钮--跳到下一个5页--%>
            <c:if test="${pageInfo.currentPage < isOneOfNextFivePage && pageInfo.totalPage >= 6}">
                <li>
                    <a href="${pageContext.request.contextPath}/auth/search?keyword=${keyword}&page=${reachNextFivePage}">[...]</a>
                </li>
            </c:if>

            <%--如果不是尾页, 要显示">>"和"尾页"按钮--%>
            <c:if test="${pageInfo.currentPage != pageInfo.totalPage && pageInfo.totalPage != 1 && pageInfo.totalPage != 0}">
                <li>
                    <a href="${pageContext.request.contextPath}/auth/search?keyword=${keyword}&page=${pageInfo.currentPage+1}">&raquo;</a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/auth/search?keyword=${keyword}&page=${pageInfo.totalPage}">尾页</a>
                </li>
            </c:if>
        </ul>
    </div>
</div>

<footer>
    <div class="rows">
        <div class="col-xs-6 col-md-3">
            <p class="footer_head">友情链接</p>
            <p><a href="https://www.xiyoulinux.org">西邮Linux兴趣小组</a></p>
            <p><a href="http://blog.xiyoulinux.org">西邮Linux兴趣小组 群博</a></p>
            <p><a href="http://www.xiyou.edu.cn/jgsz/yxsz1/jsj31.htm">西安邮电大学计算机学院</a></p>
            <p><a href="http://kerneltravel.eefocus.com">Linux内核之旅</a></p>
            <p><a href="https://www.kernel.org">The Linux Kernel Archives</a></p>
            <p><a href="https://www.linuxfoundation.org">The Linux Foundation</a></p>
        </div>
        <div class="col-xs-6 col-md-3">
            <p class="footer_head">社区</p>
            <p>邮件列表：<a href="https://groups.google.com/forum/#!forum/xiyoulinux">xiyouLinux</a></p>
            <p>新浪微博：<a href="https://weibo.com/xylinux">@西邮Linux兴趣小组</a></p>
            <p>GNU：<a href="https://www.gnu.org">GNU's Not Unix</a></p>
            <p>LWN：<a href="https://lwn.net">Linux Weekly News</a></p>
            <p>Linux Story：<a href="https://linuxstory.org">Linux Story</a></p>
        </div>
        <div class="col-xs-6 col-md-3">
            <p class="footer_head">联系我们</p>
            <p><span><i class="fa fa-map-marker"></i>地址：陕西省 西安市 长安区 西安邮电大学长安校区 东区 教学实验楼 FZ118</span></p>
            <p><span><i class="fa fa-envelope"></i>邮编：710121</span></p>
        </div>
        <div class="col-xs-6 col-md-3">
            <p class="footer_head">关注我们</p>
            <img src="${pageContext.request.contextPath}/img/weixin.jpg">
        </div>
        <div style="clear: both;height:0;"></div>
    </div>
    <div id="foot">
        <p>Copyright @ 2006-2018 西邮Linux兴趣小组 </p>
        <p>All Rights Reserved</p>
    </div>
</footer>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/canvas1.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/index.js"></script>
</body>

</html>
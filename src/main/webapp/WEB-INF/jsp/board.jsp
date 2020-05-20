<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>석주잉 게시판</title>
    <link rel="stylesheet" href="/static/css/common.css"/>
    <link rel="stylesheet" href="/static/css/board.css"/>
    <script src="http://code.jquery.com/jquery-3.5.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>
    <script src="/static/js/common.js"></script>
    <script src="/static/js/board.js"></script>
    <script src="/static/js/login.js"></script>
</head>
<body>
    <div class="wrap">
        <div class="login">
            <c:choose>
                <c:when test="${loginMember == null}">
                    <button id="login" class="button1" onclick="$.btnClick(this)">로그인</button>
                </c:when>
                <c:otherwise>
                    <button id="logout" class="button1" onclick="$.btnClick(this)">로그아웃</button>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="title">석주잉 게시판</div>
        <div class="top-bar">
            <div>
                <select id="category" class="swal2-select">
                    <option value=전체보기>전체보기</option>
                    <c:forEach var="category" items="${categories}">
                        <c:if test="${category.categoryId != 9999}">
                            <c:choose>
                                <c:when test="${selectCategory == category.categoryName}">
                                    <option value="${category.categoryName}" selected>${category.categoryName}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${category.categoryName}">${category.categoryName}</option>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </c:forEach>
                </select>
            </div>
            <div>
                <select id="list-size" class="swal2-select">
                    <c:choose>
                        <c:when test="${selectSize == 1}">
                            <option value="1" selected>1개씩 보기</option>
                        </c:when>
                        <c:otherwise>
                            <option value="1">1개씩 보기</option>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${selectSize == 5}">
                            <option value="5" selected>5개씩 보기</option>
                        </c:when>
                        <c:otherwise>
                            <option value="5">5개씩 보기</option>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${selectSize == 10}">
                            <option value="10" selected>10개씩 보기</option>
                        </c:when>
                        <c:otherwise>
                            <option value="10">10개씩 보기</option>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${selectSize == 15}">
                            <option value="15" selected>15개씩 보기</option>
                        </c:when>
                        <c:otherwise>
                            <option value="15">15개씩 보기</option>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${selectSize == 20}">
                            <option value="20" selected>20개씩 보기</option>
                        </c:when>
                        <c:otherwise>
                            <option value="20">20개씩 보기</option>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${selectSize == 30}">
                            <option value="30" selected>30개씩 보기</option>
                        </c:when>
                        <c:otherwise>
                            <option value="30">30개씩 보기</option>
                        </c:otherwise>
                    </c:choose>
                </select>
            </div>
        </div>
        <div class="board">
            <table class="board">
                <tr>
                    <th>글번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회</th>
                    <th>♥</th>
                </tr>
            <c:forEach var="board" items="${boards}">
                <tr>
                    <td>${board.boardId}</td>
                    <td>
                        <c:if test="${board.category != '없음'}">
                            <span class="category">[${board.category}]</span>
                        </c:if>
                            ${board.title}
                    <c:if test="${board.replies != 0}">
                        <span class="replies">[${board.replies}]</span>
                    </c:if>
                    </td>
                    <td>
                        <c:if test="${board.profile != null}">
                            <!-- 사진 조그맣게 넣을 공간 -->
                        </c:if>
                        ${board.writer}
                    </td>
                    <td>${board.date}</td>
                    <td>${board.views}</td>
                    <td>${board.likes}</td>
                </tr>
            </c:forEach>
            </table>
        </div>
        <div class="bottom-bar">
            <div>
                <button id="write" class="button1">글쓰기</button>
            </div>
            <div>
                <c:if test="${startPage != 1}">
                    <button id="prev" class="button1" onclick="$.prev(${startPage})">이전</button>
                </c:if>
                <c:choose>
                    <c:when test="${totalPage > (startPage + 9)}">
                        <c:set var="endPage" value="${startPage + 9}"></c:set>
                    </c:when>
                    <c:otherwise>
                        <c:set var="endPage" value="${totalPage}"></c:set>
                    </c:otherwise>
                </c:choose>
                <c:forEach begin="${startPage}" end="${endPage}" varStatus="status">
                    <span class="page-num <c:if test="${status.index == curPage}">cur-page</c:if>" onclick="$.reload(this.innerHTML)">${status.index}</span>
                </c:forEach>
                <c:if test="${endPage != totalPage}">
                    <button id="next" class="button1" onclick="$.next(${endPage})">다음</button>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>

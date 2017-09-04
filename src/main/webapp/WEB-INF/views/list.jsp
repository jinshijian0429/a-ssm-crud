<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工列表</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!--APP_PATH="/a-ssm-crud"  -->
<!--1.不以"/"开始的相对路径,以当前资源路径 为基准,经常出问题
    2.以"/"开始的绝对路径,以当前服务器路径为标准(http://localhost:3306)路径中"/"代表它;
                 但是需要加上项目名http://localhost:3306/a-ssm-crud-->
<!-- 引入jQuery -->
<script type="text/javascript"
	src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
<!--引入分页bootstrap样式   -->
<link
	href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

	<!-- 搭建显示页面 -->
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<div class="row">
			<div class="col-md-4 col-md-offset-10">
				<button class="btn btn-primary">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		<br><br>
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover">
					<tr>
						<th>#</th>
						<th>empName</th>
						<th>gender</th>
						<th>email</th>
						<th>deptName</th>
						<th>操作</th>
					</tr>
					<c:forEach items="${pageInfo.list}" var="emp">
					<tr>
						<td>${emp.empId}</td>
						<td>${emp.empName}</td>
						<td>${emp.gender=="M" ? "男":"女"}</td>
						<td>${emp.email}</td>
						<td>${emp.department.deptName}</td>
						<td>
							<button class="btn btn-primary btn-xs">
								<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
								编辑
							</button>
							<button class="btn btn-danger btn-xs">
								<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
								删除
							</button>
					</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<div class="row">
			<div class="col-md-6" style="font-weight:bold;font-size:15px">
			当前第<kbd>${pageInfo.pageNum}</kbd>页,共有<kbd>${pageInfo.pages}</kbd>页,
			总计<kbd>${pageInfo.total}</kbd>条记录
			</div>
			<div class="col-md-6">
				<nav aria-label="Page navigation" >
				<ul class="pagination">
				    <c:if test="${pageInfo.pageNum!=1}">
				    <li><a href="${APP_PATH}/emps?pn=1">首页</a></li>
				    </c:if>
				    <c:if test="${pageInfo.hasPreviousPage}">
					<li><a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous"> <span
							aria-hidden="true">&laquo;</span>
					</a></li>
					</c:if>
					
					<c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
					  <c:if test="${pageInfo.pageNum==page_Num}">
					   <li class="active"><a href="${APP_PATH}/emps?pn=${page_Num}">${page_Num}</a></li>
                      </c:if>
                      <c:if test="${pageInfo.pageNum != page_Num}">
                        <li><a href="${APP_PATH}/emps?pn=${page_Num}">${page_Num}</a></li>
                      </c:if>					
					</c:forEach>
					
					<c:if test="${pageInfo.hasNextPage}">
					<li><a href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1}" aria-label="Next"> <span
							aria-hidden="true">&raquo;</span>
					</a></li>
					</c:if>
					<c:if test="${pageInfo.pageNum!=pageInfo.pages}">
					<li><a href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a></li>
					</c:if>
				</ul>
				</nav>
			</div>
		</div>
	</div>
</body>
</html>
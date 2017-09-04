<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工的的列表</title>
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
<!--更新修改员工模态框  -->
	<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">员工修改</h4>
				</div>
				<!--表单设计  -->
				<form class="form-horizontal">
					<div class="form-group">
						<label for="input_EmpName_update" class="col-sm-2 control-label">EmpName</label>
						<div class="col-sm-10">
							<p class="form-control-static" id="empName_update"></p>
						<span class="help-block"></span>
						</div>
					</div>
					<div class="form-group">
						<label for="input_Email_update" class="col-sm-2 control-label">Email</label>
						<div class="col-sm-10">
							<input type="text" name="email" class="form-control"
								id="input_Email_update" placeholder="Email@xxx.com">
						<span class="help-block"></span>
						</div>
					</div>

					<div class="form-group">
						<label for="update_Gender" class="col-sm-2 control-label">Gender</label>
						<div class="col-sm-10">
							<label class="radio-inline"> <input type="radio"
								name="gender" id="gender-update-male" value="M" checked="checked">男
							</label> <label class="radio-inline"> <input type="radio"
								name="gender" id="gender-update-female" value="F">女
							</label>
						</div>
					</div>

					<div class="form-group">
						<label for="update_Department" class="col-sm-2 control-label">Department</label>
						<div class="col-sm-4">
							<select class="form-control" name="dId" id="update_depts_select">
								
							</select>
						</div>
					</div>
				</form>

				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="save_update_emp">更新</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
	
	<!--新增员工模态框  -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">员工新增</h4>
				</div>
				<!--表单设计  -->
				<form class="form-horizontal">
					<div class="form-group">
						<label for="input_EmpName" class="col-sm-2 control-label">EmpName</label>
						<div class="col-sm-10">
							<input type="text" name="empName" class="form-control"
								id="input_EmpName" placeholder="EmpName">
						<span class="help-block"></span>
						</div>
					</div>
					<div class="form-group">
						<label for="input_Email" class="col-sm-2 control-label">Email</label>
						<div class="col-sm-10">
							<input type="text" name="email" class="form-control"
								id="input_Email" placeholder="Email@xxx.com">
						<span class="help-block"></span>
						</div>
					</div>

					<div class="form-group">
						<label for="input_Gender" class="col-sm-2 control-label">Gender</label>
						<div class="col-sm-10">
							<label class="radio-inline"> <input type="radio"
								name="gender" id="gender-male" value="M" checked="checked">男
							</label> <label class="radio-inline"> <input type="radio"
								name="gender" id="gender-female" value="F">女
							</label>
						</div>
					</div>

					<div class="form-group">
						<label for="input_Department" class="col-sm-2 control-label">Department</label>
						<div class="col-sm-4">
							<select class="form-control" name="dId" id="depts_select">
								
							</select>
						</div>
					</div>
				</form>

				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="save_add_emp">保存</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 搭建显示页面 -->
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<div class="row">
			<div class="col-md-4 col-md-offset-10">
				<button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
				<button class="btn btn-danger" id="emp_delete_btn">删除</button>
			</div>
		</div>
		<br> <br>
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
						    <th><input type="checkbox" id="check_all"/></th>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<div class="row">
			<div class="col-md-6" style="font-weight: bold; font-size: 15px;"
				id="page_info_area"></div>

			<div class="col-md-4" id="page_nav_area"></div>
		</div>
	</div>
	<script type="text/javascript">
	//全局参数总记录数    
	var totalRecord;
	var currentPage;
	    //页面加载完毕即刻发送请求
		$(function() {
			//页面一加载进来,调用ajax请求去首页
			to_page(1);
		});
        //跳转至指定页码页面方法
		function to_page(pn) {
			$("#check_all").prop("checked",false);
			$.ajax({
				url : "${APP_PATH}/emps",
				data : "pn=" + pn,
				type : "GET",
				success : function(result) {
					//console.log(result);
					//1.解析员工数据表
					build_page_table(result);
					//2.解析分页信息
					build_page_info(result);
					//3.解析分页条数据
					build_page_nav(result);
				}
			});
		}
		//解析显示当前页面员工数据表格table的方法
		function build_page_table(result) {
			$("#emps_table tbody").empty();
			var emps = result.extend.pageInfo.list;
			$.each(emps, function(index, item) {
				var checkTd=$("<td><input type='checkbox' class='check_item'/></td>");
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(
						item.gender == "M" ? "男" : "女");
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>")
						.append(item.department.deptName);
				var editTd = $("<button></button>").addClass(
						"btn btn-primary btn-xs edit_btn")
						.attr("edit-id",item.empId)
						.append(
						$("<span></span>").addClass(
								"glyphicon glyphicon-pencil").attr(
								"aria-hidden", "true")).append("编辑");
				var delTd = $("<button></button>").addClass(
						"btn btn-danger btn-xs delete_btn")
						.attr("del-id",item.empId).attr("del-name",item.empName)
						.append(
						$("<span></span>")
								.addClass("glyphicon glyphicon-trash").attr(
										"aria-hidden", "true")).append("删除");
				var btnTd = $("<td></td>").append(editTd).append(" ").append(
						delTd);
				$("<tr></tr>").append(checkTd).append(empIdTd).append(empNameTd).append(
						genderTd).append(emailTd).append(deptNameTd).append(
						btnTd).appendTo("#emps_table tbody");
			});
		};
        //显示分页信息方法
		function build_page_info(result) {
			$("#page_info_area").empty();
			$("#page_info_area").append(
					"当前第<kbd>" + result.extend.pageInfo.pageNum
							+ "</kbd>页,共有<kbd>" + result.extend.pageInfo.pages
							+ "</kbd>页,总计<kbd>" + result.extend.pageInfo.total
							+ "</kbd>条记录");
			totalRecord=result.extend.pageInfo.total;
			currentPage=result.extend.pageInfo.pageNum;
		}
        
		//构建分页导航条方法
		function build_page_nav(result) {
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			var firstPageLi = $("<li></li>").append(
					$("<a></a>").append("首页").attr("href", "#"));

			var prePageLi = $("<li></li>").append(
					$("<a></a>").attr("aria-label", "Previous").append(
							$("<span></span>").attr("aria-hidden", "true")
									.append("&laquo;")));

			var nextPageLi = $("<li></li>").append(
					$("<a></a>").attr("aria-label", "Next").append(
							$("<span></span>").attr("aria-hidden", "true")
									.append("&raquo;")));

			var lastPageLi = $("<li></li>").append(
					$("<a></a>").append("末页").attr("href", "#"));

			if (result.extend.pageInfo.hasPreviousPage == true) {
				firstPageLi.click(function() {
					to_page(1);
				});
				prePageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum - 1);
				});
				ul.append(firstPageLi).append(prePageLi);
			}

			$.each(result.extend.pageInfo.navigatepageNums, function(index,
					item) {
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				if (result.extend.pageInfo.pageNum == item) {
					numLi.addClass("active");
				}
				numLi.click(function() {
					to_page(item);
				});
				ul.append(numLi);
			});

			if (result.extend.pageInfo.hasNextPage == true) {
				nextPageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum + 1);
				});
				lastPageLi.click(function() {
					to_page(result.extend.pageInfo.pages);
				});
				ul.append(nextPageLi).append(lastPageLi);
			}

			var nav = $("<nav></nav>").attr("aria-label", "Page navigation")
					.append(ul);

			nav.appendTo("#page_nav_area");
		}
		//重置表单样式和内容的方法
		function resetForm(elm){
			//清空文本框内容
			$(elm)[0].reset();
			//清空样式
			$(elm).find("*").removeClass("has-error has-success");
			$(elm).find("span").text("");
		}

		$("#emp_add_modal_btn").click(function() {
			//每次点击都完全重置表单内容和样式
			resetForm("#empAddModal form");
			
			   getDepts("#depts_select");
			   
			$("#empAddModal").modal({
				backdrop : "static",
				keyboard : true
			});
		});
		
		//获取部门信息的方法
		function getDepts(elm){
			$(elm).empty();
			$.ajax({
				url:"${APP_PATH}/depts",
				type: "GET",
				success:function(result){
					//console.log(result);
					$.each(result.extend.depts,function(){
						var option=$("<option></option>").append(this.deptName).attr("value",this.deptId);
						option.appendTo(elm);
					});
				}
			});
		};
		
		function show_validate_msg(elm,status,msg){
			$(elm).parent().removeClass("has-success has-error");
			$(elm).next("span").text("");
			if(status=="success"){
				$(elm).parent().addClass("has-success");
				$(elm).next("span").text(msg);
			}else if(status=="error"){
				$(elm).parent().addClass("has-error");
				$(elm).next("span").text(msg);
			}
		}
		
		//校验方法
		  /* function validate_add_form(eml){
			//校验名字
			  var empName=$("#input_EmpName").val();
			var regName=/(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
			if(!regName.test(empName)){
				show_validate_msg("#input_EmpName", "error", "用户名必须是2-5位汉字或5-16位英文字母");
		 		return false;
			}else{
				show_validate_msg("#input_EmpName", "success", "");
			}   
			//校验邮箱信息
			
			var email=$(eml).val();
			var regEmail=/^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/;
			if(!regEmail.test(email)){
				show_validate_msg(eml, "error", "邮箱地址格式不正确");
				return false;
			}else{
				show_validate_msg(eml, "success", "");
				return true;
			}
		}   */
		//为用户名框添加事件
		var namemsg;
		$("#input_EmpName").change(function(){
			 $.ajax({
				url:"${APP_PATH}/checkuser",
				type:"POST",
				data:"empName="+this.value,
				success:function(result){
					if(result.code==100){
						show_validate_msg("#input_EmpName", "success", "用户名可用");
						$("#save_add_emp").attr("checkUse","success");
					}else if(result.code==200){
						show_validate_msg("#input_EmpName", "error", result.extend.va_msg);
						namemsg=result.extend.va_msg;
						$("#save_add_emp").attr("checkUse","error");
					}
				}
			 });
		});
		
		//为邮箱框添加事件
		var emailmsg;
		$("#input_Email").change(function(){
			 $.ajax({
				url:"${APP_PATH}/checkEmail",
				type:"POST",
				data:"email="+this.value,
				success:function(result){
					if(result.code==100){
						show_validate_msg("#input_Email", "success", "邮箱可用");
						$("#save_add_emp").attr("checkEmail","success");
					}else if(result.code==200){
						show_validate_msg("#input_Email", "error", result.extend.va_email);
						emailmsg=result.extend.va_email;
						$("#save_add_emp").attr("checkEmail","error");
					}
				}
			 });
		});
		
	    // 保存新增员工信息事件
		$("#save_add_emp").click(function(){
			if($("#input_EmpName").val()!="" && $("#input_Email").val()!=""){
				if($(this).attr("checkUse") == "error"){
				    show_validate_msg("#input_EmpName", "error",namemsg);
					if($(this).attr("checkEmail") == "error"){
					 show_validate_msg("#input_Email", "error",emailmsg);
					 return false;
					}
					return false;
				}else if($(this).attr("checkUse") != "error"){
					if($(this).attr("checkEmail") == "error"){
						show_validate_msg("#input_Email", "error",emailmsg);
						return false;
					}
				}
			}else{
				return false;
			} 
			//用户名校验
			/* if($(this).attr("checkUse")=="error"){
				show_validate_msg("#input_EmpName", "error",namemsg);
				return false;
			}
			
			// 发送请求前先进行数据校验
			if(!validate_add_form()){
				show_validate_msg("#input_Email", "error", "邮箱地址格式不正确");
				return false;
			}; */
			
			// 发送ajax请求到服务器
               	$.ajax({
               		url:"${APP_PATH}/emp",
               		type: "POST",
               		data:$("#empAddModal form").serialize(),
              		success:function(result){
               			if(result.code==100){
               			    //点击保存,关闭模态框
               				$("#empAddModal").modal('hide');
                       		//显示最新添加的信息页面
                       		to_page(totalRecord);
               			}else if(result.code==200){
               				if(result.extend.errors.empName != undefined){
               					show_validate_msg("#input_EmpName", "error",
               							           result.extend.errors.empName);	
               				}
               				if(result.extend.errors.email != undefined){
               					show_validate_msg("#input_Email", "error",
               							           result.extend.errors.email);
               				}
               				return false;
               				
               			}
               		}
               	});
			
		});
	    
	    //编辑按钮事件
		$(document).on("click",".edit_btn",function(){
			// 每次点击都完全重置表单内容和样式
			//resetForm("#empUpdateModal form");
			//查询部门信息
			   getDepts("#update_depts_select");
			//查询员工信息
			  var id=$(this).attr("edit-id");
			  getEmp(id);
			 //弹出员工修改模态框  
			$("#empUpdateModal").modal({
				backdrop : "static",
				keyboard : true
			});
			//为每个模态框的更新按钮添加id属性
			$("#save_update_emp").attr("edit-id",id);
		});
	    
	    //获取员工信息方法
        function getEmp(id){
	    	$.ajax({
	    		url:"${APP_PATH}/emp/"+id,
	    		type:"GET",
	    		success:function(result){
	    			//console.log(result);
	    			$("#empName_update").text(result.extend.emp.empName);
	    			$("#input_Email_update").val(result.extend.emp.email);
	    			$("#empUpdateModal :input[name=gender]").val([result.extend.emp.gender]);
	    			$("#update_depts_select").val([result.extend.emp.dId]);
	    		}
	    	});
	    };
	    
	    //更新按钮点击事件
	    $("#save_update_emp").click(function(){
	    	//先验证邮箱格式是否合法
	    	var email=$("#input_Email_update").val();
			var regEmail=/^([a-z0-9A-Z]+[-|\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\.)+[a-zA-Z]{2,}$/;
			if(!regEmail.test(email)){
				show_validate_msg("#input_Email_update", "error", "邮箱地址格式不正确");
				return false;
			}else{
				show_validate_msg("#input_Email_update", "success","");
			} 
	     //发送ajax请求保存更新的员工数据
	       $.ajax({
	    	   url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
	    	   type:"PUT",
	    	   data:$("#empUpdateModal form").serialize(),
	    	   success:function(result){
	    		   if(result.code==200){
	    		     show_validate_msg("#input_Email_update", "error", result.extend.update_email_msg);
	    		     return false;
	    		   }
	    		  // alert(result.msg);
	    		   //点击保存,关闭模态框
      				$("#empUpdateModal").modal('hide');
              		//显示最新添加的信息页面
              		to_page(currentPage);
	    	   }
	       });
	    
	    });
	    
	    //总全选框点击事件
	    $("#check_all").click(function(){
	        $(".check_item").prop("checked",$(this).prop("checked"));
	    });
	    
	    // 单独多选框点击事件
	    $(document).on("click",".check_item",function(){
	    	var flag = ($(".check_item:checked").length==$(".check_item").length);
	    	$("#check_all").prop("checked",flag);
	    	
	    }); 
	    
	  //编辑单个删除按钮事件
	    $(document).on("click",".delete_btn",function(){
	    	var deleteName=$(this).attr("del-name");
	    	if(!confirm("确定要删除["+deleteName+"]的信息吗?")){
				return false;
				}
	    	$.ajax({
	    		url:"${APP_PATH}/emp/"+$(this).attr("del-id"),
	    		type:"DELETE",
	    		success:function(result){
	    			to_page(currentPage);
	    			}
	    	}); 
	    });
	    //批量删除按钮点击事件
	    $("#emp_delete_btn").click(function(){
	    	//遍历所有被选中的元素
	    	var empNames="";
	    	var empIds="";
	    	if($(".check_item:checked").length==0){
	    		return false;
	    	}
	    	$.each($(".check_item:checked"),function(){
	    		empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
	    		empIds += $(this).parents("tr").find("td:eq(1)").text()+"-";
	    	});
	    	 empNames=empNames.substring(0, empNames.length-1);
	    	 empIds=empIds.substring(0, empIds.length-1);
	    	
	    	 //询问是否删除
	    	 if(!confirm("确定删除["+empNames+"]的信息吗?")){
	    		 return false;
	    	 }
	    	 
	    	 //确定删除,发送ajax请求
	    	 $.ajax({
	    		 url:"${APP_PATH}/emp/"+empIds,
	    		 type:"DELETE",
	    		 success:function(result){
	    			 alert(result.msg);
	    			 to_page(currentPage);
	    		 }
	    	 });
	    });
	</script>
</body>
</html>
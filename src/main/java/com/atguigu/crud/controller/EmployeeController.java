package com.atguigu.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;
	
	/**
	 * 删除单一员工
	 * @param id
	 * @return
	 * @author: JSJ
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	public Msg deleteEmp(@PathVariable("ids") String ids){
		//判断是否批量删除
		if(ids.contains("-")){
		String[] str_ids=ids.split("-");
		List<Integer> del_ids=new ArrayList<>();
		for (String idstr : str_ids) {
			Integer id=Integer.parseInt(idstr);
			del_ids.add(id);
		}
		employeeService.deleteEmps(del_ids);
		 return Msg.success();
		}else {
			Integer id=Integer.parseInt(ids);
			employeeService.deleteEmp(id);
			return Msg.success();
		}
		
	}
	/**
	 * 保存更新的员工数据
	 * @param employee
	 * @return
	 * @author: JSJ
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	public Msg updateEmp(Employee employee){
		//System.out.println("请求更新的员工信息: "+employee);
		try {
			employeeService.updateEmp(employee);
		} catch (Exception e) {
			return Msg.fail().add("update_email_msg", "此邮箱已被使用");
		}
		
		return Msg.success();
	}
	
	/**
	 * 根据id获取单个员工信息
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	public Msg getEmp(@PathVariable("id") Integer id){
	  	Employee employee = employeeService.getEmp(id);
	  	return Msg.success().add("emp", employee);
	}
	
	/**
	 * 校验新增员工邮件地址是否可用
	 */
	@ResponseBody
	@RequestMapping("/checkEmail")
	public Msg checkEmail(@RequestParam("email") String email) {
		//邮箱格式校验
		  String regx="^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
		  if(!email.matches(regx)){
			  return Msg.fail().add("va_email","邮箱地址格式错误");
		  }
		
		//数据库邮箱校验
		long a = employeeService.checkEmail(email);
		if (a > 0) {
			return Msg.fail().add("va_email", "此邮箱已被使用");
		} else {
		    return Msg.success();
		}
	}

	/**
	 * 校验新增员工姓名是否可用
	 */
	@ResponseBody
	@RequestMapping("/checkuser")
	public Msg checkuser(@RequestParam("empName") String empName) {
		//用户名格式校验
		  String regx="(^[a-zA-Z0-9_-]{5,16}$)|(^[\u2E80-\u9FFF]{2,5}$)";
		  if(!empName.matches(regx)){
			  return Msg.fail().add("va_msg","用户名必须是2-5位汉字或5-16位英文字母");
		  }
		
		//数据库用户名校验
		long b = employeeService.checkUser(empName);
		if (b > 0) {
			return Msg.fail().add("va_msg", "用户名被占用");
		} else {
		    return Msg.success();
		}
	}

	/**
	 * 保存员工数据
	 */
	@ResponseBody
	@RequestMapping(value = "/emp", method = RequestMethod.POST)
	public Msg saveEmp(@Valid Employee employee,BindingResult result) {
		if(result.hasErrors()){
		List<FieldError> fieldErrors = result.getFieldErrors();
		Map<String, Object> errors=new HashMap<String, Object>();
		for (FieldError fieldError : fieldErrors) {
			errors.put(fieldError.getField(), fieldError.getDefaultMessage());
		}
		return Msg.fail().add("errors", errors);
		}else {
			employeeService.saveEmp(employee);
			return Msg.success();
		}
		
	}

	/**
	 * 查询当前页面员工数据
	 * 
	 * @return
	 * @author: JSJ
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmps(
			@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
		// 查询前调用PageHelper.startPage()方法设置查询页数和每次显示几条记录;
		PageHelper.startPage(pn, 10);
		// 这个查询获取的值就是分页查询值;
		List<Employee> emps = employeeService.getAll();
		// 使用PageInfo封装页面
		PageInfo<Employee> page = new PageInfo<>(emps, 5);

		return Msg.success().add("pageInfo", page);
	}

	/*
	 * @RequestMapping("/emps") 
	 * public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn, 
	 * Model model){ 
	 * //查询前调用PageHelper.startPage()方法设置查询页数和每次显示几条记录;
	 * PageHelper.startPage(pn, 10); 
	 * //这个查询获取的值就是分页查询值; List<Employee>
	 * emps=employeeService.getAll();
	 * //使用PageInfo封装页面 PageInfo<Employee>
	 * page=new PageInfo<>(emps, 5); model.addAttribute("pageInfo", page);
	 * return "list"; 
	 * }
	 */
}

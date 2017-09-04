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
	 * ɾ����һԱ��
	 * @param id
	 * @return
	 * @author: JSJ
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	public Msg deleteEmp(@PathVariable("ids") String ids){
		//�ж��Ƿ�����ɾ��
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
	 * ������µ�Ա������
	 * @param employee
	 * @return
	 * @author: JSJ
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	public Msg updateEmp(Employee employee){
		//System.out.println("������µ�Ա����Ϣ: "+employee);
		try {
			employeeService.updateEmp(employee);
		} catch (Exception e) {
			return Msg.fail().add("update_email_msg", "�������ѱ�ʹ��");
		}
		
		return Msg.success();
	}
	
	/**
	 * ����id��ȡ����Ա����Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	public Msg getEmp(@PathVariable("id") Integer id){
	  	Employee employee = employeeService.getEmp(id);
	  	return Msg.success().add("emp", employee);
	}
	
	/**
	 * У������Ա���ʼ���ַ�Ƿ����
	 */
	@ResponseBody
	@RequestMapping("/checkEmail")
	public Msg checkEmail(@RequestParam("email") String email) {
		//�����ʽУ��
		  String regx="^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
		  if(!email.matches(regx)){
			  return Msg.fail().add("va_email","�����ַ��ʽ����");
		  }
		
		//���ݿ�����У��
		long a = employeeService.checkEmail(email);
		if (a > 0) {
			return Msg.fail().add("va_email", "�������ѱ�ʹ��");
		} else {
		    return Msg.success();
		}
	}

	/**
	 * У������Ա�������Ƿ����
	 */
	@ResponseBody
	@RequestMapping("/checkuser")
	public Msg checkuser(@RequestParam("empName") String empName) {
		//�û�����ʽУ��
		  String regx="(^[a-zA-Z0-9_-]{5,16}$)|(^[\u2E80-\u9FFF]{2,5}$)";
		  if(!empName.matches(regx)){
			  return Msg.fail().add("va_msg","�û���������2-5λ���ֻ�5-16λӢ����ĸ");
		  }
		
		//���ݿ��û���У��
		long b = employeeService.checkUser(empName);
		if (b > 0) {
			return Msg.fail().add("va_msg", "�û�����ռ��");
		} else {
		    return Msg.success();
		}
	}

	/**
	 * ����Ա������
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
	 * ��ѯ��ǰҳ��Ա������
	 * 
	 * @return
	 * @author: JSJ
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmps(
			@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
		// ��ѯǰ����PageHelper.startPage()�������ò�ѯҳ����ÿ����ʾ������¼;
		PageHelper.startPage(pn, 10);
		// �����ѯ��ȡ��ֵ���Ƿ�ҳ��ѯֵ;
		List<Employee> emps = employeeService.getAll();
		// ʹ��PageInfo��װҳ��
		PageInfo<Employee> page = new PageInfo<>(emps, 5);

		return Msg.success().add("pageInfo", page);
	}

	/*
	 * @RequestMapping("/emps") 
	 * public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn, 
	 * Model model){ 
	 * //��ѯǰ����PageHelper.startPage()�������ò�ѯҳ����ÿ����ʾ������¼;
	 * PageHelper.startPage(pn, 10); 
	 * //�����ѯ��ȡ��ֵ���Ƿ�ҳ��ѯֵ; List<Employee>
	 * emps=employeeService.getAll();
	 * //ʹ��PageInfo��װҳ�� PageInfo<Employee>
	 * page=new PageInfo<>(emps, 5); model.addAttribute("pageInfo", page);
	 * return "list"; 
	 * }
	 */
}

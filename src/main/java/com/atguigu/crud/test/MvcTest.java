package com.atguigu.crud.test;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.atguigu.crud.bean.Employee;
import com.github.pagehelper.PageInfo;

/**
 * 使用Spring测试模块中的请求测试功能
 * 
 * @author: JSJ
 * 
 */
@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
		"file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MvcTest {

	MockMvc mockMvc;

	@Autowired
	WebApplicationContext context;

	@Before
	public void initMockMvc() {
		mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
	}
    @Test
	public void testPage() throws Exception {
		//模拟请求并返回值
		MvcResult result=mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "6"))
				.andReturn();
       //请求成功后,请求域中会有PageInfo
		MockHttpServletRequest request=result.getRequest();
		PageInfo page=(PageInfo)request.getAttribute("pageInfo");
		System.out.println("当前页码: "+page.getPageNum());
		System.out.println("总页码: "+page.getPages());
		System.out.println("总记录数: "+page.getTotal());
	    int[] i=page.getNavigatepageNums();
	    System.out.println("当前页面显示页码数: ");
	    for (int j : i) {
			System.out.print(j);
		}
	    System.out.println("----------");
	    
	    List<Employee> list=page.getList();
	    for (Employee employee : list) {
			System.out.println("ID: "+employee.getEmpId()+"==>name: "+employee.getEmpName());
		}
	}
}

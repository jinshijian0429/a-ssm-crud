package com.atguigu.crud.test;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;

/**
 * 测试dao层的工作
 * @author: JSJ
 *推荐Spring的项目就可以使用Spirng单元测试,可以自动注入我们需要的组件
 *1.导入SpringTest jar包模块
 *2.@ContextConfiguration指定Spring配置文件的位置
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class MapperTest {
	@Autowired
     DepartmentMapper departmentMapper;
	@Autowired
	EmployeeMapper employeeMapper;
	@Autowired
	SqlSession sqlSession;
	
    @Test
	public void testCrud(){
    	//System.out.println(departmentMapper);
    	//departmentMapper.insertSelective(new Department(null, "测试部"));
        //批量插入
    	EmployeeMapper mapper=sqlSession.getMapper(EmployeeMapper.class);
    	for(int i=0;i<1000;i++){
    		String uid=UUID.randomUUID().toString().substring(0, 5)+i;
    		mapper.insertSelective(new Employee(null, uid, "M", uid+"@atguigu.com", 1));
    		
    	}
    	System.out.println("批量成功");
    }
}

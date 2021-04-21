package ${package}.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import ${package}.entity.${modelName};

import com.yzt.eface.mapper.${modelName}Mapper;
import com.yzt.eface.service.${modelName}Service;

<#assign mapper=modelName?uncap_first+"Mapper" >
/**
* ${modelRemark} Service
* @author ${author}
* @project ${project}
* @date  ${now?datetime}
*/
@Service
@Transactional
public class ${modelName}ServiceImpl extends ServiceImpl<${modelName}Mapper, ${modelName}> implements ${modelName}Service {

	<#assign isDelete=false>
	<#assign createDate=false>
	<#list columns as item>
		<#if item.name == "isDelete">
			<#assign  isDelete=true>
		</#if>
		<#if item.name == "createDate">
			<#assign  createDate=true>
		</#if>
	</#list>
	
	@Autowired
	private ${modelName}Mapper ${mapper};

	@Override
	public IPage<${modelName}> gePageList(${modelName} ${modelName?uncap_first}){
		QueryWrapper<${modelName}> queryWrapper = new QueryWrapper<>();

		<#if isDelete>
		queryWrapper.eq("is_delete", 0);
		</#if>
		<#if createDate>
		queryWrapper.orderByDesc("create_date");
		</#if>

		return channelMapper.selectPage(new Page<>(${modelName?uncap_first}.getPage(),${modelName?uncap_first}.getRows()),queryWrapper);
	}

}

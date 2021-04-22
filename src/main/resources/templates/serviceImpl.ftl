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
<#assign isDelete=false>
<#assign createDate=false>
<#assign sortValue=false>

<#list columns as item>
	<#if item.fieldName == "isDelete">
		<#assign  isDelete=true>
	</#if>
	<#if item.fieldName == "createDate">
		<#assign  createDate=true>
	</#if>
	<#if item.fieldName == "sortValue">
		<#assign  sortValue=true>
	</#if>
</#list>
<#if isDelete>
import com.yzt.eface.utils.MyConstant;
</#if>

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

	@Autowired
	private ${modelName}Mapper ${mapper};

	@Override
	public IPage<${modelName}> gePageList(${modelName} ${modelName?uncap_first}){
		QueryWrapper<${modelName}> queryWrapper = new QueryWrapper<>();

		<#if isDelete>
		//查询没有删除的
		queryWrapper.eq("is_delete", 0);
		</#if>
		<#if createDate>
		//按日期降序
		queryWrapper.orderByDesc("create_date");
		</#if>
		<#if sortValue>
		//按sort字段升序
		queryWrapper.orderByAsc("sort_value");
		</#if>

		return channelMapper.selectPage(new Page<>(${modelName?uncap_first}.getPage(),${modelName?uncap_first}.getRows()),queryWrapper);
	}

	@Override
    public boolean deleteById(String id) {
		<#if isDelete>
        //逻辑删除
        ${modelName} ${modelName?uncap_first} = new ${modelName}();
        ${modelName?uncap_first}.setId(id);
        ${modelName?uncap_first}.setIsDelete(MyConstant.IS_DELETE_YES);
        return this.${mapper}.updateById(${modelName?uncap_first}) > 0;
		<#else>
		//物理删除
        return this.${mapper}.deleteById(id);
		</#if>
    }

}

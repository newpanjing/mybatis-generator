<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="${package}.mapper.${modelName}Mapper" >
	
    <resultMap id="BaseResultMap" type="${package}.entity.${modelName}" >
        <id column="${idField}" property="${idFieldName}"/>
        <#list columns as item>
        <#if item.fieldName!=idFieldName>
        <result column="${item.name}" property="${item.fieldName}" jdbcType="${item.type}" />
        </#if>
   		 </#list>
    </resultMap>
	
   
    <sql id="Base_Column_List" >
		<#assign sign=false>
		<#list columns as item><#if sign==true>,</#if>${item.name}<#assign sign=true></#list>
    </sql>
   

</mapper>
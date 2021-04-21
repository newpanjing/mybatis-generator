package ${package}.entity;

import java.io.Serializable;

import ${package}.utils.PageUtil;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.validator.constraints.NotBlank;

import java.util.Date;

<#list packages as p>
import ${p};
</#list>

/**
 * ${modelRemark}实体</p>
 * ${modelName}对应数据库表 ${tableName}
 * @author ${author}
 * @project ${project}
 * @date  ${now?datetime}
 */
@ApiModel(value="${modelRemark}",description="${modelRemark}${modelName}" )
public class ${modelName} extends PageUtil implements Serializable {

	private static final long serialVersionUID = 1L;
	
	<#list columns as item>
	<#assign size="">
	<#if item.typeName == "String">
	<#assign size="，长度："+item.size>
	</#if>
	<#assign default="">
	<#if item.default??>
	<#assign default="，默认为："+item.default>
	</#if>

	<#if item.name == idField>
	//主键字段
	@ApiModelProperty("主键${idField}${size}${default}")
	@TableId
	</#if>
	<#if item.name != idField>
	@ApiModelProperty("${item.remark}${size}${default}")
	</#if>
	private ${item.typeName} ${item.fieldName};// ${item.remark} ${item.name}
	
	</#list>
	//set 和 get方法
	
	<#list columns as item>
	/**
	 * ${item.remark}
	 *
	 * @param ${item.fieldName}
	 */
	public void set${item.fieldName?cap_first}(${item.typeName} ${item.fieldName}) {
	
		this.${item.fieldName} = ${item.fieldName};
	}
	
	/**
	 * ${item.remark}
	 *
	 * @return ${item.typeName}
	 */
	public ${item.typeName} get${item.fieldName?cap_first}() {
	
		return this.${item.fieldName};
	}
	
	</#list>
	
	@Override
	public String toString() {
		<#assign sign=false>
		
		return "${modelName} [<#list columns as item><#if sign>,</#if>${item.fieldName}=" + ${item.fieldName} + "<#assign sign=true></#list>]";
	}
}

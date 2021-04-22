package ${package}.controller;


import com.yzt.eface.entity.${modelName};
import com.yzt.eface.service.${modelName}Service;

import com.yzt.eface.utils.Result;
import com.yzt.eface.utils.StatusCode;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.baomidou.mybatisplus.core.metadata.IPage;

import io.swagger.annotations.*;
import springfox.documentation.annotations.ApiIgnore;

/**
 * ${modelRemark} 控制器
 * @author ${author}
 * @project ${project}
 * @date  ${now?datetime}
 */
@Api(tags = "${modelRemark}")
@RestController
@RequestMapping("${requestUrl}")
public class ${modelName}Controller extends BaseController{

    <#if modelName??>
        <#assign  lower= modelName?uncap_first >
        <#assign service=lower+"Service" >
    </#if>
    @Autowired
    private ${modelName}Service ${service};

    /**
     * 新增或者修改
     *
     * @param ${lower}
     * @return
    */
    @ApiImplicitParams({
        <#list columns as item>
        <#if item.fieldName != "id"&&item.fieldName!="isDelete" && item.fieldName!="createDate">
        @ApiImplicitParam(value = "${item.remark}", name = "${item.fieldName}", required = true, dataType = "${item.typeName}"),
        </#if>
        <#if item.fieldName == "id">
        @ApiImplicitParam(value = "主键，修改的时候必填", name = "${item.fieldName}", required = false, dataType = "UUID"),
        </#if>
        </#list>
    })
    @ApiOperation(value = "新增或修改", notes = "如果id=null就是新增如，id!=null就是修改")
    @RequestMapping(value = "saveOrUpdate", method = RequestMethod.POST)
    public Result saveOrUpdate(@ApiIgnore @RequestBody ${modelName} ${lower}){
        Result result = Result.getError(StatusCode.SYSTEM_ERROR);

        boolean flag = ${service}.saveOrUpdate(${lower});

        if (flag){
            result = Result.getSuccess();
        }

        return result;
    }

    /**
	 * 删除
     *
	 * @param id
	 * @return
	 */
    @ApiOperation(value = "删除", notes = "根据id删除")
	@RequestMapping(value = "del", method = RequestMethod.POST)
	public Result del(@ApiParam(name = "主键id", required = true) String id){
		Result result = Result.getError();
		if (StringUtils.isNotBlank(id)){
			boolean flag = ${service}.deleteById(id);
			if (flag){
				result = Result.getSuccess();
			}
		}
		return result;
	}

    /**
	 * 列表
     *
	 * @param ${lower}
	 * @return
	 */
    @ApiOperation(value = "列表分页", notes = "根据page和rows进行分页，sort和order进行排序")
	@RequestMapping(value = "list", method = RequestMethod.POST)
    public Result<IPage<${modelName}>> getPageList(@RequestBody ${modelName} ${lower}){

        IPage<${modelName}> page = ${service}.gePageList(${lower});
        return Result.getSuccess(page);
    }
    
     /**
     * 获取详情
     *
     * @param id
     * @return
     */
    @ApiOperation(value = "获取详情", notes = "根据id获取数据详情")
    @RequestMapping(value = "detail", method = RequestMethod.POST)
    public Result<${modelName}> getDetail(@ApiParam(name = "主键id", required = true) String id) {
        ${modelName} ${modelName?uncap_first} = ${modelName?uncap_first}Service.getById(id);
        return Result.getSuccess(${modelName?uncap_first});
    }
}



